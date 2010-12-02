class MobileHelper
  
  def self.find_mobile(brand,model)
    return nil unless brand && model
    tx = Taxonomy.find_by_name('品牌')
    t = Taxon.find_by_name_and_taxonomy_id(brand, tx.id)
    return nil unless t
    ma = ModelAlia.where('brand_id=? and model=?', t.id, model)
    return nil if ma.empty?
    Product.find(ma[0].product_id)
  end

  def self.find_or_create(brand,model)
    p = self.find_mobile(brand,model)
    return p if p

    # create new product
    tx = Taxonomy.find_by_name('品牌')
    t  = Taxon.find_by_name_and_taxonomy_id(brand, tx.id)
    unless t
      txc = Taxon.find_by_name('国内品牌')
      t = Taxon.new(:name => brand, :taxonomy_id => txc.taxonomy_id, :parent_id => txc.id)
      t.save!
    end
    p = Product.create \
        :name => "#{brand} #{model}",
        :price => 0,
        :description => '',
        :available_on => Time.now,
        :brand_id => t.id
    p.taxons << t
    p.property('型号', model)
    p.save!
    ma = ModelAlia.new
    ma.product_id = p.id
    ma.model = model
    ma.brand_id = p.brand_id
    ma.save!
    p
  end
end