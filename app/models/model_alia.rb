class ModelAlia < ActiveRecord::Base
  def self.product_alias(product_id)
    ModelAlia.find_all_by_product_id(product_id).collect { |a| a.model }.join(',')
  end
  def self.add_alias(product_id, product_alias)
    unless ModelAlia.find_by_product_id_and_model(product_id, product_alias)
      p = Product.find(product_id)
      ModelAlia.create(:product_id => product_id, :brand_id => p.brand_id, :model => product_alias)
    end
  end
  def self.set_alias(product_id, product_alias)
    return unless product_id && product_alias
    ss = product_alias.split(',')
    ss.each do |s|
      self.add_alias(product_id, s)
    end
    ModelAlia.find_all_by_product_id(product_id).each do |ma|
      ma.delete unless ss.find { |s| s == ma.model }
    end
  end
end
