class Admin::InpPhonesController < Admin::BaseController
  resource_controller


  def create
    tx = []
    list = params[:list].to_a
    list.each do |line|
      if line[1] && line[1][0] && line[1][1] && !(line[1][0].strip.empty?) && !(line[1][1].strip.empty?)
        InpPhoneProp.update_all('ref_prop="' + line[1][1] + '"', 'prop="' + line[1][0] + '"')
        tx << "#{line[1][0]} = #{line[1][1]}\n"
      end
    end
    render :text => tx.join('')
  end

  def show
    if params[:id] == 'props'
      @props = []
      @sys_props = []
      Property.order(:name).each {|p| @sys_props << p.name }
      InpPhoneProp.select('DISTINCT prop').where('status<2').order(:prop).each {|p| @props << p.prop }
    elsif params[:id] == 'match'
      InpPhone.where('status=0').each do |inp|
        p = Product.find_by_brand_and_model(inp.brand, inp.model)
        (inp.product_id = p.id; inp.status = 1; inp.save!) if p
      end
      render :text => 'match!'
    elsif params[:id] == 'do_import'
      InpPhone.where('status<=1 and brand is not null and model is not null').each do |inp|
        p = nil
        if inp.status == 0 || !inp.product_id || inp.product_id == 0
          p = find_or_create(inp.brand, inp.model)
        else
          p = Product.find(inp.product_id)
        end
        nex unless p
        pps = InpPhoneProp.find_all_by_phone_id(inp.id)
        if pps && pps.length > 0
          pps.each do |pp|
            prop = Property.find_or_create_by_name_and_presentation(pp.ref_prop, pp.ref_prop)
            if p.properties.include? prop
              pv = ProductProperty.find_by_product_id_and_property_id(p.id, prop.id)
              if pv
                pv.value = pp.val
                pv.save!
              end
            else
              ProductProperty.create :property => prop, :product => p, :value => pp.val
            end
            if pp.ref_prop == '上市日期'
              p.list_date = pp.val
            end
            if pp.ref_prop == '制式'
              p.add_taxon('制式', pp.val)
            end
            pp.status = 1
            pp.save!
          end
        end
        inp.status = 2
        inp.save!
        p.save
      end
      render :text => 'do_import'
    end
  end


  private
    def collection
      base_scope = end_of_association_chain
      @search = base_scope.searchlogic(params[:search])
      @collection ||= @search.do_search.paginate(
        :per_page  => Spree::Config[:admin_products_per_page],
        :page      => params[:page])
    end
    def find_or_create(brand_name, model)
      @taxonomy_id ||= Taxonomy.find_by_name('品牌').id
      brand = Taxon.find_by_name_and_taxonomy_id(brand_name, @taxonomy_id)
      unless brand
        @brand_china ||= Taxon.find_by_name('国内品牌').id
        brand = Taxon.new(:name => brand_name, :taxonomy_id => @taxonomy_id, :parent_id => @brand_china)
        brand.save!
      end
      product = nil
      ps = Product.in_taxon(brand).where('model=?', model)
      if ps.length > 0
        product = Product.find_by_id(ps[0].id)
      else
        product = Product.create \
          :name => brand_name + " " + model,
          :price => 0,
          :description => '',
          :available_on => Time.now,
          :model => model

        product.taxons << brand
        @prop_model ||= Property.find_by_name("型号", "型号")
        ProductProperty.create :property => @prop_model, :product => product, :value => model
      end
      product
    end
end