class ImagesController < ApplicationController
  before_filter :login_required

  def show
    @image = Image.find_by_id params[:id]
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new( params[:image] )
    @image.facebook_uid   = facebook_uid
    @image.facebook_token = facebook_token
    @image.save!

    respond_to do |format|
      format.js { render @image }
      format.html { redirect_to @image }
    end
  rescue
    respond_to do |format|
      format.js { render :text => "ERROR" }
      format.html { redirect_to images_path }
    end
  end

  def update
    @image = Image.find_by_id params[:id]
    @image.update_attributes(params[:image])
    @image.process
    respond_to do |format|
      format.js { render :text => "<a href='http://www.facebook.com/profile.php?id=#{@image.tag_uid}' target='_blank'>Check</a>" }
      format.html { redirect_to @image }
    end    
  end

end
