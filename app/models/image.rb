
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
    update_progress "sheduled"
    !!Resque.enqueue(Image, self.id, args)
  rescue
    false
  end

  def process!
    files = ImageCropper.crop(self.photo.path, crop_x, crop_y, crop_width, crop_height)

    files.reverse.each_with_index do |file, index|
      upload_and_tag(file)
      update_progress "uploaded #{index+1}"
    end

    update_progress "processed"
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
  def self.serialize_options
    {}.tap do |options|
      options[:only] = [:id, :status]
      options[:methods] = [:progress, :photo_url, :profile_url, :ratio]
    end
  end

  def as_json(options = {})
    super( options.merge(Image.serialize_options) )
  end

  ##########################################################################################

  def status
    read_attribute(:status) || 'new'
  end

  def photo_url
    self.photo.try(:url)
  end

  def profile_url
    self.tag_uid ? "http://www.facebook.com/profile.php?id=#{tag_uid}" : nil
  end

  def ratio
    RATIO
  end
 ##########################################################################################

  def update_progress=(msg)
    update_progress(msg)
  end

  def update_progress(msg)
    dirty = changed?
    self.progress ||= 0
    write_attribute(:progress, self.progress + 1)
    write_attribute(:status, msg)
    save! if !dirty && !new_record?
  end

end
