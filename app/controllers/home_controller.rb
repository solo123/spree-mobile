class HomeController < Spree::BaseController
	def index
    t = Taxon.find_by_name('主推机型')
    @products = Product.active().in_taxon(t)
	end
end
