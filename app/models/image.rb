
class Image < ActiveRecord::Base
  include ImageCropper

  has_attached_file :photo

  validates_presence_of :photo_file_name

  RATIO = 493.0 / 68.0

  @queue = :faceorama_image

  def self.perform(id, args = {})
    image = Image.find(id)
    image.try(:process!)
  end

  ##########################################################################################

  def async_process!(args = {})
    update_progress("sheduled")
    !!Resque.enqueue(Image, self.id, args)
  rescue
    false
  end

  def process!
    files = ImageCropper.crop(self.photo.path, crop_x, crop_y, crop_width, crop_height)
    update_progress("cropped")

    files.reverse.each do |file|
      upload_and_tag(file)
      update_progress
    end

    update_progress("finished")
  end

  ##########################################################################################

  def uploaded?
    !finished? && !cropped?
  end

  def cropped?
    !finished? && !self.crop_x.nil?
  end

  def finished?
    self.status == 'finished'
  end

  ##########################################################################################

  def upload_and_tag(file)
    file_hash = { 'path' => file, 'content_type' => 'image/jpeg' }
    tag       = { 'tag_uid' => self.tag_uid.to_s, :x => 10, :y => 10 }
    api.put_picture(file_hash, {'tags' => [tag].to_json })
  end

  def api
    @api ||= Koala::Facebook::GraphAPI.new(self.facebook_token)
  end

  ##########################################################################################

  def update_progress(msg = nil)
    self.progress ||= 0
    update_attribute(:progress, self.progress + 1)
    update_attribute(:status, msg) if msg
  end

end
