# mosaic image generator
# usage: mosaic.rb <foldername> <output_filename>
require 'RMagick'

foldername = ARGV[0] || '.'
output_path = ARGV[1] || './panda.png'

screen_width  = 1920 # 画面解像度 width
screen_height = 1200 # 画面解像度 height
image_width  = 220 # モザイクにする画像サイズ width
image_height = 220 # モザイクにする画像サイズ height
x = screen_width.div(image_width) + 1
y = screen_height.div(image_height) + 1

images = Magick::ImageList.new
list = Dir::entries(foldername).reject{|f| f == "." || f == ".."}
list.sort_by{rand}[0, x*y].each do |f|
  images.read("#{foldername}/#{f}")
end

white = Magick::Image.new(image_width, image_height){self.background_color = "white"}
tile = Magick::ImageList.new
page = Magick::Rectangle.new(0, 0, 0, 0)
images.scene = 0

y.times do |i|
    x.times do |j|
        tile << white.composite(images.scale(image_width, image_height), 0, 0, Magick::OverCompositeOp)
        page.x = j * tile.columns
        page.y = i * tile.rows
        tile.page = page
        (images.scene += 1) rescue images.scene = 0
    end
end
mosaic = tile.mosaic
mosaic.write(output_path)

