
gm = require 'graphicsmagick'

i = gm.Image('city.jpg', 256)  -- load image, at no more than 128x128 res (for speed)
   :size(256)                  -- size down, to fit into a 128x128 box
   :save('thumb.jpg')          -- save
   :show()

