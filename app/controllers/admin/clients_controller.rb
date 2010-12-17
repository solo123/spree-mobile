class Admin::ClientsController < Admin::BaseController
  def index

  end
  def carts
    @line_items = LineItem.all
  end
end