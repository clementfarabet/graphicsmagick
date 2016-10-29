
-- Dependencies:
require 'sys'

-- Detect/find identify:
local found, util
if sys.uname() == 'windows' then
  found = sys.fexecute('where gm'):find('gm')
  util = 'gm identify'
else
  found = sys.fexecute('which identify'):find('identify')
  util = 'identify'
end

if not found then
  return nil
end

-- Exif parser
local parseExif = require 'graphicsmagick.exif'

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
   local loadstring = loadstring or load
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

   -- parse:
   local date,location = parseExif(exif)

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
