class Admin::InpPhonesController < Admin::BaseController
  resource_controller


  def create
    tx = []
    list = params[:list].to_a
    list.each do |line|
      if line[1] && line[1][0] && line[1][1] && !(line[1][0].strip.empty?) && !(line[1][1].strip.empty?)
        InpPhoneProp.where('prop=?', line[1][0]).each do |pp|
          pp.ref_prop = line[1][1]
          pp.save!
        end
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
      InpPhoneProp.select('DISTINCT prop').order(:prop).each {|p| @props << p.prop }
    elsif params[:id] == 'do_import'
      InpPhone.where('status=1 and product_id>0').each do |inp|
        p = Product.find(inp.product_id)
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
end