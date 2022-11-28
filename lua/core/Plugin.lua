Utils = require("Utils")

Plugin            = {
  name            = nil, -- the plugin name
  repos           = nil, -- the github repos name, string or table
  description     = nil, -- the plugin description
  configs         = {},  -- the config that finaly used
  setup           = nil, -- the config function that run before plugin loaded
  config          = nil, -- the config function that run after plugin loaded
}

-- New a Plugin object
function Plugin:new(opts)
  local obj         = {
    name            = opts and opts.name or nil,
    repos           = opts and opts.repos or nil,
    description     = opts and opts.description or nil,
    configs         = opts and opts.configs or {},
    config          = opts and opts.config or nil,
    setup           = opts and opts.setup or nil,
  }
  setmetatable(obj, self)
  self.__index = self
  self.__newindex = self

  return obj
end

-- Delete a Plugin object
function Plugin:delete()
  self.name            = nil
  self.repos           = nil
  self.configs         = nil
  self.config          = nil
  self.setup           = nil
  self                 = nil
end

-- Setup to a plugin
-- @setup[optional]: function means that override the initial setup func
function Plugin:Setup(configs)
  Utils:apply_defaults(configs, self.configs)
  if self.setup then
    self.setup(configs)
  end
end

-- Config for a plugin
-- @config: can override the configs & default_configs in new()
function Plugin:Config(configs)
  self.configs = Utils:apply_defaults(configs, self.configs)
  if self.config then
    self.config(self.configs)
  end
end

function Plugin:get_configs()
  return self.configs
end

return Plugin
