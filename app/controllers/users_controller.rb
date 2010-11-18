class UsersController < Spree::BaseController
  resource_controller

  ssl_required :new, :create, :edit, :update, :show

  actions :all, :except => [:index, :destroy]

  show.before do
    @orders = @user.orders.complete
  end

  create.after do
    Msg.user_registed(@user)
    create_session
    associate_user
  end

  create.flash nil
  create.wants.html { redirect_back_or_default(root_url) }

  new_action.before do
    flash.now[:notice] = I18n.t(:please_create_user) unless User.admin_created?
  end

  update.wants.html { render :partial => 'show_baseinfo' }

  update.after do
    create_session
  end

  #update.flash I18n.t("account_updated")

  def load_baseinfo
    @user = current_user
    render :partial => 'show_baseinfo'
  end
  def edit_baseinfo
     @user = current_user
    render :partial => 'edit_baseinfo'
  end



  private
  def object
    @object ||= current_user
  end

  def accurate_title
    I18n.t(:account)
  end

  def associate_user
    return unless current_order and @user.valid?
    current_order.associate_user!(@user)
    session[:guest_token] = nil
  end

  def create_session
    session_params = params[:user]
    session_params[:login] = session_params[:email]
    UserSession.create session_params
  end

end

