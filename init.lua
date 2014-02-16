-- Package:
local Image = require 'graphicsmagick.Image'
local convert = require 'graphicsmagick.convert'
local parseExif = require 'graphicsmagick.exif'
local info = require 'graphicsmagick.info'

local load = function(path,type)
   local img = Image(path)
   return img:toTensor(type or 'float','RGB','DHW')
end

local save = function(path,tensor,quality)
   local dim = tensor:nDimension()
   if dim == 2 or (dim == 3 and tensor:size(1) == 1) then
      tensor = tensor:reshape(1,tensor:size(dim-1),tensor:size(dim))
      tensor = tensor:expand(3,tensor:size(2),tensor:size(3))
   end
   local img = Image(tensor,'RGB','DHW')
   img:save(path,quality)
end

-- Export:
return {
   Image = Image,
   convert = convert,
   parseExif = parseExif,
   info = info,
   load = load,
   save = save
}
