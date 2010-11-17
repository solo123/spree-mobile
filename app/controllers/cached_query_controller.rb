class CachedQueryController < ActionController::Base
  caches_page :brands
  
  def hello
    render :text => 'abc hello!'
  end

  def brands
    gjpp = []
    brands = Taxon.find_all_by_parent_id(Taxon.find_by_name('国际品牌').id, :order => 'lft')
    brands.each do |b|
      gjpp << {:brand => b.name, :permalink => b.permalink, :id => b.id, :count => Product.in_taxon(b).count }
    end
    gnpp = []
    brands = Taxon.find_all_by_parent_id(Taxon.find_by_name('国内品牌').id, :order => 'name')
    brands.each do |b|
      gnpp << {:brand => b.name, :permalink => b.permalink, :id => b.id, :count => Product.in_taxon(b).count }
    end

    pp = []
    pp << {:catalog => '国际品牌', :brands => gjpp}
    pp << {:catalog => '国内品牌', :brands => gnpp}
    render :json => pp
  end
end
