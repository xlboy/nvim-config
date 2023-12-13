local constants = require("config.constants")
local M = {}

function M.os_pick(winVal, macVal)
  if constants.IS_WIN then return winVal end

  return macVal
end

function M.append_arrays(t1, ...)
  for _, t in ipairs({ ... }) do
    for i = 1, #t do
      table.insert(t1, t[i])
    end
  end
  return t1
end

return M
