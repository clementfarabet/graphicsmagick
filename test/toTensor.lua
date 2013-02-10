
gm = require 'graphicsmagick'

i = gm.Image('lena.jpg')
t1 = i:toTensor()
t2 = i:toTensor('float', 'RGB', 'DHW')
t3 = i:toTensor('byte', 'RGBA', 'DHW')
t4 = i:toTensor('double', 'I', 'DHW')

print('Loaded:',{t1,t2,t3,t4})

ok = pcall(require, 'image')
if ok then
   image.display(t2)
   image.display(t3)
   image.display(t4)
end

