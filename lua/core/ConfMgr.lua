local ConfMgr = {
  config = {},
}

function ConfMgr:new(config)
  local obj = {
    config = config or {}
  }

  setmetatable(obj, self)
  self.__index = self

  setmetatable(obj.config, self.config)
  self.config.__index    = self.config
  self.config.__newindex = self.config

  return obj
end

function ConfMgr:get(name)
  return self.config[name]
end

return ConfMgr
