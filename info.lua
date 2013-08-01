
-- Dependencies:
require 'sys'

-- Detect/find GM:
local found = sys.execute('which identify'):find('identify')

-- Which util:
if found then
   util = 'identify '
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
local function info(path,simple,extexif)
   -- parse geometry
   local format = readarg(path,'"%m %w %h"')
   if format == '' or format:find('^PDF') then
      return {
         error = 'not an image'
      }
   end
   local format,width,height = format:gfind('(%w*)%s(%d*)%s(%d*)')()

   -- simple?
   if simple then
      return {
         width = tonumber(width),
         height = tonumber(height),
         format = format
      }
   end

   -- parse Exif Data
   local exif = readarg(path,'%[exif:*]')
   local formatted = (exif..'\n'):gsub('exif:(.-)=(.-)\n', '["%1"] = [========[%2]========],\n ')
   local ok,exif = pcall(loadstring( 'return {'..formatted..'}' ))
   if not ok then exif = {} end
  
   -- empty exif? use externally supplied exif
   if not next(exif) and extexif then
      exif = extexif
   end

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
