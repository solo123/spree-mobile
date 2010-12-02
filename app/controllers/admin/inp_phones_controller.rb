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
        p = MobileHelper.find_mobile(inp.brand, inp.model)
        (inp.product_id = p.id; inp.status = 1; inp.save!) if p
      end
      render :text => 'match!'
    elsif params[:id] == 'do_import'
      InpPhone.where('status<=1 and brand is not null and model is not null').each do |inp|
        p = nil
        if status == 0 || !inp.product_id || inp.product_id == 0
          p = MobileHelper.find_or_create(inp.brand, inp.model)
        else
          p = Product.find(inp.product_id)
        end
        unless p
          inp.status = 7
          inp.save!
          next
        end
        pps = InpPhoneProp.find_all_by_phone_id(inp.id)
        if pps && pps.length > 0
          pps.each do |pp|
            p.property(pp.ref_prop, pp.val)
            p.add_taxon('制式', pp.val) if pp.ref_prop == '制式'
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