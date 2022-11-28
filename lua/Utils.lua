Utils = {
	const = {},
  buffers = {}, -- for window using
}

local fn   = vim.fn
local loop = vim.loop
local api  = vim.api

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

function Utils:new_window(opts)
	opts = opts or {}
	local title = opts.title
  local buffers = self.buffers

	vim.cmd.vsplit()
	local win = api.nvim_get_current_win()
	local buf = api.nvim_create_buf(true, true)

	if title then
		local ok = pcall(api.nvim_buf_set_name, buf, title)
		if not ok then api.nvim_buf_delete(buffers[title], { force = true }) end
		pcall(api.nvim_buf_set_name, buf, title)
		buffers[title] = buf
	end

	api.nvim_buf_set_option(buf, 'filetype', opts.ft or 'text')
	api.nvim_buf_set_option(buf, 'sw', opts.sw or 2)
	api.nvim_buf_set_option(buf, 'ts', opts.ts or 2)

	api.nvim_win_set_option(win, 'foldmethod', 'indent')
	api.nvim_win_set_option(win, 'foldlevel', opts.foldlevel or 1)
	api.nvim_win_set_option(win, 'cc', '')

	api.nvim_win_set_buf(win, buf)
	vim.cmd 'vertical resize 80'

	api.nvim_win_set_option(win, 'nu', true)
	api.nvim_win_set_option(win, 'cursorline', true)

	local row = 0
	local write = function(content)
		if type(content) == 'string' then content = { content } end
		api.nvim_buf_set_lines(buf, row, row, true, content)
		row = row + #content
	end

	local writeVal = function(content)
		local text = vim.fn.split(vim.inspect(content), '\n')
		api.nvim_buf_set_lines(buf, row, row, true, text)
		row = row + #text
	end

	return {
		write = write,
		writeVal = writeVal,
		win = win,
		resetCursor = function()
			api.nvim_win_set_cursor(win, { 1, 0 })
		end,
	}
end

function Utils:dump_configs(config)
  local w = self:new_window({ title = '[dot.nvim config]', ft = 'lua' })
  local write = w.write
  write({ '-- The content generated by :ShowConfig', '-- config --' })

  local conf = vim.tbl_extend('keep', config, {})

  local lines = fn.split(vim.inspect(conf), '\n')
  lines = vim.tbl_map(function(line)
    return line:gsub('<table %d+>', '"%1"'):gsub('<(%d+)>{', '--[[<table %1>--]]{'):gsub(
      '<function %d+>', '"%1"'):gsub('<metatable>', '["%1"]')
    end, lines)

  write(lines)

  w.resetCursor()
end

-- @usage notify('message')
-- @usage notify('message', 'error')
-- @usage notify('message', {level = 'error'})
-- @usage notify('message', {level = 'error', defer = true})  use vim.schedule to notify message
--
-- Default level is "info"
function Utils:notify(msg, opts)
	if not opts then
		vim.notify(msg, 'info')
	elseif opts.defer then
		vim.schedule(function()
			vim.notify(msg, opts.level or 'info')
		end)
	else
		vim.notify(msg, opts.level or opts or 'info')
	end
end

setmetatable({}, { __index = Utils })

return Utils
