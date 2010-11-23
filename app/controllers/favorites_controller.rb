class FavoritesController < Spree::BaseController
  respond_to :json
  
  def my_taxons
    ids = []
    if current_user
      UserProduct.where('user_id=? and catalog_id=10', current_user.id).each { |t| ids << t.product_id }
    end
    respond_with ids
  end
  def my_products
    if current_user
      ps = UserProduct.where('user_id=? and catalog_id<10', current_user.id)
      respond_with ps
    else
      respond_with nil
    end
  end
end
