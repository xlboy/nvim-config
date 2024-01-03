local config = require("config.config")
local M = {}

function M.os_pick(winVal, macVal)
  if config.IS_WIN then return winVal end

  return macVal
end

function M.append_arrays(t1, ...)
  t1 = t1 or {}
  for _, t in ipairs({ ... }) do
    for i = 1, #t do
      table.insert(t1, t[i])
    end
  end
  return t1
end

function M.write_to_clipboard(text)
  vim.fn.setreg("+", text)
end

-- 获取已打开的 buffers
function M.get_opened_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "buflisted") then table.insert(buffers, buf) end
  end
  return buffers
end

function M.get_visible_lines()
  local start_line = 1
  local end_line = vim.fn.line("$")
  local vis_lines = {}

  for i = start_line, end_line do
    if vim.fn.foldclosed(i) == -1 then table.insert(vis_lines, i) end
  end

  return vis_lines
end

-- 如何用 lua 搜索指定行数范围内的字符串
function M.search_in_range(start_line, end_line, pattern)
  local vis_lines = M.get_visible_lines()
  local start_line = start_line or vis_lines[1]
  local end_line = end_line or vis_lines[#vis_lines]
  local pattern = pattern or vim.fn.input("Search: ")

  vim.cmd(start_line .. "," .. end_line .. "g/" .. pattern .. "/p")
end

M.fs = {}
function M.fs.open_dir_in_finder(dir)
  local cmd = M.os_pick('start "" "' .. dir .. '"', 'open "' .. dir .. '"')
  vim.fn.system(cmd)
end

return M
