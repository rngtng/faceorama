module FacebookUploader

  def self.upload(token, files, uid)
    api = Koala::Facebook::GraphAndRestAPI.new(token)

    files.map do |file|
      file_hash = {
        "path" => file,
        "content_type" => 'image/jpeg'
      }
      api.put_picture(file_hash)["id"].to_i
    end
  end

  def self.tag(token, object_ids, uid, tag_uid)
    api      = Koala::Facebook::GraphAndRestAPI.new(token)
    album_id = api.rest_call("photos.getAlbums", :uid => uid)[1]["aid"]
    pictures = api.rest_call("photos.get", :aid => album_id)

    object_ids.each do |object_id|
      p = pictures.select { |u| u["object_id"] == object_id }

      args = {
        :pid => p.first["pid"],
        :tag_uid => tag_uid,
        :x => 10,
        :y => 10
      }
      api.rest_call("photos.addTag", args)
    end
  end

end