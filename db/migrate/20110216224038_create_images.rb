class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string   :photo_file_name
      t.string   :photo_content_type
      t.integer  :photo_file_size

      t.string   :facebook_token
      t.column   :facebook_uid, 'BIGINT UNSIGNED'
      t.string   :facebook_email
      t.column   :tag_uid, 'BIGINT UNSIGNED'

      t.integer  :crop_x
      t.integer  :crop_y
      t.integer  :crop_width
      t.integer  :crop_height

      t.integer  :progess
      t.text     :status

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
