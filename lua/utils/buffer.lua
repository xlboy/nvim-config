local M = {}

--- @return integer[]
function M.get_bufs()
  return vim.tbl_filter(function(bufnr)
    return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_loaded(bufnr)
  end, vim.api.nvim_list_bufs())
end

---Get unique name for the current buffer
---@param filename string
---@param shorten boolean
---@return string
function M.get_unique_filename(filename, shorten)
  filename = vim.fn.expand(filename)
  local filenames = vim.tbl_filter(
    function(filename_other)
      return filename_other ~= filename
    end,
    vim.tbl_map(function(id)
      return vim.fn.expand(vim.api.nvim_buf_get_name(id))
    end, M.get_bufs())
  )

  if shorten then
    filename = vim.fn.pathshorten(filename)
    filenames = vim.tbl_map(vim.fn.pathshorten, filenames)
  end

  -- Reverse filenames in order to compare their names
  filename = string.reverse(filename)
  filenames = vim.tbl_map(string.reverse, filenames)

  local index

  -- For every other filename, compare it with the name of the current file char-by-char to
  -- find the minimum index `i` where the i-th character is different for the two filenames
  -- After doing it for every filename, get the maximum value of `i`
  if next(filenames) then
    index = math.max(unpack(vim.tbl_map(function(filename_other)
      for i = 1, #filename do
        -- Compare i-th character of both names until they aren't equal
        if filename:sub(i, i) ~= filename_other:sub(i, i) then return i end
      end
      return 1
    end, filenames)))
  else
    index = 1
  end

  -- Iterate backwards (since filename is reversed) until a "/" is found
  -- in order to show a valid file path
  while index <= #filename do
    if filename:sub(index, index) == "/" or filename:sub(index, index) == "\\" then
      index = index - 1
      break
    end

    index = index + 1
  end

  return string.reverse(string.sub(filename, 1, index))
end

-- 取 buf 所在的 window 位置
function M.get_window_number(bufnr, ft_ignores)
  local ignore_count = 0
  for w_index, w_value in ipairs(vim.api.nvim_list_wins()) do
    local cur_win_ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(w_value), "filetype")
    if vim.tbl_contains(ft_ignores, cur_win_ft) then
      ignore_count = ignore_count + 1
      goto continue
    end
    local w_buf = vim.api.nvim_win_get_buf(w_value)
    if w_buf == bufnr then return w_index - ignore_count end

    ::continue::
  end
end

-- 判断指定的 buffer 是否git改动
function M.is_git_changed(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then return false end
  local git_dir = vim.fn.finddir(".git/..", bufname .. ";")
  if git_dir == "" then return false end
  local git_status = vim.fn.systemlist("git status --porcelain --untracked-files=no " .. bufname)
  if #git_status == 0 then return false end
  return true
end

function M.is_noname(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  return bufname == ""
end

function M.is_modified(bufnr)
  return vim.api.nvim_get_option_value("modified", { buf = bufnr })
end

function M.delete_non_cwd(force)
  force = force or true
  local to_delete = vim.tbl_filter(function(buf)
    local filename = vim.api.nvim_buf_get_name(buf)
    local cwd = vim.fn.getcwd()
    return not vim.startswith(filename, cwd)
  end, M.get_bufs())

  for _, buf in ipairs(to_delete) do
    vim.api.nvim_buf_delete(buf, { force = force })
  end
end

return M
