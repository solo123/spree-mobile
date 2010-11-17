class Admin::SuppliersController < Admin::BaseController
  resource_controller

  show.wants.html { redirect_to :action => :index }
  index.wants.html { render 'suppliers.txt', :layout => false }
  def add
    s = Supplier.new(params[:supplier])
    s.save!
    render :text => 'ok'
  end

  private
    def collection
      if params[:q]
        cnd = params[:q]
        if /%u/.match cnd
          cnd = cnd.gsub(/%u/, '\u')
          t = JSON '["' + cnd + '"]'
          cnd = t[0]
        end
        @collection ||= end_of_association_chain.find(:all, :conditions => "concat(name,contact,phone,address) like '%"+ cnd +"%'")
      end
    end

end
