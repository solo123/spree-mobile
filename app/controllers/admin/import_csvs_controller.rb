#require 'faster_csv'

class Admin::ImportCsvsController < Admin::BaseController
  resource_controller :except => [:show]

  def index
    
  end
	
	def show
    if (params[:id] == 'parse')
      @ps = get_all_rows
      check_exist
      render :json => @ps.to_json
    end
    if (params[:id] == 'do_import')
      @ps = get_all_rows
      check_exist
      @imp_str = []
      @ps.each do |line|
        @imp_str << "Product:#{line['brand']}-#{line['model']}"
        product = find_or_create(line['brand'], line['model'])
        update_properties(product, line)
        product.save!
      end
      render :json => @imp_str
    end
	end
	
	def get_all_rows
    begin
      csv_file = params['csv']
      rows = []
      FasterCSV.foreach("#{RAILS_ROOT}/public/upload/" + csv_file, :headers => true) do |row|
        rows << parse_row(row)
      end
      rows
   	rescue => e
   		e.to_s
   	end
	end
	
	def parse_row(line)
    begin
      p = {}
      p['name'] = (line["名称"] ? line["名称"] : line["品牌"] + " " + line["型号"]).to_s
      p['permalink'] = line["货号"] ? line["货号"] : "CP-" + Time.now.strftime("%y%m%d").to_i.to_s(35) + "-" + ("%04d" % line["序号"].to_i)
      p['brand'] = line["品牌"].to_s.gsub(/ /, ' ').strip
      p_type = line["型号"].to_s.gsub(/ /, ' ').strip
      p_type = line["名称"].to_s.strip[/[^a-zA-Z0-9]+([a-zA-Z0-9]+)/,1] if !p_type && line["名称"]
      p['model'] = p_type
      p_price = line["批发价"]
      p_price="1.0" if !p_price
      p['price'] = p_price.to_s
      p['system'] = line["制式"].to_s.gsub(/ /, ' ').strip
      p['taxons'] = line["分类"].to_s.gsub(/ /, ' ').strip
		
      pp = {}
      s_field = "名称，品牌，型号，货号，详细信息，制式，序号，分类，图片"
      line.each do |c|
        next if s_field.include?(c[0])
        pp[c[0]] = c[1].to_s.gsub(/ /, ' ').strip
  		end
  		p['properties'] = pp
  		p['description'] = line["详细信息"].to_s
  		p
    rescue => e
      e.to_s
  	end
	end

	def check_exist
		@ps.each { |p| p['old'] = find_code_by_brand_and_model(p['brand'], p['model']) }
	end
  def find_code_by_brand_and_model(brand,model)
    p = Product.not_deleted.in_taxon(brand).with_property_value("型号",model)
    p.count > 0 ? p[0].permalink : nil
  end
  
  def find_product(product)
    p = Product.not_deleted.in_taxon(product['brand']).with_property_value("型号",product['model'])
    p[0] if p
  end


def find_or_create(brand_name, model)
  @taxonomy_id ||= Taxonomy.find_by_name('品牌').id
  brand = Taxon.find_by_name_and_taxonomy_id(brand_name, @taxonomy_id)
  unless brand
    @brand_china ||= Taxon.find_by_name('国内品牌').id

    brand = Taxon.new(:name => brand_name, :taxonomy_id => @taxonomy_id, :parent_id => @brand_china)
    brand.save!
  end
  product = nil
  ps = Product.in_taxon(brand).with_property_value("型号", model)
  if ps.length > 0
    product = Product.find_by_id(ps[0].id)
  else
    product = Product.create \
			:name => brand_name + " " + model,
			:price => 0,
			:description => '',
			:available_on => Time.now

		product.taxons << brand
    @prop_model ||= Property.find_by_name("型号", "型号")
		ProductProperty.create :property => @prop_model, :product => product, :value => model
  end
  product
end

def update_properties(product, mobile)

  add_simple_taxon("制式", product, mobile['system'])
  add_simple_taxon("分类", product, mobile['taxons'])

  mobile['properties'].each do |c|
    prop = Property.find_or_create_by_name_and_presentation(c[0],c[0])
    ProductProperty.create :property => prop, :product => p, :value => c[1]

    pp = Property.find_by_name(c[0])
    pp ||= Property.create(:name => c[0], :presentation => c[0])
    pv = ProductProperty.find_by_product_id_and_property_id(product.id, pp.id)
    if pv
      pv.value = c[1]
      pv.save!
    else
      ProductProperty.create :property => pp, :product => product, :value => c[1]
    end
  end
  #product.description = mobile.description if mobile.description && !mobile.description.empty?
end
	
	def add_simple_taxon(product, taxonomy, taxon_text)
		if taxon_text
			c_id = Taxonomy.find_or_create_by_name(taxonomy).id
			p_id = Taxon.find_by_name(taxonomy).id
			names = taxon_text.split(/\s*[,，、]\s*/)
			names.each do |name|
				product.taxons << Taxon.find_or_create_by_name_and_parent_id_and_taxonomy_id(name.strip, p_id, c_id)
			end
		end
	end
  
	def find_or_create_taxonomy
		@taxonomy_id = Taxonomy.find_or_create_by_name("品牌").id
		p_id = Taxon.find_by_name("品牌").id
		if @top_catalog.length > 0
			@taxonomy_brand = Taxon.find_or_create_by_name_and_parent_id_and_taxonomy_id(@top_catalog, p_id, @taxonomy_id).id
		else
			@taxonomy_brand = p_id
		end
	end
	def add_brand_taxon(brand)
		@the_taxons << Taxon.find_or_create_by_name_and_parent_id_and_taxonomy_id(brand.strip, @taxonomy_brand, @taxonomy_id)
	end	
	
end