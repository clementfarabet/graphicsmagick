local gm = require 'graphicsmagick'

local img = gm.Image('lena.jpg')
img:samplingFactors({2.0, 1.0, 1.0})
img:save("yuv420.jpg", 50)
print(img:samplingFactors())
-- jpeg:sampling-factor: 2x2,1x1,1x1
os.execute("identify -verbose yuv420.jpg|grep sampling")
os.execute("rm -f yuv420.jpg")

img:samplingFactors({1.0, 1.0, 1.0})
img:save("yuv444.jpg", 50)
print(img:samplingFactors())
-- jpeg:sampling-factor: 1x1,1x1,1x1
os.execute("identify -verbose yuv444.jpg|grep sampling")
os.execute("rm -f yuv444.jpg")
