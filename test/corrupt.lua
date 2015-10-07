local gm = require('graphicsmagick')

local readfile = function(fn)
  local f = io.open(fn,"rb")
  if not f then return nil end
  local data = f:read("*all")
  f:close()
  return data
end

local ok

-- load a corrupted JPEG created with zzuf:
--     zzuf -r 0.01 -s 1234 < city.jpg > city-corrupt.jpg
ok = pcall(gm.Image, 'city-corrupt.jpg')

-- check opening failed without malloc error or core dumped
assert(not ok, 'corrupted JPEG should not be loaded')

-- load this corrupted JPEG from a string
local str = assert(readfile('city-corrupt.jpg'))
local img = gm.Image()
ok = pcall(img.fromString, img, str)

assert(not ok, 'corrupted JPEG should not be loaded')
