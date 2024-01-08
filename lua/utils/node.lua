local M = {}

local function get_text_between(cursor_row, cursor_col, target_row, target_col)
  local buf = vim.api.nvim_get_current_buf()

  local start_row, end_row, start_col, end_col
  if cursor_row < target_row or (cursor_row == target_row and cursor_col < target_col) then
    start_row, end_row = cursor_row, target_row
    start_col, end_col = cursor_col, target_col
  else
    start_row, end_row = target_row, cursor_row
    start_col, end_col = target_col, cursor_col
  end

  local lines = vim.api.nvim_buf_get_lines(buf, start_row, end_row + 1, false)

  if start_row == end_row then
    lines[1] = lines[1]:sub(start_col + 1, end_col)
  else
    lines[1] = lines[1]:sub(start_col + 1)
    lines[#lines] = lines[#lines]:sub(1, end_col)
  end

  return table.concat(lines, "\n")
end

function M.get_recent_pos()
  local ts_utils = require("nvim-treesitter.ts_utils")

  local cursor_node = ts_utils.get_node_at_cursor()
  if not cursor_node then return nil end

  local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(cursor_node)
  local text = vim.treesitter.get_node_text(cursor_node, 0)

  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

  local start_text = get_text_between(cursor_row - 1, cursor_col, start_row, start_col)
  local end_text = get_text_between(cursor_row - 1, cursor_col, end_row, end_col)
  local is_forward = #start_text > #end_text

  return is_forward and { start_row + 1, start_col } or { end_row + 1, end_col - 1 }
end

return M
