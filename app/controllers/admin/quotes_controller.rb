class Admin::QuotesController < Admin::BaseController
  resource_controller

  show.wants.html { redirect_to :action => :index }
  update.after { object.status = Quote::NEW_QUOTE;}

  def clear
    Quote.delete_all(['employee_id=? and status<10', current_user.id])
    redirect_to :action => :index
  end
  def check
    redirect_to 'login' unless current_user
    @p_brand = nil
    @quotes = Quote.all(:conditions => ['employee_id=? and status<10', current_user.id])
    @quotes.each do |q|
      p = MobileHelper.find_mobile(q.brand, q.model)
      if p
        q.brand_id = p.brand_id
        q.product_id = p.id
        q.price_old = p.price
        q.rel_model = ''
      else
        t = Taxon.find_by_name(q.brand)
        if t
          q.brand_id = t.id
          mds = ModelAlia.where('brand_id=? and model like ?', t.id, '%' + q.model + '%')
          q.rel_model = mds.collect{|md| md.model}.join(',')
          #q.rel_model = @p_models.grep(Regexp.new(q.model)).join(',')
        end
      end
      q.status = Quote::CHECKED
      q.save!
    end
    redirect_to :action => :index
  end

  def save
    supplier_id = params[:id].to_i
    if supplier_id <= 0
      render :text => 'ERROR: 没有选择供货商。'
      return
    end
    quotes = Quote.all(:conditions => ['employee_id=? and status=1', current_user.id])
    quotes.each do |quote|
      p = nil
      if quote.product_id && quote.product_id > 0
        p = Product.find(quote.product_id)
      else
        p = MobileHelper.find_or_create(quote.brand, quote.model)
        quote.product_id = p.id
      end
      p.property('批发价', quote.price) if quote.price
      p.property('报价备注', quote.remark) if quote.remark && !quote.remark.empty?
      p.available_on = Time.now unless p.available_on
      p.price = quote.price
      p.save!
      
      quote.status = Quote::IMPORTED
      quote.save!
    end
    render :text => 'ok'
  end

  def import
    bnd = params[:brand]
    data = params[:quotes]

    data.split("\n").each do |row|
      next unless row
      cols = row.split("\t")
      next unless cols && !cols.empty?

      q = Quote.new(:brand => bnd, :model => cols[0].upcase,
        :price => cols[1][cols[1].index(/\d/)..100].to_f,
        :remark => cols[2..100].join(','))
      q.remark = cols[1] + q.remark if cols[1] && (cols[1] =~ /[^\d\s]/)
      idx = cols[0].upcase.index(/[^A-Z0-9]/)
      if idx && idx > 0
        q.remark = q.model[idx..100] + (q.remark ? ' ' + q.remark : '')
        q.model = q.model[0..idx-1]
      end
      q.employee_id = current_user.id
      q.status = Quote::NEW_QUOTE
      q.save
    end
    render :text => 'ok'
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
    expire_fragment('quotations')
    render :text => 'refreshed quotations'
  end
  private
    def collection
      @collection ||= Quote.all(:conditions => ['employee_id=? and status<10', current_user.id])
    end
end
