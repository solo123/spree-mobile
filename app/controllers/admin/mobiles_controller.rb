#encoding: utf-8
class Admin::MobilesController < Admin::BaseController
  def index
    
  end

  def merge
    txt = MobileHelper.merge(params[:ids]) ? "已成功合并！" : "合并失败！"
    render :text => params[:ids].join(',').to_s + txt
  end
  def image_order
    img = Asset.find(params[:image_id])
    img.position = params[:order]
    img.save
    render :text => img.position
  end
  def image_reorder
    p = Product.find(params[:id])
    p.images.order('attachment_file_name').each_with_index do |img, idx|
      img.position = idx
      img.save
    end
    render :text => 'ok'
  end
end
