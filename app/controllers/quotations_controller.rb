class QuotationsController < Spree::BaseController
  
  def index
    redirect_to login_url unless current_user
    @products = Product.active.price_between(50,10000).order('name')
    @brands = Product.active.price_between(50,10000).select('DISTINCT brand_id, (select name from taxons where id=brand_id) as brand, count(*) as cnt').group('brand_id').order('cnt desc')
  end
  def get_list
    rs = []
    unless current_user
      render :json => rs
      return
    end

    Product.active.price_between(50,10000).each do |p|
      rs << [p.permalink, p.name, p.price, p.property('报价备注')]
    end
    render :json => rs
  end

  def table
    redirect_to login_url unless current_user
    gjpp = Taxon.find_by_name('国际品牌')
    @p_gj = Product.active.in_taxon(gjpp).active.price_between(50,8000).all(:order => 'brand_id, name, updated_at desc')
    gnpp = Taxon.find_by_name('国内品牌')
    @p_gn = Product.active.in_taxon(gnpp).active.price_between(50,8000).all(:order => 'brand_id, name, updated_at desc')
  end
  def promo_list
    ztjx = Taxon.find_by_name('主推机型')
    @p_zt = Product.active.in_taxon(ztjx).active.price_between(50,8000).all(:order => 'brand_id, name, updated_at desc')
    gjpp = Taxon.find_by_name('国际品牌')
    @p_gj = Product.active.in_taxon(gjpp).active.price_between(50,8000).where('date_sub(curdate(), interval 7 day) <= products.updated_at').all(:order => 'brand_id, name, updated_at desc')
    gnpp = Taxon.find_by_name('国内品牌')
    @p_gn = Product.active.in_taxon(gnpp).active.price_between(50,8000).where('date_sub(curdate(), interval 7 day) <= products.updated_at').all(:order => 'brand_id, name, updated_at desc')
  end

end
