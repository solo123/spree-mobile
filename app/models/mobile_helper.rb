class MobileHelper
  
  def self.find_mobile(brand,model)
    return nil unless brand && model
    tx = Taxonomy.find_by_name('品牌')
    return nil unless tx
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

  def self.merge(*ids)
    return false unless ids && ids.length > 1

    p0 = Product.find(ids[0])
    (1..ids.length - 1).each do |i|
      ModelAlia.where('product_id=?', ids[i]).each do |m|
        m.product_id = p0.id
        m.save!

        ProductProperty.where('product_id=?', ids[i]).each do |pp|
          pp1 = ProductProperty.find_by_product_id_and_property_id(p0.id, pp.property_id)
          if pp1
             pp1.value = pp.value if pp.value && pp.value.length > pp1.value.length
             pp1.save!
          else
            pp.product_id = p0.id
            pp.save!
          end
        end
      end
      p = Product.find(ids[i])
      p0.description = p.description if p.description && p.description.length > p0.description.length
      p.deleted_at = Time.now
      p.save!
    end
    p0.save
  end
end
