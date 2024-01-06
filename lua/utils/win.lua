local M = {}

function M.create_float(win_opts, contents, buf_opts)
  buf_opts = vim.tbl_extend("force", { bufhidden = "wipe" }, buf_opts or {})
  win_opts = vim.tbl_extend("force", { relative = "editor", width = 0.7, height = 0.7 }, win_opts or {})
  local bufnr = vim.api.nvim_create_buf(false, true)

  for k, v in pairs(buf_opts) do
    vim.api.nvim_set_option_value(k, v, { buf = bufnr })
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, contents)

  local winid = vim.api.nvim_get_current_win()
  local parent_win_width = win_opts.relative == "win" and vim.api.nvim_win_get_width(winid)
    or vim.api.nvim_get_option_value("columns")
  local parent_win_height = win_opts.relative == "win" and vim.api.nvim_win_get_height(winid)
    or vim.api.nvim_get_option_value("lines")

  local f_width = math.floor(parent_win_width * win_opts.width)
  local f_height = math.floor(parent_win_height * win_opts.height)
  local f_col = math.floor((parent_win_width - f_width) / 2)
  local f_row = math.floor((parent_win_height - f_height) / 2)

  local win_id = vim.api.nvim_open_win(bufnr, true, {
    relative = win_opts.relative,
    width = f_width,
    height = f_height,
    col = f_col,
    row = f_row,
    border = "single",
  })

  return win_id
end

return M
