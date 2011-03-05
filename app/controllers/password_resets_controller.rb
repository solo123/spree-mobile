#encoding: utf-8
class PasswordResetsController < Spree::BaseController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    render
  end

def show
    if params[:id]
      if params[:c]
        UserCode.all(:conditions => ["created_at<?",(Time.now - 3600).utc]).each { |u| u.delete; }
        uc = UserCode.find_by_mobile_and_code(params[:id], params[:c])
        if uc && uc.created_at > Time.now - 3600
          render :text => uc.token
        else
          render :text => '0'
        end
        return
      end
      @user = User.find_by_mobile(params[:id])
      if @user
        rc = @user.deliver_password_reset_code
        cd = '%05d' % rand(100000) + '8'
        uc = UserCode.new
        uc.mobile = params[:id]
        uc.code = cd
        uc.token = rc
        uc.save!

        msg = Msg.new
        msg.sender = '重设密码'
        msg.sendee = @user.display_name
        msg.sendee_id = @user.id
        msg.address = @user.mobile
        msg.msg_type = 'SMS'
        msg.msg_title = '酷购coolpur.com'
        msg.msg_body = '酷购coolpur.com: 您申请了重设密码，验证码为' + cd + '，此验证码1小时内有效。'
        msg.status = 0
        msg.save!
        render :text => '1'
        return
      end
    end
    render :text => '0'
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash.notice = t("password_reset_instructions_are_mailed")
      redirect_to root_url
    else
      flash[:error] = t("no_user_found")
      render :action => :new
    end
  end

  def edit
    render
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash.notice = t("password_updated")
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash.notice = t("password_reset_token_not_found")
        redirect_to root_url
      end
    end

    def accurate_title
      I18n.t(:forgot_password)
    end

end

