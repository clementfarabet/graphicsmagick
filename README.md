GraphicsMagick
==============

A simple Lua wrapper to [GraphicsMagick](http://www.graphicsmagick.org).

gm.convert
----------

This is just a binding to the command line convert utility (images are not loaded
into Lua's memory). Examples:

```lua
gm = require 'graphicsmagick'
gm.convert{
   input = '/path/to/image.png',
   output = '/path/to/image.jpg',
   size = '128x128',
   quality = 95,
   verbose = true
}
```

gm.Image
--------

This is a full C interface to GraphicsMagick's Wand API. We expose one Class: the
Image class, which allows loading and saving images, transforming them, and
importing/exporting them from/to torch Tensors.

```lua
-- Lib:
gm = require 'graphicsmagick'

-- Load image:
image = gm.Image('/path/to/image.png')
-- or
image = gm.Image()
image:load('/path/to/image.png')

-- Get dims:
width,height = image:size()

-- Resize:
image:size(512,512)

-- Resize into box (keeps original aspect ratio):
image:size(512)

-- Export to Tensor:
type = 'byte'       -- 'double' or 'float'
colorSpace = 'RGB'  -- 'RGBA' or 'CYMK' or 'I'
tensor = image:toTensor(colorSpace, type)

-- Create from Tensor:
image:fromTensor(tensor)
-- or
image = gm.Image(tensor)

-- Save back to disk:
colorSpace = 'RGB'
image:save('/path/to/image.png', colorSpace)
```

