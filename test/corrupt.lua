local gm = require('graphicsmagick')

-- load a corrupted JPEG created with zzuf:
--     zzuf -r 0.01 -s 1234 < city.jpg > city-corrupt.jpg
local ok, err = pcall(gm.Image, 'city-corrupt.jpg')

-- check opening failed without malloc error or core dumped
assert(not ok)
