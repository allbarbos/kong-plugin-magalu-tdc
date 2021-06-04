local log = spy.new(function(status, error)
  return status, error
end)

_G.ngx.log = log

local handler = require "kong.plugins.magalu-tdc.handler"
local header_filter = require "kong.plugins.magalu-tdc.header_filter"

describe("Test handler constructor", function()
  before_each(function()
    handler:new()
  end)

  it("should set object name correctly", function()
    assert.equals(handler._name, "magalu-tdc")
  end)

  it("should set priority 900", function()
    assert.equals(handler.PRIORITY, 900)
  end)

  it("should set version 1.0.0", function()
    assert.equals(handler.VERSION, "1.0.0")
  end)

  it("should contain phase header filter", function()
    assert.is_truthy(handler.header_filter)
  end)
end)

describe("Test header filter phase", function()
  local config

  before_each(function()
    config = {
      show_kong_headers = true,
      add_magalu_header = true
    }
  end)

  it("should call a phase with success", function()
    header_filter.execute = spy.new(function()
      return nil
    end)

    handler:header_filter(config)

    assert.spy(header_filter.execute).was.called()
    assert.spy(ngx.log).was_not_called_with(ngx.CRIT, nil)
  end)

  it("should call a phase with error", function()
    header_filter.execute = spy.new(function()
      return error({ message="test error" })
    end)

    handler:header_filter(config)

    assert.spy(header_filter.execute).was.called()
    assert.spy(ngx.log).was.called_with(ngx.CRIT, { message="test error" })
  end)
end)
