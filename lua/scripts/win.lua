local state = {
  wins = {}, --- @type table<number, WindowInfo>
}

local config = {
  win = {
    relative = "win",
    height = 1,
    border = "none",
    zindex = 250,
    focusable = true,
  },
}

local utils = {
  is_ignore_ft = function(win_id)
    local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), "filetype")
    local ignores = { "float-filename", "Mason", "TelescopePrompt", "neo-tree" }
    for _, ignore in ipairs(ignores) do
      if ft == ignore then return true end
    end
    return false
  end,

  get_bufs = function()
    return vim.tbl_filter(function(bufnr)
      return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_loaded(bufnr)
    end, vim.api.nvim_list_bufs())
  end,
  --- Get unique name for the current buffer
  --- @param filename string
  --- @param shorten boolean
  get_unique_filename = function(self, filename, shorten)
    local filenames = vim.tbl_filter(function(filename_other)
      return filename_other ~= filename
    end, vim.tbl_map(vim.api.nvim_buf_get_name, self:get_bufs()))

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
      if filename:sub(index, index) == "/" then
        index = index - 1
        break
      end

      index = index + 1
    end

    return string.reverse(string.sub(filename, 1, index))
  end,

  -- 取 win_id 对应的 buf 信息
  get_buf_info = function(self, win_id)
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local buf_name = vim.api.nvim_buf_get_name(buf_id)
    local buf_unique_name = self:get_unique_filename(buf_name, true)
    return {
      id = buf_id,
      name = buf_name,
      unique_name = buf_unique_name,
    }
  end,
}

local function update_hl()
  -- 根据 active 来更新即可
end
local function update_pos(active_win_id)
  -- 更新 active 对应的 pos 即可
end

local function create_float_win(target_win)
  local w_buf = vim.api.nvim_create_buf(false, true)

  local w_width = vim.api.nvim_win_get_width(target_win)
  local w_height = vim.api.nvim_win_get_height(target_win)
  local w_pos = { left = w_width - 20, top = w_height - 5 } -- 右下角

  local w_handle = vim.api.nvim_open_win(w_buf, false, {
    relative = "win",
    -- TODO: 待删
    width = 20,
    height = 1,
    border = "none",
    zindex = 250,
    focusable = true,
    row = w_pos.top,
    col = 150, -- w_pos.left,
  })
  local w_info = { --- @type WindowInfo
    active = false,
    f_handle = w_handle,
    f_buf = w_buf,
    pos = w_pos,
  }

  -- 设置 filetype
  vim.api.nvim_buf_set_option(w_buf, "filetype", "float-filename")

  return w_info
end

local function update_active_win(active_win_id)
  for win_id, win_info in pairs(state.wins) do
    win_info.active = win_id == active_win_id
  end

  local float_win_info = state.wins[active_win_id]
  local active_win_buf_info = utils:get_buf_info(active_win_id)
  -- vim.api.nvim_buf_set_option(float_win_info.f_buf, "modifiable", false)
  vim.api.nvim_buf_set_lines(float_win_info.f_buf, 0, -1, false, { active_win_buf_info.unique_name })
  -- vim.api.nvim_buf_set_option(float_win_info.f_buf, "modifiable", true)
end

local function create_autocmd()
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    pattern = "*",
    callback = function(ev)
      local new_win = vim.api.nvim_get_current_win()
      if utils.is_ignore_ft(new_win) then return end
      if not state.wins[new_win] then
        local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(new_win), "filetype")
        if ft == "" then return end

        state.wins[new_win] = create_float_win(new_win)
        update_active_win(new_win)
        -- update_hl()
      end
    end,
  })
end

local function init()
  create_autocmd()
end

init()

--- @class WindowInfo
--- @field pos WindowPos
--- @field active boolean
--- @field f_buf integer
--- @field f_handle integer

--- @class WindowPos
--- @field left number
--- @field top number
