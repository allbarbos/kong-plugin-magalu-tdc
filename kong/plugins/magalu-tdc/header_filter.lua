local kong = kong
local _M = {}

local function show_kong_headers(show)
  kong.configuration.enabled_headers['X-Kong-Upstream-Latency'] = show
  kong.configuration.enabled_headers['X-Kong-Proxy-Latency'] = show
  kong.configuration.enabled_headers['Via'] = show
end

function _M.execute(config)
  show_kong_headers(config.show_kong_headers)

  if config.add_magalu_header then
    kong.response.set_header('x-magalu', 'Hello TDC Connections')
  end
end

return _M
