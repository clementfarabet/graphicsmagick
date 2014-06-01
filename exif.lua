-- Exif Parser
local function parseExif(exif)
   -- date
   local date = exif.DateTimeOriginal or exif.DateTimeDigitized or exif.DateTime
  
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
      if not l1 or not L1 then
         l1,l2 = exif.GPSLongitude:gfind('(.+),(.+)%w$')()
         L1,L2 = exif.GPSLatitude:gfind('(.+),(.+)%w$')()
         l3,L3 = 0,0
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

   -- Return date+location
   return date, location
end
return parseExif
