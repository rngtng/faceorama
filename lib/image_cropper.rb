require 'mini_magick'

module ImageCropper

  #MAIN  = { width:180, height:180 }
  MAIN  = { width:493, height:68 }
  #  SMALL = { width:97, height:68, times:5, x:200, y:70, border_x:2 }
  SMALL = { width:97, height:68, times:5, x:0, y:0, border_x:2 }

  def self.crop(org_file, x = 0, y = 0, width = nil, height = nil)
    dest_directory = File.dirname(org_file)
    
    org_file = crop_image(org_file, "#{dest_directory}/cut.jpg", x, y, width, height)

    @files = []
    SMALL[:times].times do |cnt|
      file_name = "#{dest_directory}/#{cnt}.jpg"
      x = SMALL[:x] + (SMALL[:width] + SMALL[:border_x] ) * cnt
      y = SMALL[:y]
      @files << crop_image(org_file, file_name, x, y, SMALL[:width], SMALL[:height])
    end
    @files
  end

  private
  def self.crop_image(in_file, out_file, x, y, width, height)
    image = MiniMagick::Image.open(in_file)
    image.extract "#{width}x#{height}+#{x}+#{y}"
    image.resize "493x68" if width.to_i != 493
    image.quality 100
    image.write out_file
    out_file
  end

end