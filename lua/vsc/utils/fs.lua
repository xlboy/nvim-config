local basic = require("vsc.utils.basic")

local M = {}

function M.open_dir_in_finder(dir)
  local cmd = basic.os_pick(string.format('start "" "%s"', dir), string.format('open "%s"', dir))
  vim.fn.system(cmd)
end

return M
