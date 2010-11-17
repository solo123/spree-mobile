class QuotationsController < Spree::BaseController
  
  def index
    r = nil
    if params[:b]
      t = Taxon.find_by_id(params[:b])
      r = Product.active().in_taxon(t)
    elsif params[:pl]
      r = Product.active().price_between(params[:pl], params[:ph])
    else
      t = Taxon.find_by_name('主推机型')
      r = Product.active().in_taxon(t)
    end
    @products = r.paginate(:per_page  => Spree::Config[:list_per_page],
                           :order => 'name',
                           :page      => params[:page])
  end

  def table
    gjpp = Taxon.find_by_name('国际品牌')
    @p_gj = Product.in_taxon(gjpp).active.price_between(50,8000).all(:order => 'name, updated_at desc')
    gnpp = Taxon.find_by_name('国内品牌')
    @p_gn = Product.in_taxon(gnpp).active.price_between(50,8000).all(:order => 'name, updated_at desc')
  end
end
