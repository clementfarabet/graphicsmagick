local gm = require 'graphicsmagick'

local rgb = gm.Image('lena.jpg'):toTensor("float", "RGB", "DHW")
local rgba = torch.FloatTensor(4, rgb:size(2), rgb:size(3))
rgba[1]:copy(rgb[1])
rgba[2]:copy(rgb[2])
rgba[3]:copy(rgb[3])
rgba[4]:fill(0.5) -- alpha

gm.Image(rgba, "RGBA", "DHW"):format("PNG"):save("opacity50.png")
-- see saved image
