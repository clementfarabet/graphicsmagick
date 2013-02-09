package = "graphicsmagick"
version = "1.0.0-0"

source = {
   url = "git://github.com/clementfarabet/graphicsmagick",
   tag = "1.0.0-0",
}

description = {
   summary = "A wrapper to GraphicsMagick (binary).",
   detailed = [[
GraphichsMagick (.org) is a tool to convert images, quite efficiently.
This package provides bindings to it.
   ]],
   homepage = "https://github.com/clementfarabet/graphicsmagick",
   license = "BSD"
}

dependencies = {
   "sys >= 1.0",
   "torch >= 7.0"
}

build = {
   type = "builtin",
   modules = {
      ['graphicsmagick.init'] = 'init.lua',
      ['graphicsmagick.magick'] = 'magick.lua',
   }
}
