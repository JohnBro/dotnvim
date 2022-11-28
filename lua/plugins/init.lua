M = {
  plugins = {}  -- the list of Plugin

}

local Load = function(name)
  local m = "plugins." .. name
  local P = require(m)
  if P then table.insert(M.plugins, P) end
  P:Setup()
  P:Config()
end

Load("vim-options")

return M
