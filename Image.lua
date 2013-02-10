
-- FFI bindings to GraphicsMagick:
local ffi = require "ffi"
ffi.cdef
[[
  // Magick types:
  typedef void MagickWand;
  typedef int MagickBooleanType;
  typedef int ExceptionType;
  typedef int size_t;
  typedef int ChannelType;

  // Pixel formats:
  typedef enum
  {
    CharPixel,
    ShortPixel,
    IntegerPixel,
    LongPixel,
    FloatPixel,
    DoublePixel
  } StorageType;

  // Resizing filters:
  typedef enum
  {
    UndefinedFilter,
    PointFilter,
    BoxFilter,
    TriangleFilter,
    HermiteFilter,
    HanningFilter,
    HammingFilter,
    BlackmanFilter,
    GaussianFilter,
    QuadraticFilter,
    CubicFilter,
    CatromFilter,
    MitchellFilter,
    JincFilter,
    SincFilter,
    SincFastFilter,
    KaiserFilter,
    WelshFilter,
    ParzenFilter,
    BohmanFilter,
    BartlettFilter,
    LagrangeFilter,
    LanczosFilter,
    LanczosSharpFilter,
    Lanczos2Filter,
    Lanczos2SharpFilter,
    RobidouxFilter,
    RobidouxSharpFilter,
    CosineFilter,
    SplineFilter,
    LanczosRadiusFilter,
    SentinelFilter
  } FilterTypes;

  // Channels:
  typedef enum
  {
    UndefinedChannel,
    RedChannel,     /* RGB Red channel */
    CyanChannel,    /* CMYK Cyan channel */
    GreenChannel,   /* RGB Green channel */
    MagentaChannel, /* CMYK Magenta channel */
    BlueChannel,    /* RGB Blue channel */
    YellowChannel,  /* CMYK Yellow channel */
    OpacityChannel, /* Opacity channel */
    BlackChannel,   /* CMYK Black (K) channel */
    MatteChannel,   /* Same as Opacity channel (deprecated) */
    AllChannels,    /* Color channels */
    GrayChannel     /* Color channels represent an intensity. */
  } ChannelType;

  // Global context:
  void MagickWandGenesis();
  void InitializeMagick();
  
  // Magick Wand:
  MagickWand* NewMagickWand();
  MagickWand* DestroyMagickWand(MagickWand*);
  
  // Read/Write:
  MagickBooleanType MagickReadImage(MagickWand*, const char*);
  MagickBooleanType MagickReadImageBlob(MagickWand*, const void*, const size_t);
  MagickBooleanType MagickWriteImage(MagickWand*, const char*);
  unsigned char* MagickGetImageBlob(MagickWand*, size_t*);

  // Exception handling:
  const char* MagickGetException(const MagickWand*, ExceptionType*);

  // Dimensions:
  int MagickGetImageWidth(MagickWand*);
  int MagickGetImageHeight(MagickWand*);

  // Depth
  int MagickGetImageDepth(MagickWand*);
  unsigned int MagickSetImageDepth( MagickWand *wand, const unsigned long depth );

  // Resize:
  MagickBooleanType MagickResizeImage(MagickWand*, const size_t, const size_t, const FilterTypes, const double);

  // Set size:
  unsigned int MagickSetSize( MagickWand *wand, const unsigned long columns, const unsigned long rows );

  // Image format (JPEG, PNG, ...)
  const char* MagickGetImageFormat(MagickWand* wand);
  MagickBooleanType MagickSetImageFormat(MagickWand* wand, const char* format);

  // Raw data:
  unsigned int MagickGetImagePixels( MagickWand *wand, const long x_offset, const long y_offset,
                                     const unsigned long columns, const unsigned long rows,
                                     const char *map, const StorageType storage,
                                     unsigned char *pixels );
  unsigned int MagickSetImagePixels( MagickWand *wand, const long x_offset, const long y_offset,
                                     const unsigned long columns, const unsigned long rows,
                                     const char *map, const StorageType storage,
                                     unsigned char *pixels );
]]
-- Load lib:
local clib = ffi.load('Magick++')

-- Initialize lib:
clib.InitializeMagick();

-- Image object:
local Image = {
   name = 'magick.Image',
   path = '<>'
}

-- Metatable:
setmetatable(Image, {
   __call = function(self,...)
      return self.new(...)
   end
})

-- Constructor:
function Image.new(pathOrTensor, width, height)
   -- Create new instance:
   local image = {}
   for k,v in pairs(Image) do
      image[k] = v
   end

   -- Create Wand:
   image.wand = ffi.gc(clib.NewMagickWand(), function(wand)
      -- Collect:
      clib.DestroyMagickWand(wand)
   end)
  
   -- Arg?
   if type(pathOrTensor) == 'string' then
      -- Is a path:
      image:load(pathOrTensor, width, height)
   
   elseif type(pathOrTensor) == 'userdata' then
      -- Is a tensor:
      image:fromTensor(pathOrTensor)

   end
   
   -- 
   return image
end

-- Load image:
function Image:load(path, width, height)
   -- Load image:
   local status = clib.MagickReadImage(self.wand, path)
   
   -- Error?
   if status == 0 then
      clib.DestroyMagickWand(self.wand)
      error(self.name .. ': error loading image at path "' .. path .. '"')
   end

   -- Save path:
   self.path = path
end

-- Save image:
function Image:save(path)
   -- Format?
   local format = (path:gfind('%.(...)$')() or path:gfind('%.(....)$')()):upper()
   if format == 'JPG' then format = 'JPEG' end
   self:format(format)

   -- Save:
   local status = clib.MagickWriteImage(self.wand, path)

   -- Error?
   if status == 0 then
      error(self.name .. ': error saving image to path "' .. path .. '"')
   end
end

-- Size:
function Image:size(width,height,filter)
   -- Set or get:
   if width then
      -- Get filter:
      local filter = clib[(filter or 'Lanczos2') .. 'Filter']

      -- Bounding box?
      if not height then
         -- in this case, the image must fit in a widthxwidth box:
         local box = width
         local cwidth,cheight = self:size()
         if cwidth > cheight then
            width = box
            height = box * cheight/cwidth
         else
            height = box
            width = box * cwidth/cheight
         end
      end

      -- Set dimensions:
      local status = clib.MagickResizeImage(self.wand, width, height, filter, 1.0)

      -- Error?
      if status == 0 then
         error(self.name .. ': error resizing image')
      end
   else
      -- Get dimensions:
      width,height = clib.MagickGetImageWidth(self.wand), clib.MagickGetImageHeight(self.wand)
   end
   --
   return width,height
end

-- Depth:
function Image:depth(depth)
   -- Set or get:
   if depth then
      -- Set depth:
      clib.MagickSetImageDepth(self.wand, depth)
   else
      -- Get depth:
      local depth = clib.MagickGetImageDepth(self.wand)
   end
   --
   return depth 
end

-- Format:
function Image:format(format)
   -- Set or get:
   if format then
      -- Set format:
      clib.MagickSetImageFormat(self.wand, format)
   else
      -- Get format:
      format = ffi.string(clib.MagickGetImageFormat(self.wand))
   end
   return format
end

-- To Tensor:
function Image:toTensor(colorSpace, dataType)
   -- Torch+FII required:
   local ok = pcall(require, 'torchffi')
   if not ok then 
      error(Image.name .. '.toTensor: requires TorchFFI. Install it like this: luarocks install torchffi')
   end

   -- Dims:
   local width,height = self:size()

   -- Color space:
   colorSpace = colorSpace or 'RGB'  -- any combination of R, G, B, A, C, Y, M, K, and I
   -- common colorspaces are: RGB, RGBA, CYMK, and I

   -- Type:
   dataType = dataType or 'byte'
   local tensorType, pixelType
   if dataType == 'byte' then
      tensorType = 'ByteTensor'
      pixelType = 'CharPixel'
   elseif dataType == 'float' then
      tensorType = 'FloatTensor'
      pixelType = 'FloatPixel'
   elseif dataType == 'double' then
      tensorType = 'DoubleTensor'
      pixelType = 'DoublePixel'
   else
      error(Image.name .. ': unknown data type ' .. dataType)
   end

   -- Dest:
   local tensor = torch[tensorType](#colorSpace,height,width)

   -- Raw pointer:
   local ptx = torch.data(tensor)

   -- Export:
   clib.MagickGetImagePixels(self.wand, 
                             0, 0, width, height,
                             colorSpace, clib[pixelType],
                             ptx)

   -- Return tensor:
   return tensor
end

-- From Tensor:
function Image:fromTensor(tensor, colorSpace)
   -- Torch+FII required:
   local ok = pcall(require, 'torchffi')
   if not ok then 
      error(Image.name .. '.toTensor: requires TorchFFI. Install it like this: luarocks install torchffi')
   end

   -- Dims:
   local height,width,depth = tensor:size(1),tensor:size(2),tensor:size(3)

   -- Auto detect channels location:
   if height < width and height < depth and height <= 4 then
      -- Swap:
      tensor = tensor:transpose(1,3):transpose(1,2)
      height,width,depth = tensor:size(1),tensor:size(2),tensor:size(3)
   end
   
   -- Force contiguous:
   tensor = tensor:contiguous()
   
   -- Color space:
   colorSpace = colorSpace or 'RGB'  -- any combination of R, G, B, A, C, Y, M, K, and I
   -- common colorspaces are: RGB, RGBA, CYMK, and I

   -- Compat:
   assert(#colorSpace == depth, Image.name .. '.fromTensor: Tensor depth must match color space')

   -- Type:
   local ttype = torch.typename(tensor)
   if ttype == 'torch.FloatTensor' then
      pixelType = 'FloatPixel'
   elseif ttype == 'torch.DoubleTensor' then
      pixelType = 'DoublePixel'
   elseif ttype == 'torch.ByteTensor' then
      pixelType = 'CharPixel'
   else
      error(Image.name .. ': only dealing with float, double and byte')
   end
   
   -- Raw pointer:
   local ptx = torch.data(tensor)

   -- Resize image:
   self:load('xc:black')
   self:size(width,height)

   -- Export:
   clib.MagickSetImagePixels(self.wand, 
                             0, 0, width, height,
                             colorSpace, clib[pixelType],
                             ffi.cast("unsigned char *", ptx))

   -- Save path:
   self.path = '<tensor>'
end

-- Exports:
return Image

