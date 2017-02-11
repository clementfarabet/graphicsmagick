local gm = require 'graphicsmagick'
require 'image'
require 'pl'

local function test_profile()
   local src = gm.Image("icc_v2_gbr.jpg")
   local raw = src:toTensor("float", "RGB", "DHW")

   assert(src:profile("icc"))
   assert(src:profile("icm"))
   assert(src:profile("iptc"))
   assert(src:profile("foobar") == nil)

   src:profile("icm", file.read("sRGB2014.icc")) -- pixels will be transformed
   assert(src:removeProfile():profile("icm") == nil)
   srgb = src:toTensor("float", "RGB", "DHW")

   image.display({image = raw, min = 0, max = 1, legend = "raw"})
   image.display({image = srgb, min = 0, max = 1, legend = "sRGB"})
end
test_profile()
