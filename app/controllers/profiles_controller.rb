class ProfilesController < Spree::BaseController
  
  def index
    @profile = current_user.profile
    unless @profile
      @profile = Profile.new
      current_user.profile = @profile
      current_user.save!
    end
  end

  def save
    @profile = Profile.new(params[:profile])
    current_user.profile = @profile
    if @profile.invalid?
      flash[:notice] = "数据检查不正确，请检查表格中填写的内容。"
    else
      if @profile.save
        flash[:notice] = '您的详细信息保存成功。'
      else
        flash[:notice] = '数据保存出错。'
      end
    end
    redirect_to :action => 'index'
  end

  def update
    @profile = current_user.profile
    flash[:notice] = @profile.update_attributes(params[:profile]) ?
      '更新成功。' : '更新出错。'
    redirect_to :action => 'index'
  end
end
