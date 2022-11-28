local name = "neovim"
local repo = "none"
local description = "Vim basic default settings"
local default_configs = {
  opt = {
    number = true,
  },
  g = {},

  filetype = {
    plugin = "on",
    indent = "on",
  },

  cmd = {},
}

local config_func = function(config)
  local o    = vim.opt
  local g    = vim.g
  local cmd  = vim.api.nvim_exec
  local conf = config

  for key, value in pairs(conf.g) do g[key] = value end
  for key, value in pairs(conf.opt) do o[key] = value end
  for _, value in pairs(conf.cmd) do cmd(value, false) end

  cmd('filetype plugin ' .. conf.filetype.plugin, false)
  cmd('filetype indent ' .. conf.filetype.indent, false)
end

local M       = {
  name        = name,
  repo        = repo,
  description = description,
  configs     = default_configs,
  config      = config_func,
}

return require("core.Plugin"):new(M)
