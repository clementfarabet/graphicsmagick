gm = require 'graphicsmagick'

lena = gm.load('lena.jpg')
gm.save('test_rgb.jpg',lena)

gm.save('test_gray.jpg',lena[2],70)
