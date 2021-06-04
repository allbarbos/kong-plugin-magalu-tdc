local BasePlugin = require "kong.plugins.base_plugin"
local header_filter = require "kong.plugins.magalu-tdc.header_filter" -- kong.plugins.<plugin_name>.<module_name>

local _M = BasePlugin:extend()
_M.PRIORITY = 900
_M.VERSION = "1.0.0"

function _M:new()
  _M.super.new(self, "magalu-tdc")
end

function _M:header_filter(config)
  _M.super.header_filter(self)

  local ok, err = pcall(header_filter.execute, config)
  if not ok then
    ngx.log(ngx.CRIT, err)
  end
end

return _M
