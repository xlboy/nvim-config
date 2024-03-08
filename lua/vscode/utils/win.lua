local M = {}

function M.create_float(opts)
  opts = vim.tbl_deep_extend("force", {
    buf_options = { bufhidden = "wipe" },
    win = {
      config = { relative = "editor", width = 0.7, height = 0.7 },
      options = { winbl = 20 },
    },
  }, opts or {})

  local bufnr = vim.api.nvim_create_buf(false, true)

  for k, v in pairs(opts.buf_options) do
    vim.api.nvim_set_option_value(k, v, { buf = bufnr })
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, opts.contents)

  local winid = vim.api.nvim_get_current_win()
  local parent_win_width = opts.win.config.relative == "win" and vim.api.nvim_win_get_width(winid)
    or vim.api.nvim_get_option_value("columns", { scope = "global" })
  local parent_win_height = opts.win.config.relative == "win" and vim.api.nvim_win_get_height(winid)
    or vim.api.nvim_get_option_value("lines", { scope = "global" })

  local f_width = math.floor(parent_win_width * opts.win.config.width)
  local f_height = math.floor(parent_win_height * opts.win.config.height)
  local f_col = math.floor((parent_win_width - f_width) / 2)
  local f_row = math.floor((parent_win_height - f_height) / 2)

  local win_id = vim.api.nvim_open_win(bufnr, true, {
    relative = opts.win.config.relative,
    width = f_width,
    height = f_height,
    col = f_col,
    row = f_row,
    border = "single",
  })

  for k, v in pairs(opts.win.options) do
    vim.api.nvim_set_option_value(k, v, { win = win_id })
  end

  return win_id
end

return M
