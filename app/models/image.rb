
class Image < ActiveRecord::Base
  include ImageCropper

  has_attached_file :photo

  validates_presence_of :photo_file_name

  RATIO = 493.0 / 68.0

  def process
    files = ImageCropper.crop(self.photo.path, crop_x, crop_y, crop_width, crop_height)

    files.reverse.each do |file|
      upload_and_tag(file)
    end
  end

  def upload_and_tag(file)
    file_hash = { 'path' => file, 'content_type' => 'image/jpeg' }
    tag       = { 'tag_uid' => self.tag_uid.to_s, :x => 10, :y => 10 }
    api.put_picture(file_hash, {'tags' => [tag].to_json })
  end

  def api
    @api ||= Koala::Facebook::GraphAPI.new(self.facebook_token)
  end

end
