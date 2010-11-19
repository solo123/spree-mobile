if Spree::Config.instance
  Spree::Config.set(:allow_ssl_in_production => false)
  Spree::Config.set(:default_locale => "zh")

	Spree::Config.set(:logo => "/images/site/logo.gif")
	Spree::Config.set(:stylesheets => 'screen')
	Spree::Config.set(:products_per_page => 12)
  Spree::Config.set(:allow_openid => false )
  Spree::Config.set(:default_country_id => 41 )
  Spree::Config.set(:list_per_page => 30)

  Spree::Config.set(:searcher => 'CoolpurSearch')
end 
