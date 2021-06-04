local header_expected = {}

local kong = {
  configuration = {
    enabled_headers = {}
  },
  response = {
    set_header = spy.new(function(key, value)
      header_expected[key] = value
    end),
  }
}

_G.kong = kong

local header_filter = require "kong.plugins.magalu-tdc.header_filter"

describe("Test Header Filter", function()
  local config

  before_each(function()
    config = {
      show_kong_headers = true,
      add_magalu_header = true
    }
  end)

  describe("When show_kong_headers is true", function()
    it("Should set kong headers to true", function()
      header_filter.execute(config)
      assert.is_true(kong.configuration.enabled_headers['Via'])
      assert.is_true(kong.configuration.enabled_headers['X-Kong-Proxy-Latency'])
      assert.is_true(kong.configuration.enabled_headers['X-Kong-Upstream-Latency'])
    end)
  end)

  describe("When add_magalu_header is true", function()
    it("Should returns header x-magalu", function()
      header_filter.execute(config)
      assert.is_equal(header_expected["x-magalu"], "Hello TDC Connections")
    end)
  end)
end)
