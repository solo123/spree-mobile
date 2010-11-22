class Admin::ProductTaxonsController < Admin::BaseController
  resource_controller  :except => [:show]

  def index
  end

  def show
    case params[:id]
    when 'taxon'
      r = []
      Taxon.find_all_by_name(params[:q]).each { |t| r << {:id => t.id, :name => t.name}}
      render :json => r
    when 'merge'
      t_src = Taxon.find_by_id(params[:src])
      t_tag = Taxon.find_by_id(params[:tag])
      i = 0
      Product.in_taxon(t_src).each do |p|
        p.taxons.delete(t_src)
        p.taxons << t_tag
        i = i + 1
      end
      render :text => "共合并#{i}个产品"
    end
  end
end