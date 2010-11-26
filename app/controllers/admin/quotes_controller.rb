class Admin::QuotesController < Admin::BaseController
  resource_controller

  show.wants.html { redirect_to :action => :index }
  update.after { object.status = Quote::NEW_QUOTE; object.save! }

  def clear
    Quote.delete_all(['employee_id=? and status<10', current_user.id])
    redirect_to :action => :index
  end
  def check
    @p_brand = nil
    @quotes = Quote.all(:conditions => ['employee_id=? and status<10', current_user.id])
    @quotes.each do |q|
      t = Taxon.find_by_name(q.brand)
      if t
        q.brand_id = t.id
        p = Product.not_deleted.in_taxon(t).with_property_value('型号', q.model)
        if p.empty?
          q.product_id = 0
          unless @p_brand && @p_brand.id == t.id
            @p_brand = t
            @p_models = []
            Product.not_deleted.in_taxon(t).each { |ap| @p_models << ap.property('型号') }
          end
          q.rel_model = @p_models.grep(Regexp.new(q.model)).join(',')
        else
          q.product_id = p[0].id
          q.price_old = p[0].price
          q.rel_model = ''
        end
      else
        q.brand_id = 0
      end
      q.status = Quote::CHECKED
      q.save!
    end
    redirect_to :action => :index
  end

  def save
    supplier_id = params[:id].to_i
    if supplier_id <= 0
      render :text => 'ERROR: 没有选择供货商。'
      return
    end
    quotes = Quote.all(:conditions => ['employee_id=? and status<10', current_user.id])
    quotes.each do |quote|
      if !quote.brand_id || quote.brand_id == 0
        @brand ||= Taxon.find_by_name('国内品牌')
        b = Taxon.new(:taxonomy_id => @brand.taxonomy_id, :parent_id => @brand.id, :name => quote.brand)
        b.save!
        quote.brand_id = b.id
      end
      if !quote.product_id || quote.product_id == 0
        p = Product.create \
          :name => quote.brand + " " + quote.model,
          :price => quote.price, :description => '',
          :model => quote.model, :brand_id => quote.brand_id
        p.taxons << Taxon.find_by_id(quote.brand_id)
        @prop_model ||= Property.find_by_name("型号")
        ProductProperty.create :property => @prop_model, :product => p, :value => quote.model
        p.save!
        quote.product_id = p.id
      end
      product = Product.find_by_id(quote.product_id)
      update_prop(product, '批发价', quote.price) if quote.price
      update_prop(product, '报价备注', quote.remark) if quote.remark && !quote.remark.empty?
      product.available_on = Time.now unless product.available_on
      product.price = quote.price
      product.save!
      
      quote.status = 100
      quote.save!
    end
    render :text => 'ok'
  end

  def import
    bnd = params[:brand]
    data = params[:quotes]

    data.split("\n").each do |row|
      cols = row.split("\t")
      q = Quote.new(:brand => bnd, :model => cols[0],
        :price => cols[1][cols[1].index(/\d/)..100].to_f,
        :remark => cols[2..100].join(','))
      q.remark = cols[1] + q.remark if cols[1] && (cols[1] =~ /[^\d\s]/)
      q.employee_id = current_user.id
      q.status = Quote::NEW_QUOTE
      q.save
    end
    render :text => 'ok'
  end

  def update_model
    quote = Quote.find_by_id(params[:q])
    quote.model = params[:m]
    quote.save!
    render 'ok'
  end
  private
    def collection
      @collection ||= Quote.all(:conditions => ['employee_id=? and status<10', current_user.id])
    end

    def update_prop(product, property, prop_val)
      pp = Property.find_by_name(property)
      pp ||= Property.create(:name => property, :presentation => property)
      pv = ProductProperty.find_by_product_id_and_property_id(product.id, pp.id)
      if pv
        pv.value = prop_val
        pv.save!
      else
        ProductProperty.create :property => pp, :product => product, :value => prop_val
      end
    end


  def price_csv(filename)
    begin
      rows = []
      FasterCSV.foreach("#{RAILS_ROOT}/public/upload/" + filename) do |row|
        product = {:brand => row[0], :brand_chk => 0, :model => row[1], :rel_model => '', :price => row[2], :old_price => '', :remark => row[3]}

        t = Taxon.find_by_name(product[:brand])
        if t
          product[:brand_chk] = 1
          p = Product.in_taxon(t).with_property_value("型号", product[:model])
          product[:old_price] = p[0].price.to_s if p.length > 0
        end
        rows << product
      end
      rows
   	rescue => e
   		'ERROR: ' + e.to_s
   	end
	end
end
