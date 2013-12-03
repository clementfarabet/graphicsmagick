
-- Dependencies:
require 'sys'

-- Detect/find GM:
local found = sys.fexecute('which identify'):find('identify')

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
  
   -- use externally supplied exif to override some variables
   if extexif then
      for k,v in pairs(extexif) do
         exif[k] = v
      end
   end

   -- date
   local date = exif.DateTimeOriginal or exif.DateTimeDigitized or exif.DateTime
   date = date or readarg(path,'%[date:modify]')
  
   -- location
   local location
   if exif.GPSLongitudeRef then
      -- parse GPS, and generate URLs (Google Maps for now)
      local l1,l2,l3 = exif.GPSLongitude:gfind('(.+),%s+(.+),%s+(.+)')()
      local L1,L2,L3 = exif.GPSLatitude:gfind('(.+),%s+(.+),%s+(.+)')()
      if not l1 or not L1 then
         l1,l2,l3 = exif.GPSLongitude:gfind('(.+) deg (.+)\' (.+)"')()
         L1,L2,L3 = exif.GPSLatitude:gfind('(.+) deg (.+)\' (.+)"')()
      end
      local longitude, latitude
      if not l1 or not L1 then
         longitude = tonumber(exif.GPSLongitude)
         latitude = tonumber(exif.GPSLatitude)
      else
         longitude = loadstring('return ' .. l1 .. ' + ' .. l2 .. '/60 + ' .. l3 .. '/3600')()
         latitude = loadstring('return ' .. L1 .. ' + ' .. L2 .. '/60 + ' .. L3 .. '/3600')()
      end
      longitude = exif.GPSLongitudeRef:upper():sub(1,1) .. longitude
      latitude = exif.GPSLatitudeRef:upper():sub(1,1) .. latitude

      -- google lookup:
      local url_google = 'https://maps.google.com/maps?q=' ..  longitude .. ',' .. latitude

      -- save:
      location = {
         longitude = longitude,
         latitude = latitude,
         url_google = url_google,
      }
   elseif exif.GPSLongitude and tonumber(exif.GPSLongitude) then
      -- support floating point coordinates
      local latitude = tonumber(exif.GPSLatitude)
      if latitude < 0 then
         latitude = 'S'..math.abs(latitude)
      else
         latitude = 'N'..math.abs(latitude)
      end
      local longitude = tonumber(exif.GPSLongitude)
      if longitude < 0 then
         longitude = 'W'..math.abs(longitude)
      else
         longitude = 'E'..math.abs(longitude)
      end

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
