local schema = require "kong.plugins.magalu-tdc.schema"

describe("Test Schema", function()
    it("should initialize schema correctly", function()
      assert.is_true(schema.no_consumer)

      assert.not_nil(schema.fields.add_magalu_header)
      assert.is_equal(schema.fields.add_magalu_header.type, "boolean")
      assert.is_false(schema.fields.add_magalu_header.default)

      assert.not_nil(schema.fields.show_kong_headers)
      assert.is_equal(schema.fields.show_kong_headers.type, "boolean")
      assert.is_true(schema.fields.show_kong_headers.default)
    end)
end)
