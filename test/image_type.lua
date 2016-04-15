require 'pl'
local gm = require 'graphicsmagick'

-- true color
local city = gm:Image():load("city.jpg")
assert(city:type() == "TrueColor")

-- gray scale
city:clone():type("Grayscale"):save("city-gray.png")
local city_gray = gm:Image():load("city-gray.png")
assert(city_gray:type() == "Grayscale")

-- matte (alpha)
local rgb = city:toTensor("float", "RGB", "DHW")
local rgba = torch.FloatTensor(4, rgb:size(2), rgb:size(3))
rgba[1]:copy(rgb[1])
rgba[2]:copy(rgb[2])
rgba[3]:copy(rgb[3])
rgba[4]:fill(0.5)
gm.Image(rgba, "RGBA", "DHW"):format("PNG"):save("city-alpha.png")
local city_alpha = gm:Image():load("city-alpha.png")
assert(city_alpha:type() == "TrueColorMatte")

file.delete("city-gray.png")
file.delete("city-alpha.png")
