#encoding: utf-8
class TaxonsController < Spree::BaseController
  #prepend_before_filter :reject_unknown_object, :only => [:show]
  before_filter :load_data, :only => :show
  resource_controller
  actions :show
  helper :products

  def show_all
    load_pre_data
  end
  private
  def load_data
    @taxon ||= object
    @products = Product.in_taxon(@taxon).where('list_date>"2010"').order('list_date desc')
  end
  def load_pre_data
    @taxon ||= object
    params[:taxon] = @taxon.id
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
  end

  def object
    @object ||= end_of_association_chain.find_by_permalink(params[:id] + "/")
  end

  def accurate_title
    @taxon ? @taxon.name : nil
  end
end
