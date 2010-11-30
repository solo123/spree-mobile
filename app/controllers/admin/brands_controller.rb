class Admin::BrandsController < Admin::BaseController
  resource_controller

  def update
    t = Taxon.find(params[:id])
    if t.update_attributes(params[:taxon])
      flash[:notice] = 'Standard was successfully updated(jimmy).'
      redirect_to :action => :index
    else
      render :action => "edit"
    end
  end
  private
    def collection
      @gj = Taxon.find_by_name('国际品牌')
      @gn = Taxon.find_by_name('国内品牌')
      @gjpp = Taxon.find_all_by_parent_id(@gj, :order => 'name')
      @gnpp = Taxon.find_all_by_parent_id(@gn, :order => :name)
    end
    def model_name
      'taxon'
    end

end
