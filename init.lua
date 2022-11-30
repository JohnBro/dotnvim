local base_dir = vim.fn.getenv("DOTNVIM_INIT_DIR") ~= vim.NIL or vim.fn.stdpath("config")
local settings_dir = vim.fn.getenv("DOTNVIM_SETTINGS_DIR") ~= vim.NIL or vim.fn.stdpath("config")

print(vim.fn.stdpath("config"))
print(base_dir)
print(settings_dir)

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end

if not vim.tbl_contains(vim.opt.rtp:get(), settings_dir) then
  vim.opt.rtp:append(settings_dir)
end

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

if not vim.g.vscode then
  require("plugins.init")
else
  vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
  
  return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- My plugins here
    
    use 'LunarVim/bigfile.nvim'
  
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end)
end