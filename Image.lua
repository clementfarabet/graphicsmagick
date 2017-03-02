-- FFI bindings to GraphicsMagick:
local ffi = require "ffi"
ffi.cdef
[[
  // free
  void free(void *);
  unsigned int MagickRelinquishMemory( void *resource );

  // Magick types:
  typedef void MagickWand;
  typedef int MagickBooleanType;
  typedef int ExceptionType;
  typedef int size_t;
  typedef int ChannelType;
  typedef void PixelWand;
  typedef void DrawingWand;

  // Pixel formats:
  typedef enum
  {
    CharPixel,
    ShortPixel,
    IntPixel,
    LongPixel,
    FloatPixel,
    DoublePixel,
  } StorageType;

  // Noise types:
  typedef enum
  {
    UniformNoise,
    GaussianNoise,
    MultiplicativeGaussianNoise,
    ImpulseNoise,
    LaplacianNoise,
    PoissonNoise,
    RandomNoise,
    UndefinedNoise
  } NoiseType;

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
    LanczosFilter,
    BesselFilter,
    SincFilter
  } FilterTypes;

  typedef enum
  {
    UndefinedCompositeOp = 0,
    OverCompositeOp,
    InCompositeOp,
    OutCompositeOp,
    AtopCompositeOp,
    XorCompositeOp,
    PlusCompositeOp,
    MinusCompositeOp,
    AddCompositeOp,
    SubtractCompositeOp,
    DifferenceCompositeOp,
    MultiplyCompositeOp,
    BumpmapCompositeOp,
    CopyCompositeOp,
    CopyRedCompositeOp,
    CopyGreenCompositeOp,
    CopyBlueCompositeOp,
    CopyOpacityCompositeOp,
    ClearCompositeOp,
    DissolveCompositeOp,
    DisplaceCompositeOp,
    ModulateCompositeOp,
    ThresholdCompositeOp,
    NoCompositeOp,
    DarkenCompositeOp,
    LightenCompositeOp,
    HueCompositeOp,
    SaturateCompositeOp,
    ColorizeCompositeOp,
    LuminizeCompositeOp,
    ScreenCompositeOp,
    OverlayCompositeOp,
    CopyCyanCompositeOp,
    CopyMagentaCompositeOp,
    CopyYellowCompositeOp,
    CopyBlackCompositeOp,
    DivideCompositeOp,
    HardLightCompositeOp,
    ExclusionCompositeOp,
    ColorDodgeCompositeOp,
    ColorBurnCompositeOp,
    SoftLightCompositeOp,
    LinearBurnCompositeOp,
    LinearDodgeCompositeOp,
    LinearLightCompositeOp,
    VividLightCompositeOp,
    PinLightCompositeOp,
    HardMixCompositeOp
  } CompositeOperator;

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

  // Color spaces:
  typedef enum
  {
    UndefinedColorspace,
    RGBColorspace,         /* Plain old RGB colorspace */
    GRAYColorspace,        /* Plain old full-range grayscale */
    TransparentColorspace, /* RGB but preserve matte channel during quantize */
    OHTAColorspace,
    XYZColorspace,         /* CIE XYZ */
    YCCColorspace,         /* Kodak PhotoCD PhotoYCC */
    YIQColorspace,
    YPbPrColorspace,
    YUVColorspace,
    CMYKColorspace,        /* Cyan, magenta, yellow, black, alpha */
    sRGBColorspace,        /* Kodak PhotoCD sRGB */
    HSLColorspace,         /* Hue, saturation, luminosity */
    HWBColorspace,         /* Hue, whiteness, blackness */
    LABColorspace,         /* LAB colorspace not supported yet other than via lcms */
    CineonLogRGBColorspace,/* RGB data with Cineon Log scaling, 2.048 density range */
    Rec601LumaColorspace,  /* Luma (Y) according to ITU-R 601 */
    Rec601YCbCrColorspace, /* YCbCr according to ITU-R 601 */
    Rec709LumaColorspace,  /* Luma (Y) according to ITU-R 709 */
    Rec709YCbCrColorspace  /* YCbCr according to ITU-R 709 */
  } ColorspaceType;

  // Image Type
  typedef enum
  {
    UndefinedType,
    BilevelType,
    GrayscaleType,
    GrayscaleMatteType,
    PaletteType,
    PaletteMatteType,
    TrueColorType,
    TrueColorMatteType,
    ColorSeparationType,
    ColorSeparationMatteType,
    OptimizeType
  } ImageType;

  // InterlaceType
  typedef enum
  {
    UndefinedInterlace,
    NoInterlace,
    LineInterlace,
    PlaneInterlace,
    PartitionInterlace
  } InterlaceType;

  // Global context:
  void MagickWandGenesis();
  void InitializeMagick();

  // Magick Wand:
  MagickWand* NewMagickWand();
  MagickWand* DestroyMagickWand(MagickWand*);
  MagickWand* CloneMagickWand( const MagickWand *wand );

  //
  PixelWand *NewPixelWand(void);
  PixelWand *DestroyPixelWand(PixelWand *wand);
  void PixelSetRed(PixelWand *wand,const double red);
  void PixelSetGreen(PixelWand *wand,const double green);
  void PixelSetBlue(PixelWand *wand,const double blue);

  // Read/Write:
  MagickBooleanType MagickReadImage(MagickWand*, const char*);
  MagickBooleanType MagickReadImageBlob(MagickWand*, const void*, const size_t);
  MagickBooleanType MagickWriteImage(MagickWand*, const char*);
  unsigned char *MagickWriteImageBlob( MagickWand *wand, size_t *length );

  // Quality:
  unsigned int MagickSetCompressionQuality( MagickWand *wand, const unsigned long quality );

  //Exception handling:
  char* MagickGetException(const MagickWand*, ExceptionType*);

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
  char* MagickGetImageFormat(MagickWand* wand);
  MagickBooleanType MagickSetImageFormat(MagickWand* wand, const char* format);

  // Image interlace
  unsigned int MagickSetInterlaceScheme( MagickWand *wand,
                                     const InterlaceType interlace_scheme );

  // Raw data:
  unsigned int MagickGetImagePixels( MagickWand *wand, const long x_offset, const long y_offset,
                                     const unsigned long columns, const unsigned long rows,
                                     const char *map, const StorageType storage,
                                     unsigned char *pixels );
  unsigned int MagickSetImagePixels( MagickWand *wand, const long x_offset, const long y_offset,
                                     const unsigned long columns, const unsigned long rows,
                                     const char *map, const StorageType storage,
                                     unsigned char *pixels );

  // Flip/Flop
  unsigned int MagickFlipImage( MagickWand *wand );
  unsigned int MagickFlopImage( MagickWand *wand );

  // Rotate
  unsigned int MagickRotateImage( MagickWand *wand, const PixelWand *background,
                                const double degrees );

  // Crop
  unsigned int MagickCropImage( MagickWand *wand, const unsigned long width,
                              const unsigned long height, const long x, const long y );
  unsigned int MagickBorderImage( MagickWand *wand, const PixelWand *bordercolor,
                                const unsigned long width, const unsigned long height );

  // Processing
  unsigned int MagickColorFloodfillImage( MagickWand *wand, const PixelWand *fill,
                                        const double fuzz, const PixelWand *bordercolor,
                                        const long x, const long y );
  unsigned int MagickNegateImage( MagickWand *wand, const unsigned int gray );
  unsigned int MagickSetImageBackgroundColor( MagickWand *wand, const PixelWand *background );
  MagickWand *MagickFlattenImages( MagickWand *wand );
  unsigned int MagickBlurImage( MagickWand *wand, const double radius, const double sigma );
  unsigned int MagickAddNoiseImage( MagickWand *wand, const NoiseType noise_type );
  unsigned int MagickColorizeImage( MagickWand *wand, const PixelWand *colorize,
                                  const PixelWand *opacity );

  // Composing
  unsigned int MagickCompositeImage( MagickWand *wand, const MagickWand *composite_wand,
                                   const CompositeOperator compose, const long x,
                                   const long y );

  // Colorspace:
  ColorspaceType MagickGetImageColorspace( MagickWand *wand );
  unsigned int MagickSetImageColorspace( MagickWand *wand, const ColorspaceType colorspace );

  // Description
  char *MagickDescribeImage( MagickWand *wand );

  // SamplingFactors
  double *MagickGetSamplingFactors(MagickWand *,unsigned long *);
  unsigned int MagickSetSamplingFactors(MagickWand *,const unsigned long,const double *);

  // ImageType
  unsigned int MagickSetImageType( MagickWand *, const ImageType );
  ImageType MagickGetImageType( MagickWand *);

  DrawingWand *MagickNewDrawingWand( void );
  void MagickDestroyDrawingWand( DrawingWand *drawing_wand );
  typedef struct _AffineMatrix
  {
    double
      sx,
      rx,
      ry,
      sy,
      tx,
      ty;
  } AffineMatrix;
  void MagickDrawAffine( DrawingWand *drawing_wand, const AffineMatrix *affine );
  unsigned int MagickAffineTransformImage( MagickWand *wand, const DrawingWand *drawing_wand );

  double MagickGetImageGamma(MagickWand *wand);
  unsigned int MagickSetImageGamma(MagickWand *wand, const double gamma);
  unsigned int MagickGammaImage(MagickWand *wand, const double gamma);
  unsigned int MagickGammaImageChannel(MagickWand *wand,
                                       const ChannelType channel_type,
                                       const double gamma);

  unsigned int MagickSharpenImage(MagickWand *wand,
                                  const double radius,
                                  const double sigma); 

  unsigned int MagickUnsharpMaskImage(MagickWand* wand,
                                      const double radius,
                                      const double sigma,
                                      const double amount,
                                      const double threshold);

  // Profile
  unsigned char* MagickGetImageProfile(MagickWand *wand,const char *name,unsigned long *length);
  unsigned int MagickProfileImage(MagickWand* wand, const char* name,
                                  const void* profile, const size_t length);
]]

-- Load and initialize lib:
local magiclib, clib = nil, nil
if ffi.os == 'Windows' then
    magiclib = ffi.load('CORE_RL_magick_.dll')
    clib = ffi.load('CORE_RL_wand_.dll')
    magiclib.InitializeMagick();
else
    clib = ffi.load('GraphicsMagickWand')
    clib.InitializeMagick();
end

-- Image object:
local Image = {
   name = 'magick.Image',
   path = '<>',
   buffers = {
      HWD = {},
      DHW = {},
   }
}

-- Metatable:
setmetatable(Image, {
   __call = function(self,...)
      return self.new(...)
   end
})

-- Wrapper around `MagickGetException` to report errors:
local function magick_error(self, ctx)
   ctx = ctx or 'error'
   local etype = ffi.new('int[1]')
   local descr = ffi.gc(
      clib.MagickGetException(self.wand, etype),
      clib.MagickRelinquishMemory
   )
   error(string.format(
      '%s: %s: %s (ExceptionType=%d)',
      self.name, ctx, ffi.string(descr), etype[0]
   ))
end

-- Constructor:
function Image.new(pathOrTensor, ...)
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
      image:load(pathOrTensor, ...)

   elseif type(pathOrTensor) == 'userdata' then
      -- Is a tensor:
      image:fromTensor(pathOrTensor, ...)

   end

   --
   return image
end

function Image:clone()
   local out = Image()
   for k,v in pairs(Image) do
      out[k] = self[k]
   end
   for k,v in pairs(out.buffers) do
      v = nil
   end

   out.wand = ffi.gc(clib.CloneMagickWand(self.wand), function(wand)
      -- Collect:
      clib.DestroyMagickWand(wand)
   end)

   return out
end

-- Load image:
function Image:load(path, width, height)
   -- Set canvas size:
   if width then
      -- This gives a cue to the wand that we don't need
      -- a large image than this. This is super cool, because
      -- it speeds up the loading of large images by a lot.
      clib.MagickSetSize(self.wand, width, height or width)
   end

   -- Load image:
   local status = clib.MagickReadImage(self.wand, path)

   -- Error?
   if status == 0 then
      magick_error(self, 'error loading image')
   end

   -- Save path:
   self.path = path

   -- return self
   return self
end

-- Save image:
function Image:save(path, quality)
   -- Format?
   -- local format = (path:gfind('%.(...)$')() or path:gfind('%.(....)$')()):upper()
   -- if format == 'JPG' then format = 'JPEG' end
   -- self:format(format)

   -- Set quality:
   quality = quality or 85
   clib.MagickSetCompressionQuality(self.wand, quality)

   -- Save:
   local status = clib.MagickWriteImage(self.wand, path)

   -- Error?
   if status == 0 then
      magick_error(self, 'error saving image')
   end

   -- return self
   return self
end

-- Size:
function Image:size(width,height,filter,blur)
   -- Set or get:
   if width or height then
      -- Get filter:
      local filter = clib[(filter or 'Undefined') .. 'Filter']

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

      -- Min box?
      if not width then
         -- in this case, the image must cover a heightxheight box:
         local box = height
         local cwidth,cheight = self:size()
         if cwidth < cheight then
            width = box
            height = box * cheight/cwidth
         else
            height = box
            width = box * cwidth/cheight
         end
      end
      blur = blur or 1.0

      -- Set dimensions:
      local status = clib.MagickResizeImage(self.wand, width, height, filter, blur)

      -- Error?
      if status == 0 then
         magick_error(self, 'error resizing image')
      end

      -- return self
      return self
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

      -- return self
      return self
   else
      -- Get depth:
      depth = clib.MagickGetImageDepth(self.wand)
   end
   --
   return depth
end

-- ImageType:
-- ImageType available:
local image_types = {
   [0] = "Undefined",
   "Bilevel",
   "Grayscale",
   "GrayscaleMatte",
   "Palette",
   "PaletteMatte",
   "TrueColor",
   "TrueColorMatte",
   "ColorSeparation",
   "ColorSeparationMatte",
   "Optimize"
}
function Image:type(image_type)
   -- Set or get:
   if image_type then
      -- Set type:
      clib.MagickSetImageType(self.wand, clib[image_type .. "Type"])

      -- return self
      return self
   else
      -- Get type:
      image_type = clib.MagickGetImageType(self.wand)
      return image_types[tonumber(image_type)]
   end
end

-- Interlace
function Image:interlace(interlace)
   if interlace == nil then
      interlace = 'Undefined'
   end
   local status = clib.MagickSetInterlaceScheme(self.wand, clib[interlace..'Interlace'])
   if status == 0 then
      magick_error(self, 'error set interlace')
   end
   return self  
end

-- Format:
function Image:format(format)
   -- Set or get:
   if format then
      -- Set format:
      clib.MagickSetImageFormat(self.wand, format)

      -- return self
      return self
   else
      -- Get format:
      format = ffi.string(ffi.gc(clib.MagickGetImageFormat(self.wand), ffi.C.free))
   end
   return format
end

-- Colorspaces available:
local colorspaces = {
   [0] = 'Undefined',
   'RGB',
   'GRAY',
   'Transparent',
   'OHTA',
   'XYZ',
   'YCC',
   'YIQ',
   'YPbPr',
   'YUV',
   'CMYK',
   'sRGB',
   'HSL',
   'HWB',
   'LAB',
   'CineonLogRGB',
   'Rec601Luma',
   'Rec601YCbCr',
   'Rec709Luma',
   'Rec709YCbCr'
}
-- Coloispaces:
function Image:colorspaces()
   return colorspaces
end

-- Colorspace:
function Image:colorspace(colorspace)
   -- Set or get:
   if colorspace then
      -- Set format:
      clib.MagickSetImageColorspace(self.wand, clib[colorspace .. 'Colorspace'])

      -- return self
      return self
   else
      -- Get format:
      colorspace = tonumber(clib.MagickGetImageColorspace(self.wand))

      colorspace = colorspaces[colorspace]
   end
   return colorspace
end

-- Flip:
function Image:flip()
   -- Flip image:
   clib.MagickFlipImage(self.wand)

   -- return self
   return self
end

-- Flop:
function Image:flop()
   -- Flop image:
   clib.MagickFlopImage(self.wand)

   -- return self
   return self
end

-- Rotate:
function Image:rotate(deg, r, g, b)
   -- Create PixelWand:
   local pixelwand = ffi.gc(clib.NewPixelWand(), function(pixelwand)
      -- Collect:
      clib.DestroyPixelWand(pixelwand)
   end)
   clib.PixelSetRed(pixelwand, r or 0)
   clib.PixelSetGreen(pixelwand, g or 0)
   clib.PixelSetBlue(pixelwand, b or 0)

   -- Rotate image:
   clib.MagickRotateImage(self.wand, pixelwand, deg)

   -- return self
   return self
end

-- Crop: (http://www.graphicsmagick.org/wand/magick_wand.html#magickcropimage)
function Image:crop(w, h, x, y)
   clib.MagickCropImage(self.wand, w, h, x, y)

   -- return self
   return self
end

function Image:addBorder(w, h, r, g, b)
  -- Create PixelWand:
   local pixelwand = ffi.gc(clib.NewPixelWand(), function(pixelwand)
      -- Collect:
      clib.DestroyPixelWand(pixelwand)
   end)
   clib.PixelSetRed(pixelwand, r or 0)
   clib.PixelSetGreen(pixelwand, g or 0)
   clib.PixelSetBlue(pixelwand, b or 0)
   -- Add border:
   clib.MagickBorderImage(self.wand, pixelwand, w, h)

   -- return self
   return self
end

-- Flood-fill
function Image:floodFill(x, y, r, g, b, fuzz)
  -- Create PixelWand:
   local pixelwand = ffi.gc(clib.NewPixelWand(), function(pixelwand)
      -- Collect:
      clib.DestroyPixelWand(pixelwand)
   end)
   clib.PixelSetRed(pixelwand, r or 0)
   clib.PixelSetGreen(pixelwand, g or 0)
   clib.PixelSetBlue(pixelwand, b or 0)
   local fuzz = fuzz or 0

   -- Do flood-fill
   clib.MagickColorFloodfillImage(self.wand, pixelwand, fuzz, nil, x, y)

   -- return self
   return self
end

-- Inverse image
function Image:negate()
  clib.MagickNegateImage(self.wand, 0)
  return self
end

-- Change image background color
function Image:setBackground(r, g, b)
  -- Create PixelWand:
  local pixelwand = ffi.gc(clib.NewPixelWand(), function(pixelwand)
      -- Collect:
      clib.DestroyPixelWand(pixelwand)
  end)
  clib.PixelSetRed(pixelwand, r or 0)
  clib.PixelSetGreen(pixelwand, g or 0)
  clib.PixelSetBlue(pixelwand, b or 0)
  clib.MagickSetImageBackgroundColor(self.wand, pixelwand)

   -- return self
  return self
end

-- Compositing operation
function Image:compose(composite, op, x, y)
  -- get CompositeOperator
  local compose = clib[op .. 'CompositeOp']
  clib.MagickCompositeImage(self.wand, composite.wand, compose, x, y)
  return self
end

-- Flatten image layers: result is returned
function Image:flatten()
  -- Create new instance:
  local image = {}
  for k,v in pairs(Image) do
      image[k] = v
  end

  image.wand = ffi.gc(clib.MagickFlattenImages(self.wand), function(wand)
    -- Collect:
    clib.DestroyMagickWand(wand)
  end)
  return image
end

-- Blur image
function Image:blur(radius, sigma)
  clib.MagickBlurImage(self.wand, radius, sigma)
  return self
end

-- Add noise
function Image:addNoise(noise)
  -- get noise type
  local noisetype = clib[noise .. 'Noise']
  clib.MagickAddNoiseImage(self.wand, noisetype)
  return self
end

-- Colorize image
function Image:colorize(r, g, b)
  -- Create PixelWand:
  local colorize = ffi.gc(clib.NewPixelWand(), function(pixelwand)
      -- Collect:
      clib.DestroyPixelWand(pixelwand)
  end)
  clib.PixelSetRed(colorize, r or 0)
  clib.PixelSetGreen(colorize, g or 0)
  clib.PixelSetBlue(colorize, b or 0)

  clib.MagickColorizeImage(self.wand, colorize, opacity)
  return self
end

function Image:affineTransform(sx, rx, ry, sy, tx, ty)
  local drawingWand = ffi.gc(clib.MagickNewDrawingWand(), function(drawingWand)
      clib.MagickDestroyDrawingWand(drawingWand)
  end)

  local affineMatrix = ffi.new("AffineMatrix")
  affineMatrix.sx = sx
  affineMatrix.rx = rx
  affineMatrix.ry = ry
  affineMatrix.sy = sy
  affineMatrix.tx = tx
  affineMatrix.ty = ty

  clib.MagickDrawAffine(drawingWand, affineMatrix)

  clib.MagickAffineTransformImage(self.wand, drawingWand)
  return self
end

-- Sampling Factors (jpeg:sampling-factor)
function Image:samplingFactors(sampling_factors)
   if sampling_factors then
      -- Set sampling factors
      local valp = ffi.new("double[?]", #sampling_factors, sampling_factors)
      local status = clib.MagickSetSamplingFactors(self.wand, #sampling_factors, valp)
      if status == 0 then
         magick_error(self, 'error set sampling factors')
      end
      return self
   else
      -- Get sampling factors
      local sizep = ffi.new('unsigned long[1]', 0)
      local valp = ffi.gc(clib.MagickGetSamplingFactors(self.wand, sizep),
			  clib.MagickRelinquishMemory)
      local n = tonumber(sizep[0])
      local sampling_factors = {}
      for i = 0, n - 1 do
	 table.insert(sampling_factors, tonumber(valp[i]))
      end
      return sampling_factors
   end
end

-- Gamma Property
function Image:gamma(gamma)
   if gamma then
      local status = clib.MagickSetImageGamma(self.wand, gamma)
      if status == 0 then
         magick_error(self, 'error set gamma')
      end
      return self
   else
      return clib.MagickGetImageGamma(self.wand)
   end
end
-- Gamma Correction
function Image:gammaCorrection(gamma, channel_type)
   local status = 0
   if channel_type then
      if channel_type == "All" then
	 channel_type = clib[channel_type .. "Channels"]
      else
	 channel_type = clib[channel_type .. "Channel"]
      end
      status = clib.MagickGammaImageChannel(self.wand, channel_type, gamma)
   else
      status = clib.MagickGammaImage(self.wand, gamma)
   end
   if status == 0 then
      magick_error(self, 'error gamma correction')
   end
   return self
end

-- Sharpen
function Image:sharpen(radius, sigma)
   if radius == nil then
      radius = 0
   end
   if sigma == nil then
      sigma = 1
   end
   local status = clib.MagickSharpenImage(self.wand, radius, sigma)
   if status == 0 then
      magick_error(self, 'error sharp image')
   end
   return self
end

-- Unsharp Mask
function Image:unsharpMask(radius, sigma, amount, threshold)
   local status = clib.MagickUnsharpMaskImage(self.wand, radius, sigma, amount, threshold)
   if status == 0 then
      magick_error(self, 'error unsharp mask')
   end
   return self
end

-- Profile
function Image:profile(name, profile)
   if profile then
      -- set
      local status = clib.MagickProfileImage(self.wand, name, profile, #profile)
      if status == 0 then
	 magick_error(self, 'error profile image')
      end
      return self
   else
      -- get
      local len = ffi.new('unsigned long[1]', 0)
      profile = clib.MagickGetImageProfile(self.wand, name, len)
      len = tonumber(len[0])
      if len > 0 then
	 profile = ffi.string(ffi.gc(profile, clib.MagickRelinquishMemory), len)
      else
	 profile = nil
      end
      return profile
   end
end
function Image:removeProfile(name)
   name = name or "*"
   local status = clib.MagickProfileImage(self.wand, name, nil, 0)
   if status == 0 then
      magick_error(self, 'error profile image')
   end
   return self
end

-- Export to Blob:
function Image:toBlob(quality)
   -- Size pointer:
   local sizep = ffi.new('size_t[1]')

   -- Current format:
   local fmt = self:format()
   if fmt == 'XC' then
      print('Image:toBlob() - cannot compress/export image with no format specified')
      print('please call image:format(fmt) before (format = JPEG, PNG, ...')
      error()
   end

   -- Set quality:
   if quality then
      clib.MagickSetCompressionQuality(self.wand, quality)
   end

   -- To Blob:
   local blob = ffi.gc(clib.MagickWriteImageBlob(self.wand, sizep), ffi.C.free)

   -- Return blob and size:
   return blob, tonumber(sizep[0])
end

-- Export to string:
function Image:toString(quality)
   -- To blob:
   local blob, size = self:toBlob(quality)

   -- Lua string:
   local str = ffi.string(blob,size)

   -- Return string:
   return str
end

-- To Tensor:
function Image:toTensor(dataType, colorspace, dims, nocopy)
   require "torch"
   -- Dims:
   local width,height = self:size()

   -- Color space:
   colorspace = colorspace or 'RGB'  -- any combination of R, G, B, A, C, Y, M, K, and I
   -- common colorspaces are: RGB, RGBA, CYMK, and I

   -- Other colorspaces?
   if colorspace == 'HSL' or colorspace == 'HWB' or colorspace == 'LAB' or colorspace == 'YUV' then
      -- Switch to colorspace:
      self:colorspace(colorspace)
      colorspace = 'RGB'
   end

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
   local tensor = Image.buffers['HWD'][tensorType] or torch[tensorType]()
   tensor:resize(height,width,#colorspace)

   -- Cache tensor:
   Image.buffers['HWD'][tensorType] = tensor

   -- Raw pointer:
   local ptx = torch.data(tensor)

   -- Export:
   clib.MagickGetImagePixels(self.wand,
                             0, 0, width, height,
                             colorspace, clib[pixelType],
                             ffi.cast('unsigned char *',ptx))

   -- Dims:
   if dims == 'DHW' then
      -- Transposed Tensor:
      local tensorDHW = Image.buffers['DHW'][tensorType] or tensor.new()
      tensorDHW:resize(#colorspace,height,width)

      -- Copy:
      tensorDHW:copy(tensor:transpose(1,3):transpose(2,3))

      -- Cache:
      Image.buffers['DHW'][tensorType] = tensorDHW

      -- Return:
      tensor = tensorDHW
   end

   -- Return tensor
   if nocopy then
      return tensor
   else
      return tensor:clone()
   end
end

-- Import from blob:
function Image:fromBlob(blob,size)
   -- Read from blob:
   local status = clib.MagickReadImageBlob(
    self.wand, ffi.cast('const void *', blob), size
   )

   if status == 0 then
      magick_error(self, 'error reading from blob')
   end

   -- Save path:
   self.path = '<blob>'

   -- return self
   return self
end

-- Import from blob:
function Image:fromString(string)
   -- Convert blob (lua string) to C string
   local size = #string
   blob = ffi.new('char['..size..']', string)

   -- Load blob:
   return self:fromBlob(blob, size)
end

-- From Tensor:
function Image:fromTensor(tensor, colorspace, dims)
   require 'torch'
   -- Dims:
   local height,width,depth
   if dims == 'DHW' then
      depth,height,width= tensor:size(1),tensor:size(2),tensor:size(3)
      tensor = tensor:transpose(1,3):transpose(1,2)
   else -- dims == 'HWD'
      height,width,depth = tensor:size(1),tensor:size(2),tensor:size(3)
   end

   -- Force contiguous:
   tensor = tensor:contiguous()

   -- Color space:
   if not colorspace then
      if depth == 1 then
         colorspace = 'I'
      elseif depth == 3 then
         colorspace = 'RGB'
      elseif depth == 4 then
         colorspace = 'RGBA'
      else
      end
   end
   -- any combination of R, G, B, A, C, Y, M, K, and I
   -- common colorspaces are: RGB, RGBA, CYMK, and I

   -- Compat:
   assert(#colorspace == depth, Image.name .. '.fromTensor: Tensor depth must match color space')

   -- Type:
   local ttype = torch.typename(tensor)
   local pixelType
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
   if colorspace == "RGBA" then
      clib.MagickSetImageType(self.wand, clib.TrueColorMatteType)
   end
   -- Export:
   clib.MagickSetImagePixels(self.wand,
                             0, 0, width, height,
                             colorspace, clib[pixelType],
                             ffi.cast("unsigned char *", ptx))

   -- Save path:
   self.path = '<tensor>'

   -- return self
   return self
end

-- Show:
function Image:show(zoom)
   -- Get Tensor from image:
   local tensor = self:toTensor('float', nil,'DHW')

   -- Display this tensor:
   require 'image'
   image.display({
      image = tensor,
      zoom = zoom
   })

   -- return self
   return self
end

-- Description:
function Image:info()
   -- Get information
   local str = ffi.gc(clib.MagickDescribeImage(self.wand), ffi.C.free)
   return ffi.string(str)
end

-- Exports:
return Image

