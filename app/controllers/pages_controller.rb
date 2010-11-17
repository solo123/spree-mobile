class PagesController < Spree::BaseController
  def index
    @page = Page.find_by_permalink(params[:id])
  end
end