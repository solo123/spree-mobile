class Admin::QuotesController < Admin::BaseController
  resource_controller

  show.wants.html { redirect_to :action => :index }
  update.after { object.status = Quote::NEW_QUOTE; object.save }
  create.after { object.employee_id = current_user.id; object.save }

  def clear
    biz = BizQuotes.new(current_user.id)
    biz.clear_quotes
    redirect_to :action => :index
  end
  def check
    biz = BizQuotes.new(current_user.id)
    biz.check_quotes
    redirect_to :action => :index
  end

  def save
    biz = BizQuotes.new(current_user.id)
    biz.import_quotes_to_product(params[:id].to_i)
    render :text => biz.error_message
  end

  def import
    biz = BizQuotes.new(current_user.id)
    bnd  = params[:brand]
    fl   = params[:type]
    data = params[:quotes]
    biz.import_text_block_to_quotes(bnd, fl, data)
    render :text => biz.error_message
  end

  def update_model
    txt = "none"
    quote = Quote.find(params[:q])
    model = params[:m].strip
    if quote.brand_id && quote.brand_id > 0 && !quote.model.strip.empty? && !model.empty?
      p = MobileHelper.find_mobile(quote.brand, model)
      if p
        ModelAlia.add_alias(p.id, quote.model)
        txt = "add alias #{p.id}-#{quote.model}"
      end
    end
    render :text => txt
  end

  def refresh_cache
    #expire_fragment %r{quotations.*}
    expire_fragment 'quotations'
    expire_fragment 'quotation-promo'
    expire_fragment 'quotation-table'
    render :text => '刷新报价缓存'
  end
  private
    def collection
      @collection ||= Quote.all(:conditions => ['employee_id=? and status<10', current_user.id])
    end
end
