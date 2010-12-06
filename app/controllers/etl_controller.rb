class EtlController < Spree::BaseController
skip_before_filter :verify_authenticity_token

  def get_new_messages
    msg = Msg.all(:conditions => 'status=0')
    render :json => msg
  end

  def update_messages_status
    s = ''
    if params[:s1] && params[:s1].length > 0
      s = s + 'status = 1 : ' + Msg.update_all("status=1", "id in (#{params[:s1]})").to_s
    end
    if params[:s2] && params[:s2].length > 0
      s = s + 'status = 2 : ' + Msg.update_all("status=2", "id in (#{params[:s2]})").to_s
    end
    render :text => s
  end

  def get_mobile
    p = nil
    q = params[:q]
    p = Product.find_by_permalink(q) if q
    p = Product.find_by_id(q) if !p && q
    render :json => p
  end
end

