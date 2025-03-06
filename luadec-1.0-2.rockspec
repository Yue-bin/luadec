package = "luadec"
version = "1.0-2"
source = {
   url = "git+https://github.com/Yue-bin/luadec.git",
   tag = "v1.0-2"
}
description = {
   summary = "A decorator implementation of lua",
   detailed = [[
      为lua提供了装饰器的实现
   ]],
   homepage = "https://github.com/Yue-bin/luadec",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      luadec = "src/luadec.lua",
   }
}
