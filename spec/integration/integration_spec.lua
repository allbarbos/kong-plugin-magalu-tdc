local helpers = require "spec.helpers"

local PLUGIN_NAME = "magalu-tdc"
local strategy = 'postgres'

describe(PLUGIN_NAME .. ": (header_filter)", function()
  local client

  lazy_setup(function()
    local plugins = { PLUGIN_NAME }
    local tables = {"routes","services","plugins"}
    local bp = helpers.get_db_utils(strategy, tables, plugins)

    local srv = bp.services:insert {
      name = "magalu-tdc-srv",
      url = "https://mockbin.org/bin/924cccf3-940c-4333-9755-16c586e59ccf",
    }

    local route_false = bp.routes:insert {
      service = srv,
      protocols  = { "http", "https" },
      paths = { "/false" }
    }

    bp.plugins:insert {
      name = PLUGIN_NAME,
      route = route_false,
      config = {
        add_magalu_header = false,
        show_kong_headers = false
      },
    }

    local route_true = bp.routes:insert {
      service = srv,
      protocols  = { "http", "https" },
      paths = { "/true" }
    }

    bp.plugins:insert {
      name = PLUGIN_NAME,
      route = route_true,
      config = {
        add_magalu_header = true,
        show_kong_headers = true
      },
    }

    assert(helpers.start_kong({
      database   = strategy,
      nginx_conf = "spec/fixtures/custom_nginx.template",
      plugins = "bundled," .. PLUGIN_NAME,
    }))
  end)

  lazy_teardown(function()
    helpers.stop_kong()
  end)

  before_each(function()
    client = assert(helpers.proxy_client())
  end)

  after_each(function()
    if client then client:close() end
  end)

  describe("When config is false", function()
    it("should not return x headers", function()
      local res = client:get("/false")

      assert.res_status(200, res)
      assert.falsy(res.headers['X-Kong-Upstream-Latency'])
      assert.falsy(res.headers['X-Kong-Proxy-Latency'])
    end)
  end)

  describe("When config is true", function()
    it("should return x headers", function()
      local res = client:get("/true")

      assert.res_status(200, res)
      assert.truthy(res.headers['X-Kong-Upstream-Latency'])
      assert.truthy(res.headers['X-Kong-Proxy-Latency'])
      assert.header("x-magalu", res)
    end)
  end)
end)
