class ImagesController < ApplicationController

  def show
    @image = Image.find_by_id(params[:id]) || Image.new

    respond_to do |format|
      format.js   { render :json => { :uid => facebook_uid, :image => @image } }
      format.html { render :action => :show }
    end
  end

  def new
    @image = Image.new

    respond_to do |format|
      format.js   { render :json => { :uid => facebook_uid, :image => @image } }
      format.html { render :action => :new }
    end
  end

  def create
    @image = Image.new( params[:image] )
    @image.facebook_uid   = facebook_uid
    @image.facebook_token = facebook_token
    @image.save!

    respond_to do |format|
      format.js   { render :json => { :uid => facebook_uid, :image => @image } }
      format.html { redirect_to @image }
    end
  # rescue => e
  #   respond_to do |format|
  #     format.js { render :json => { :error => e.message, :image => @image } }
  #     format.html { redirect_to images_path }
  #   end
  end

  def edit
    show
  end

  def update
    @image = Image.find_by_id params[:id]
    @image.update_attributes params[:image]
    
    @image.async_process!

    respond_to do |format|
      format.js   { render :json => { :uid => facebook_uid, :image => @image } }
      format.html { redirect_to @image }
    end
  #rescue => e
  #  respond_to do |format|
  #    format.js { render :json => { :error => e.message, :image => @image } }
  #    format.html { redirect_to images_path }
  #  end
  end

end
