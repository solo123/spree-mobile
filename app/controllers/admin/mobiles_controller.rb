class Admin::MobilesController < Admin::BaseController
  def index
    
  end

  def merge
    txt = MobileHelper.merge(params[:ids]) ? "已成功合并！" : "合并失败！"
    render :text => params[:ids].join(',').to_s + txt
  end
end
