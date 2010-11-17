class Admin::UsersController < Admin::BaseController
  resource_controller
  before_filter :load_roles, :only => [:edit, :new, :update, :create]

  create.before :set_random_password
  create.after :save_user_roles, :send_sms, :save_user_manager
  update.before :save_user_roles

  index.response do |wants|
    wants.html { render :action => :index }
    wants.json { render :json => @collection.to_json(:include => {:bill_address => {:include => [:state, :country]}, :ship_address => {:include => [:state, :country]}}) }
  end
  
  destroy.success.wants.js { render_js_for_destroy }

  private
  def collection
    unless request.xhr?
      @search = User.searchlogic(params[:search])

      #set order by to default or form result
      @search.order ||= "descend_by_created_at"

      @collection_count = @search.count
      @collection = @search.paginate(:per_page => Spree::Config[:admin_products_per_page],
                                     :page     => params[:page])

      #scope = scope.conditions "lower(email) = ?", @filter.email.downcase unless @filter.email.blank?
    else
      @collection = User.find(:all, :include => [
                                  {:bill_address => [:state, :country]},
                                  {:ship_address => [:state, :country]}],
                          :conditions => ["users.email like :search
                                            OR addresses.firstname like :search
                                            OR addresses.lastname like :search
                                            OR ship_addresses_users.firstname like :search
                                            OR ship_addresses_users.lastname like :search", {:search => "#{params[:q].strip}%"}], :limit => 20)
    end
  end

  def load_roles
    @roles = Role.all
  end

  def save_user_roles
    return unless params[:user]

    @user.roles.delete_all
    params[:user][:role] ||= {}
    params[:user][:role][:R1] = 1     # all new accounts have R1 role
    Role.all.each { |role|
      @user.roles << role unless params[:user][:role][role.name].blank?
    }
    params[:user].delete(:role)
  end

  def send_sms
    Msg.user_registed(@user)
  end

  def save_user_manager
    um = UserManager.new
    um.user_id = @user.id
    um.employee_id = current_user.id
    um.operator_id = current_user.id
    um.manage_type = 'sales'
    um.save
  end

  def set_random_password
    @user.password = @user.password_confirmation = '%05d' % rand(100000) + '8'
  end
end
