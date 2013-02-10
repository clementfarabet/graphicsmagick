
-- 
-- this script demonstrates how to load a list of images from
-- a directoty, by using GraphicsMagick's ability to load
-- the smallest size required
--

gm = require 'graphicsmagick'
require 'pl'

opt = {
   dir = arg[1] or '.',      -- load all jpegs fro this dir
   maxsize = arg[2] or 128   -- resize down to 128x128
}

files = dir.getfiles(opt.dir)



print('Loading with no size hint (naive method):')

images = {}
t = torch.Timer()
for _,file in ipairs(files) do
   if file:lower():find('jpg$') or file:lower():find('jpeg$') then
      local img = gm.Image(file):size(opt.maxsize):toTensor('byte', 'RGB', 'DHW')
      table.insert(images, img)
   end
end
passed = t:time().real

print('Loaded ' .. #images .. ' images:', images, 'in ' .. passed .. ' seconds')



print('Loading with size hint (smart method):')

images = {}
t = torch.Timer()
for _,file in ipairs(files) do
   if file:lower():find('jpg$') or file:lower():find('jpeg$') then
      local img = gm.Image(file, opt.maxsize):size(opt.maxsize):toTensor('byte', 'RGB', 'DHW')
      table.insert(images, img)
   end
end
passed = t:time().real

print('Loaded ' .. #images .. ' images:', images, 'in ' .. passed .. ' seconds')
