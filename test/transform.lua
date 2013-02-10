
gm = require 'graphicsmagick'

i = gm.Image()

i:load('city.jpg'):flop():size(1024):save('scaledup.jpg')

i:show()

