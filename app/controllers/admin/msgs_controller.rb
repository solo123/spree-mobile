class Admin::MsgsController < Admin::BaseController

  def index
    @msgs = Msg.all
    if params[:id]
      s_msg = Msg.find_by_id(params[:id])
      
    end
  end

  def test
    if params[:mobile]
      r = Msg.send_sms_by_hyt(params[:mobile], params[:content])
      flash[:notice] = r.to_s
    end
  end
end
