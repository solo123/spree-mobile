class Admin::UploadController < Spree::BaseController
	skip_before_filter :verify_authenticity_token
	
  def configure_charsets
    @headers["Content-Type"]="text/html;charset=utf-8"
  end      

  def do_upload
    unless request.get?
      upload_file(params['Filedata'])
      render :text => '1'
    end
  end 

  private
  def upload_file(file)
    if !file.original_filename.empty?
      @filename = File.basename(file.original_filename) 
      File.open("#{RAILS_ROOT}/public/upload/#{@filename}", "wb") do |f|
        f.write(file.read)
      end
    end
  end

end
