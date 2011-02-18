
class Image < ActiveRecord::Base
  include ImageCropper
  include FacebookUploader

  has_attached_file :photo

  validates_presence_of :photo_file_name
  
  serialize :crop_data
  
  RATIO = 493.0 / 68.0

  def process
    files = ImageCropper.crop(self.photo.path, crop_x, crop_y, crop_width, crop_height)
    obj = FacebookUploader.upload(facebook_token, files.reverse, self.facebook_uid)
    FacebookUploader.tag(facebook_token, obj, self.facebook_uid, tag_uid)
  end
  

end
