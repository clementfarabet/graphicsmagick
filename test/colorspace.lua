
gm = require 'graphicsmagick'
require 'image'

i = gm.Image('lena.jpg')

-- Export image to a Tensor in LAB space:
t = i:toTensor('float','LAB','DHW')
print(i:colorspace())

-- Image looks funky:
image.display(t)

-- Import from tensor (no way of letting know 
-- gm that the image was in LAB, so it's stuck in LAB space):
ii = gm.Image(t, 'RGB', 'DHW')

-- Import other images:
image.display{ image = {
   gm.Image('forest.jpg'):toTensor('byte','LAB','DHW'),
   gm.Image('forest.jpg'):toTensor('byte','HSL','DHW'),
   gm.Image('forest.jpg'):toTensor('byte','HWB','DHW')
}}

