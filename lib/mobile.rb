require 'spree_core'
require 'mobile_hooks'

module Mobile
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
# extend Product
    Product.class_eval do
      def self.find_by_brand_and_model(brand,model)
        return nil unless brand && model
        tx = Taxonomy.find_by_name('品牌')
        t = Taxon.find_by_name_and_taxonomy_id(brand, tx.id)
        return nil unless t
        ps = Product.active.in_taxon(t).where('model=?', model)
        return nil unless ps && ps.length > 0
        ps[0]
      end
      def property(pname)
        p = self.properties.find_by_name(pname)
        ProductProperty.find_by_product_id_and_property_id(self.id, p.id).value if p
      end
      def taxon_val(tname)
        v = []
        t = Taxonomy.find_by_name(tname)
        if t
          self.taxons.find_all_by_taxonomy_id(t.id).each { |tt| v << tt.name }
        end
        v.join(',')
      end
      def taxon_name(tname)
        v = []
        t = Taxon.find_by_name(tname)
        if t
          self.taxons.find_all_by_parent_id(t.id).each { |ts| v << ts.name }
        end
        v
      end
    end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
