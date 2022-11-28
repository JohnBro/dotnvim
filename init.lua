local base_dir = vim.fn.getenv("DOTNVIM_INIT_DIR") or (function()
  local init_path = debug.getinfo(1, "S").source
  return init_path:sub(2):match("(.*[/\\])"):sub(1, -2)
end)()

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end

require("plugins.init")