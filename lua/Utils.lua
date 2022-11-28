Utils = {
	const = {},
}

local fn   = vim.fn
local loop = vim.loop

Utils.const          = {
  OS_IS_WINDOWS      = fn.has("win32") or fn.has("win64"),
  OS_IS_LINUX        = fn.has("unix"),
  OS_IS_MACOSX       = fn.has("macunix"),
  OS_IS_GUIRUNNING   = fn.has("gui_running"),
  OS_PATH_SEP        = loop.os_uname().version:match "Windows" and "\\" or "/",
  OS_PATH_HOME_DIR   = fn.expand(fn.getenv("HOME")),
  OS_PATH_DATA_DIR   = fn.stdpath("data"),
  OS_PATH_CACHE_DIR  = fn.stdpath("cache"),
  OS_PATH_CONFIG_DIR = fn.stdpath("config"),
}

_G.OS_IS_WINDOWS      = Utils.const.OS_IS_WINDOWS
_G.OS_IS_LINUX        = Utils.const.OS_IS_LINUX
_G.OS_IS_MACOSX       = Utils.const.OS_IS_MACOSX
_G.OS_IS_GPURUNNING   = Utils.const.OS_IS_GUIRUNNING
_G.OS_PATH_SEP        = Utils.const.OS_PATH_SEP
_G.OS_PATH_HOME_DIR   = Utils.const.OS_PATH_HOME_DIR
_G.OS_PATH_DATA_DIR   = Utils.const.OS_PATH_DATA_DIR
_G.OS_PATH_CACHE_DIR  = Utils.const.OS_PATH_CACHE_DIR
_G.OS_PATH_CONFIG_DIR = Utils.const.OS_PATH_CONFIG_DIR

---Join path segments that were passed as input
---@return string
function Utils:join_paths(...)
  local result = table.concat({ ... }, self.const.OS_PATH_SEP)
  return result
end
_G.join_paths = Utils:join_paths(...)


--- Returns a table with the default values that are missing.
--- either parameter can be empty.
--@param config (table) table containing entries that take priority over defaults
--@param default_config (table) table contatining default values if found
function Utils:apply_defaults(config, default_config)
  config = config or {}
  default_config = default_config or {}
  local new_config = vim.tbl_deep_extend("keep", vim.empty_dict(), config)
  new_config = vim.tbl_deep_extend("keep", new_config, default_config)
  return new_config
end

-- Print the table of configs
function Utils:print_configs(configs)
  for k,v in pairs(configs) do
    print(k)
    if type(v) ~= "table" then
      print(v)
    else
      Utils:print_configs(v)
    end
  end
end

setmetatable({}, Utils)

return Utils
