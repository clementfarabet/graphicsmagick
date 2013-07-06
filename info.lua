
-- Dependencies:
require 'sys'

-- Detect/find GM:
local found_convert = sys.execute('which identify'):find('identify')
local found_gm = sys.execute('which gm'):find('gm')

-- Which util:
if found_convert then
   util = 'identify '
elseif found_gm then
   util = 'gm identify '
else
   return nil
end

-- Helper
local function readarg(file, arg)
   local cmd = util .. ' -format ' .. arg .. ' "' .. file .. '"'
   local p = io.popen(cmd)
   local res = p:read('*all'):gsub('%s*$','')
   p:close()
   return res
end

-- Command line info:
local function info(path)
   -- parse geometry
   local width = readarg(path,'%w')
   local height = readarg(path,'%h')
   local format = readarg(path,'%m')

   -- parse Exif Data
   local exif = readarg(path,'%[exif:*]')
   local formatted = (exif..'\n'):gsub('exif:(.-)=(.-)\n', '["%1"] = [========[%2]========],\n ')
   local ok,exif = pcall(loadstring( 'return {'..formatted..'}' ))
   if not ok then exif = {} end
   
   -- date
   local date = exif.DateTime or exif.DateTimeOriginal or exif.DateTimeDigitized
   date = date or readarg(path,'%[date:modify]')
  
   -- location
   local location
   if exif.GPSLongitudeRef then
      -- parse GPS, and generate URLs (Google Maps for now)
      local l1,l2,l3 = exif.GPSLongitude:gfind('(.+),%s+(.+),%s+(.+)')()
      local L1,L2,L3 = exif.GPSLatitude:gfind('(.+),%s+(.+),%s+(.+)')()
      local longitude = loadstring('return ' .. l1 .. ' + ' .. l2 .. '/60 + ' .. l3 .. '/3600')()
      local latitude = loadstring('return ' .. L1 .. ' + ' .. L2 .. '/60 + ' .. L3 .. '/3600')()
      longitude = exif.GPSLongitudeRef:upper() .. longitude
      latitude = exif.GPSLatitudeRef:upper() .. latitude

      -- google lookup:
      local url_google = 'https://maps.google.com/maps?q=' ..  longitude .. ',' .. latitude

      -- save:
      location = {
         longitude = longitude,
         latitude = latitude,
         url_google = url_google,
      }
   end

   -- return info
   return {
      width = tonumber(width),
      height = tonumber(height),
      format = format,
      exif = exif,
      date = date,
      location = location,
      moreinfo = function(format)
         if not format then
            print('please provide a format string [http://www.imagemagick.org/script/escape.php]')
            print('example: moreinfo("%m") will return the format')
            return
         end
         return readarg(path,format)
      end
   }
end

-- Exports:
return info
