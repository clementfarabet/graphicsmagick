local gm = require 'graphicsmagick'

sys.execute('gm convert -background "rgb(128,128,128)" ' ..
  '-affine 0.906307787,-0.422618262,0.422618262,0.906307787,10,0 ' ..
  '-transform lena.jpg out_gm.jpg')

gm.Image()
  :load('lena.jpg')
  :setBackground(0.5, 0.5, 0.5)
  :affineTransform(0.906307787, -0.422618262, 0.422618262, 0.906307787, 10, 0)
  :save('out_th.jpg')

local out_gm = gm.Image()
  :load('out_gm.jpg')
  :toTensor()

local out_th = gm.Image()
  :load('out_th.jpg')
  :toTensor()

assert((out_gm:float() - out_th:float()):mean() < 1)
