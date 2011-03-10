#encoding: utf-8
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
      def property(*props)
        if props.length == 1
          p = self.properties.find_by_name(props[0])
          if p
            return ProductProperty.find_by_product_id_and_property_id(self.id, p.id).value
          else
            return nil
          end
        end
        pname = props[0]
        pvalue = props[1]
        return nil if !pname && pname.blank?
        pm = Property.find_by_name(pname)
        unless pm
          pm = Property.new
          pm.name = pm.presentation = pname
          pm.save! if pm.name && !pm.name.blank?
        end
        pp = ProductProperty.find_by_product_id_and_property_id(self.id, pm.id)
        if pp
          pp.value = pvalue
        else
          ProductProperty.create :property => pm, :product => self, :value => pvalue
        end
        #(self.list_date = pvalue; self.save) if pname == '上市日期'
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
      def add_taxon(taxonomy_name, taxon_name)
        pr = Taxon.find_by_name(taxonomy_name)
        return false unless pr
        taxon_name.split(/[,\/\\\s]/).each do |tn|
          if tn && !tn.blank?
            t = Taxon.find_or_create_by_name_and_parent_id_and_taxonomy_id(tn, pr.id, pr.taxonomy_id)
            self.taxons << t unless self.taxons.include? t
          end
        end
        true
      end
    end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
