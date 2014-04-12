
gm = require 'graphicsmagick'

i = gm.Image()

i:load('city.jpg'):flop():size(1024):save('scaledup.jpg')
i:load('city.jpg'):rotate(45):save('rotated.jpg')
i:load('city.jpg'):crop(256, 256, 10, 10):save('cropped.jpg')

i2 = i:clone()
i2:rotate(45)

i:show()
i2:show()
