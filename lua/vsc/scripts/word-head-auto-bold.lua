vim.cmd("highlight WordHeadBold cterm=bold gui=bold")
local ns_id = vim.api.nvim_create_namespace("word_head_bold")

local function find_var_word_start_pos(str)
  local pattern = "[%w_]+"
  local words = {}
  local pos = 1
  for word in str:gmatch(pattern) do
    local start_pos, end_pos = str:find(word, pos)
    if start_pos and end_pos then
      table.insert(words, { word = word, start_pos = start_pos })
      pos = end_pos + 1
    end
  end

  return words
end

local function bold_word()
  local bufnr = vim.api.nvim_get_current_buf()
  local cur_line_str = vim.api.nvim_get_current_line()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local result = find_var_word_start_pos(cur_line_str)

  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  for _, word_info in ipairs(result) do
    vim.api.nvim_buf_add_highlight(
      bufnr,
      ns_id,
      "WordHeadBold",
      cursor_line - 1,
      word_info.start_pos - 1,
      word_info.start_pos
    )
  end
end

vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*",
  callback = bold_word,
})
