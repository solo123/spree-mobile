module QuotationsHelper
  def show_price(price)
    price.to_d.to_s if price
  end
end
