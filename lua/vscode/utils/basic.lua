local config = require("vscode.config.config")
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

function M.get_visible_lines()
  local start_line = 1
  local end_line = vim.fn.line("$")
  local vis_lines = {}

  for i = start_line, end_line do
    if vim.fn.foldclosed(i) == -1 then table.insert(vis_lines, i) end
  end

  return vis_lines
end

function M.gen_record(keys, value)
  local record = {}
  for _, key in ipairs(keys) do
    record[key] = value
  end
  return record
end

function M.feedkeys(keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode or "n", true)
end

return M
