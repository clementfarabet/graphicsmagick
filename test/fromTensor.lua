
gm = require 'graphicsmagick'

require 'image'

t1 = image.lena()
t2 = t1:clone():transpose(1,3):transpose(1,2):mul(255):byte()

print('Converting: ', {t1,t2})

i1 = gm.Image(t1,'RGB','DHW')
i2 = gm.Image(t2,'RGB','HWD')

i1:show()
i2:show()

