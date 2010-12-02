class Admin::QuotesController < Admin::BaseController
  resource_controller

  show.wants.html { redirect_to :action => :index }
  update.after { object.status = Quote::NEW_QUOTE;}

  def clear
    Quote.delete_all(['employee_id=? and status<10', current_user.id])
    redirect_to :action => :index
  end
  def check
    @p_brand = nil
    @quotes = Quote.all(:conditions => ['employee_id=? and status<10', current_user.id])
    @quotes.each do |q|
      p = MobileHelper.find_mobile(q.brand, q.model)
      if p
        q.brand_id = p.brand_id
        q.product_id = p[0].id
        q.price_old = p[0].price
        q.rel_model = ''
      else
        t = Taxon.find_by_name(q.brand)
        if t
          mds = MobileAlia.where('brand_id=? and model like ?', t.id, '%' + q.model + '%')
          q.rel_model = mds.join(',')
          #q.rel_model = @p_models.grep(Regexp.new(q.model)).join(',')
        else
          q.brand_id = 0
        end
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
    quotes = Quote.all(:conditions => ['employee_id=? and status=1', current_user.id])
    quotes.each do |quote|
      p = nil
      if quote.product_id && quote.product_id > 0
        p = Product.find(quote.product_id)
      else
        p = MobileHelper.find_or_create(quote.brand, quote.model)
        quote.product_id = p.id
      end
      p.property('批发价', quote.price) if quote.price
      p.property('报价备注', quote.remark) if quote.remark && !quote.remark.empty?
      p.available_on = Time.now unless p.available_on
      p.price = quote.price
      p.save!
      
      quote.status = Quote::IMPORTED
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
    model = params[:m].strip
    if quote.brand_id > 0 && !quote.model.strip.empty? && !model.empty?
      p = MobileHelper.find_mobile(q.brand, model)
      if p
        ma = ModelAlia.new
        ma.brand_id = quote.brand_id
        ma.model = params[:m].strip
        ma.product_id = p.id
        ma.save!
      else
        quote.model = model
        quote.save!
      end
    else
      quote.model = model
      quote.save!
    end
    render :text => 'ok'
  end

  def refresh_cache
    expire_fragment('quotations')
    render :text => 'refreshed quotations'
  end
  private
    def collection
      @collection ||= Quote.all(:conditions => ['employee_id=? and status<10', current_user.id])
    end
end
