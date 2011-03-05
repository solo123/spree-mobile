#encoding: utf-8
class QuotationsController < Spree::BaseController
  
  def index
    redirect_to login_url unless current_user
    @products = Product.not_deleted.price_between(50,10000).order('name')
    @brands = Product.not_deleted.price_between(50,10000).select('DISTINCT brand_id, (select name from taxons where id=brand_id) as brand, count(*) as cnt').group('brand_id').order('cnt desc')
  end
  def get_list
    rs = []
    unless current_user
      render :json => rs
      return
    end

    Product.not_deleted.price_between(50,10000).each do |p|
      rs << [p.permalink, p.name, p.price, p.property('报价备注')]
    end
    render :json => rs
  end

  def table
    redirect_to login_url unless current_user
    gjpp = Taxon.find_by_name('国际品牌')
    @p_gj = Product.not_deleted.in_taxon(gjpp).price_between(50,8000).all(:order => 'brand_id, name, updated_at desc')
    gnpp = Taxon.find_by_name('国内品牌')
    @p_gn = Product.not_deleted.in_taxon(gnpp).price_between(50,8000).all(:order => 'brand_id, name, updated_at desc')
  end
  def promo_list
    ztjx = Taxon.find_by_name('主推机型')
    @p_zt = Product.not_deleted.in_taxon(ztjx).price_between(50,8000).all(:order => 'brand_id, name, updated_at desc')
    gjpp = Taxon.find_by_name('国际品牌')
    @p_gj = Product.not_deleted.in_taxon(gjpp).price_between(50,8000).where('date_sub(curdate(), interval 7 day) <= variants.updated_at').all(:order => 'brand_id, name, updated_at desc')
    gnpp = Taxon.find_by_name('国内品牌')
    @p_gn = Product.not_deleted.in_taxon(gnpp).price_between(50,8000).where('date_sub(curdate(), interval 7 day) <= variants.updated_at').all(:order => 'brand_id, name, updated_at desc')
  end

end
