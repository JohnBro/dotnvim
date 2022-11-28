Utils = require("Utils")

Plugin            = {
  name            = nil, -- the name
  repo            = nil, -- the github repo name
  configs         = {},  -- the config that finaly used
  setup           = nil, -- the config function that run before plugin loaded
  config          = nil, -- the config function that run after plugin loaded
}

function Plugin:new(opts)
  local obj         = {
    name            = opts and opts.name or nil,
    repo            = opts and opts.repo or nil,
    configs         = opts and opts.configs or {},
    config          = opts and opts.config or nil,
    setup           = opts and opts.setup or nil,
  }
  setmetatable(obj, self)
  self.__index = self

  return obj
end

function Plugin:delete()
  self.name            = nil
  self.repo            = nil
  self.configs         = nil
  self.config          = nil
  self.setup           = nil
  self                 = nil
end

-- Setup to a plugin
-- @setup[optional]: function means that override the initial setup func
function Plugin:Setup(configs)
  Utils:apply_defaults(self.configs, configs)
  if not self.setup then
    self.setup(configs)
  end
end

-- Config for a plugin
-- @config: can override the configs & default_configs in new()
function Plugin:Config(configs)
  Utils:apply_defaults(self.configs, configs)
  if self.config then
    self.config(self.configs)
  end
end

return Plugin
