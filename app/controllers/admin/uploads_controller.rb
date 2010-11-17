class Admin::UploadsController < Admin::BaseController
  resource_controller  :except => [:show]

  def index
  end

  def show
    case params[:id]
    when 'files'
      fs = []
      params[:q] ? fn = params[:q] : fn = '*.*'
      Dir.glob("#{RAILS_ROOT}/public/upload/" + fn).sort_by {|f| File.mtime(f)}.reverse.each { |file| fs << File.basename(file) }
      render :json => fs
    when 'delete'
      filename = params[:f]
      File.delete("#{RAILS_ROOT}/public/upload/" + filename)
      render :text => '已删除文件：' +  filename
    end

  end
end