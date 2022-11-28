local Utils = require("Utils")
local settings = require("settings")
local ConfMgr = require("core.ConfMgr"):new(settings)

M = {
  plugins = {},  -- the list of Plugin
}

local Load = function(name)
  local m = "plugins." .. name
  local P = require(m)
  if P and P.name then
    M.plugins[P.name] = P
  end
end

local Setup = function(name)
  if M.plugins[name] and ConfMgr.config[name] then
    M.plugins[name]:Setup(ConfMgr.config[name])
  else
    local msg = string.format("Error setup for %s plugin", name)
    Utils:notify(msg, 'error')
  end
end

local Config = function(name)
  if M.plugins[name] and ConfMgr.config[name] then
    M.plugins[name]:Config(ConfMgr.config[name])
  else
    local msg = string.format("Error config for %s plugin", name)
    Utils:notify(msg, 'error')
  end
end

Load("vim-options")
Config("vim-options")

return M
