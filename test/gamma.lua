local gm = require 'graphicsmagick'
require 'image'

local function gamma_correction()
   local src = gm.Image("lena.jpg")
   local gamma_r = src:clone():gammaCorrection(0.5, "Red"):toTensor("float", "RGB", "DHW")
   local gamma_all = src:clone():gammaCorrection(0.5):toTensor("float", "RGB", "DHW")
   local gamma_all2 = src:clone():gammaCorrection(0.5, "All"):toTensor("float", "RGB", "DHW")

   assert((gamma_all - gamma_all2):abs():sum() == 0)

   image.display({image = src:toTensor("float", "RGB", "DHW"),
		  min = 0, max = 1, legend = "lena.jpg"})
   image.display({image = gamma_r,
		  min = 0, max = 1, legend = "gamma red = 0.5"})
   image.display({image = gamma_all,
		  min = 0, max = 1, legend = "gamma all = 0.5"})
end
local function embed_gamma_png()
   local src = gm.Image("lena.jpg")
   local display_gamma = 1.0 / 2.2 -- gamma for modern LCD
   local creator_gamma = 1.0 / 1.8 -- gamma for old macintosh

   -- Set gamma and save
   src:gamma(creator_gamma):format("PNG"):save("lena-gamma.png")
   print("Look at lena-gamma.png with web browser. ($ google-chrome lena-gamma.png) ")
   print("set gamma", src:gamma())

   local embed_gamma_image = gm.Image("lena-gamma.png")
   local embed_gamma = embed_gamma_image:gamma()
   print("get gamma", embed_gamma)

   -- embed_gamma == creator_gamma
   assert(1.79 < 1.0 / embed_gamma and 1.0 / embed_gamma < 1.81)

   -- src and embed_gamma_image are the same
   local a = src:toTensor("float", "RGB", "DHW")
   local b = embed_gamma_image:toTensor("float", "RGB", "DHW")
   assert((a - b):abs():sum() == 0)

   local gamma_for_correction = embed_gamma / display_gamma
   local corrected = embed_gamma_image:clone():gammaCorrection(gamma_for_correction)
   image.display({image = embed_gamma_image:toTensor("float", "RGB", "DHW"), 
		  min = 0, max = 1, legend = "pixel value"})
   image.display({image = corrected:toTensor("float", "RGB", "DHW"), 
		  min = 0, max = 1, legend = "gamma correction with embed gamma"})
end
local function gamma_resize()
   -- references: "Gamma error in picture scaling", http://www.4p8.com/eric.brasseur/gamma.html
   local gamma_default = 1.0 / 2.2
   local src = gm.Image('gamma_3x3.jpg')
   assert(src:colorspace() == "RGB")

   local gamma = src:gamma()
   if gamma == 0 then
      gamma = gamma_default
   end

   image.display({image = src:toTensor("float", "RGB", "DHW"),
		  min = 0, max = 1, legend = "gamma_3x3.jpg"})

   local width, height = src:size()
   local resize, gamma_resize

   -- Box filter
   resize = src:clone():size(width * 0.5, height * 0.5, "Box")
   image.display({image = resize:toTensor("float", "RGB", "DHW"),
		  min = 0, max = 1, legend = "resize box"})
   gamma_resize = src:clone():
      gammaCorrection(gamma):
      size(width * 0.5, height * 0.5, "Box"):
      gammaCorrection(1.0 / gamma)
   image.display({image = gamma_resize:toTensor("float", "RGB", "DHW"),
		  min = 0, max = 1, legend = "gamma resize box"})

   -- Lanczos filter
   resize = src:clone():size(width * 0.5, height * 0.5, "Lanczos")
   image.display({image = resize:toTensor("float", "RGB", "DHW"),
		  min = 0, max = 1, legend = "resize lanczos"})
   gamma_resize = src:clone():
      gammaCorrection(gamma):
      size(width * 0.5, height * 0.5, "Lanczos"):
      gammaCorrection(1.0 / gamma)
   image.display({image = gamma_resize:toTensor("float", "RGB", "DHW"),
		  min = 0, max = 1, legend = "gamma resize lanczos"})
end

gamma_correction()
embed_gamma_png()
gamma_resize()
