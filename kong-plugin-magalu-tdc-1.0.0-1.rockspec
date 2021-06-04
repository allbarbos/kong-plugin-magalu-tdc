package = "kong-plugin-magalu-tdc"
version = "1.0.0-1"
source = {
   url = "git+ssh://git@github.com/allbarbos/kong-plugin-magalu-tdc.git"
}
description = {
   detailed = "",
   homepage = "",
   license = ""
}
dependencies = {
   "lua ~> 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.magalu-tdc.handler"] = "kong/plugins/magalu-tdc/handler.lua",
      ["kong.plugins.magalu-tdc.header_filter"] = "kong/plugins/magalu-tdc/header_filter.lua",
      ["kong.plugins.magalu-tdc.schema"] = "kong/plugins/magalu-tdc/schema.lua"
   }
}
