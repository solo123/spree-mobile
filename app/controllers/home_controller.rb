class HomeController < Spree::BaseController
	caches_page :index

	def index
    t = Taxon.find_by_name('主推机型')
    @products = Product.active().in_taxon(t)
	end

  def login_bar
    render :partial => 'shared/login_bar'
  end
  def userinfo
    if current_user
      a = { :id => current_user.id, :name => current_user.display_name, :stars => current_user.stars}
      render :json => a
    else
      render :text => ''
    end
  end
  def test
    redirect_to home_url
  end
end
