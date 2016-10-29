
-- Dependencies:
require 'sys'

-- Detect/find GM:
local findgm = sys.uname() == 'windows' and 'where gm' or 'which gm'
local found = sys.fexecute(findgm):find('gm')
if not found then
   print 'gm (GraphicsMagick) binary not found, please install (see www.graphicsmagick.org)'
end

-- Command line convert:
local function convert(...)
   -- args
   local args = dok.unpack(
      {...}, 
      'gm.convert',
      'Converts an image into another.',
      {arg='input',     type='string',   help='path to input image',    req=true},
      {arg='output',    type='string',   help='path to output image',   req=true},
      {arg='size',      type='string',   help='destination size'},
      {arg='rotate',    type='number',   help='rotation angle (degrees)'},
      {arg='vflip',     type='boolean',  help='flip image vertically'},
      {arg='hflip',     type='boolean',  help='flip image horizontally'},
      {arg='quality',   type='number',   help='quality (0 to 100)',     default=90},
      {arg='benchmark', type='boolean',  help='benchmark command',      default=false},
      {arg='verbose',   type='boolean',  help='verbose',                default=false}
   )

   -- hint input size:
   local options = {}
   if args.size then
      table.insert(options, '-size ' .. args.size)
   end

   -- input path:
   table.insert(options, args.input)

   -- unpack commands:
   for cmd,val in pairs(args) do
      if cmd == 'size' then
         table.insert(options, '-resize ' .. val)
      elseif cmd == 'rotate' then
         table.insert(options, '-rotate ' .. val)
      elseif cmd == 'quality' then
         table.insert(options, '-quality ' .. val)
      elseif cmd == 'verbose' and val then
         table.insert(options, '-verbose')
      elseif cmd == 'vflip' and val then
         table.insert(options, '-flip')
      elseif cmd == 'hflip' and val then
         table.insert(options, '-flop')
      end
   end
   
   -- output path:
   table.insert(options, args.output)

   -- pack command:
   local cmd
   if args.benchmark then
      cmd = 'gm benchmark convert '
   else
      cmd = 'gm convert '
   end
   cmd = cmd .. table.concat(options, ' ')

   -- exec command:
   if args.verbose then print(cmd) end
   os.execute(cmd)
end

-- Exports:
return (found and convert)

