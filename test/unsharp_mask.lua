local gm = require 'graphicsmagick'
require 'image'

local function unsharp_mask()
   local src = gm.Image("city.jpg")
   local unsharp1 = src:clone():unsharpMask(2, 1.0, 1.0, 0.02):toTensor("float", "RGB", "DHW")
   local unsharp2 = src:clone():unsharpMask(2, 1.4, 0.5, 0.0):toTensor("float", "RGB", "DHW")

   image.display({image = src:toTensor("float", "RGB", "DHW"),
		  min = 0, max = 1, legend = "city.jpg"})
   image.display({image = unsharp1,
		  min = 0, max = 1, legend = "UnsharpMask 2, 1.0, 1.0, 0.02"})
   image.display({image = unsharp2,
		  min = 0, max = 1, legend = "UnsharpMask 2, 1.4, 0.5, 0.0"})
end
unsharp_mask()
