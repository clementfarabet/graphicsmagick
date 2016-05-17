GraphicsMagick
==============

A simple Lua wrapper to [GraphicsMagick](http://www.graphicsmagick.org).

Only tested on Mac OSX, with GraphicsMagick installed via Homebrew.

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

gm.info
-------

Similarly, gm.info(file) is a simple binding to the command line utility.
It's handy to extra the geometry of an image, as well as its exif metadata.
On top of it, if geolocation is found, the GPS location is nicely formatted.

```lua
gm = require 'graphicsmagick'
info = gm.info('some.jpeg')
print(info)
{
   width : 1024
   height : 768
   date : 2013:01:01 00:00:01
   location :
     {
       longitude : W80.13
       latitude : N25.79
     }
   format : JPEG
   exif :
     {
        Make : Apple
        FocalLength : 413/100
        ...
     }
}
```

gm.Image
--------

This is a full C interface to GraphicsMagick's Wand API. We expose one Class: the
Image class, which allows loading and saving images, transforming them, and
importing/exporting them from/to torch Tensors.

Load library:

```lua
gm = require 'graphicsmagick'
```

First, we provide two high-level functions to load/save directly into/form tensors:

```lua
img = gm.load('/path/to/image.png' [, type])    -- type = 'float' (default) | 'double' | 'byte'
gm.save('/path/to/image.jpg' [,quality])        -- quality = 0 to 100 (for jpegs only)
```

The following provide a more controlled flow for loading/saving jpegs.

Create an image, from a file:

```lua
image = gm.Image('/path/to/image.png')
-- or
image = gm.Image()
image:load('/path/to/image.png')
```

Create an image, from a file, with a hint about the max size to be used:

```lua
image:load('/path/to/image.png', width [, height])

-- this tells the image loader that we won't need larger images than
-- what's specified. This can speedup loading by factors of 5 to 10.
```

Save an image to disk:

```lua
image:save('filename.ext')

-- where:
-- ext must be a know image format (jpg, JPEG, PNG, ...)
-- (GraphicsMagick supports tons of them)
```

Create an image, from a Tensor:

```lua
image = gm.Image(tensor,colorSpace,dimensions)
-- or
image = gm.Image()
image:load(tensor,colorSpace,dimensions)

-- where:
-- colorSpace is: a string made of these characters: R,G,B,A,C,Y,M,K,I
--                (for example: 'RGB', 'RGBA', 'I', or 'BGRA', ...)
--                R: red, G: green, ... I: intensity
--
-- dimensions is: a string made of these characters: D,H,W
--                (for example: 'DHW' or 'HWD')
--                D: depth, H: height, W: width
```

Export an image to a Tensor:

```lua
image = gm.Image('path.jpg')
image:toTensor(type,colorSpace,dimensions)

-- where:
-- type : 'float', 'double', or 'byte'
-- colorSpace : same as above
-- dimensions : same as above
```

When exporting Tensors, we can specify the color space:

```lua
lab = image:toTensor('float', 'LAB')
-- equivalent to:
image:colorspace('LAB')
lab = image:toTensor('float')

-- color spaces available, for now:
-- 'LAB', 'HSL', 'HWB' and 'YUV'
```

Images can also be read/written from/to Lua strings, or binary blobs.
This is convenient for in memory manipulation (e.g. when downloading
images from the web, no need to write it to disk):

```lua
blob,size = image:toBlob()
image:fromBlob(blob,size)

str = image:toString()
image:fromString(str)
```

In this library, we use a single function to read/write parameters
(instead of the more classical get/set). 

Here's an example of a resize:

```lua
-- get dimensions:
width,height = image:size()

-- resize:
image:size(512,384)

-- resize by only imposing the largest dimension:
image:size(512)

-- resize by imposing the smallest dimension:
image:size(nil,512)
```

Some basic transformations:

```lua
-- flip or flop an image:
image:flip()
image:flop()
```

Sharpen:

```lua
-- Sharpens the image whith radius=0, sigma=0.6
image:sharpen(0, 0.6)
```

Show an image (this makes use of Tensors, and Torch's Qt backend):

```lua
image:show()
```

One cool thing about this library is that all the functions can be cascaded.
Here's an example:

```lua
-- Open, transform and save back:
gm.Image('input.jpg'):flip():size(128):save('thumb.jpg')
```
