local config = {
  active_color = { bg = "#17c0eb", fg = "#ffffff" },
  visible_color = { bg = "#2f3640", fg = "#afc5c7" },
  default_color = { bg = "none", fg = "#B0BEC5" },
  default_surround_char = { left = "", right = "" },
  min_width = 20,
}

local utils = {
  get_window_number = function(bufnr, ft_ignores)
    ft_ignores = ft_ignores or { "neo-tree", "Outline", "Trouble" }
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
  end,
  get_bufs = function()
    return vim.tbl_filter(function(bufnr)
      return vim.api.nvim_buf_get_option(bufnr, "buflisted")
    end, vim.api.nvim_list_bufs())
  end,
  ---Get the names of all current listed buffers
  ---@return table
  get_current_filenames = function()
    local listed_buffers = vim.tbl_filter(function(bufnr)
      return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_loaded(bufnr)
    end, vim.api.nvim_list_bufs())

    return vim.tbl_map(vim.api.nvim_buf_get_name, listed_buffers)
  end,

  ---Get unique name for the current buffer
  ---@param filename string
  ---@param shorten boolean
  ---@return string
  get_unique_filename = function(self, filename, shorten)
    local filenames = vim.tbl_filter(function(filename_other)
      return filename_other ~= filename
    end, self:get_current_filenames())

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
}

return {
  enabled = true,
  "rebelot/heirline.nvim",
  config = function()
    local h_conditions = require("heirline.conditions")
    local h_utils = require("heirline.utils")

    local components = {
      buffer = {
        surround = {
          Left = {
            condition = function(self)
              return self.is_active or self.is_visible
            end,
            {
              provider = config.default_surround_char.left,
              hl = function(self)
                local fg = self.is_active and config.active_color.bg or config.visible_color.bg
                return { fg = fg }
              end,
            },
          },
          Right = {
            condition = function(self)
              return self.is_active or self.is_visible
            end,
            provider = config.default_surround_char.right,
            hl = function(self)
              local fg = self.is_active and config.active_color.bg or config.visible_color.bg
              return { fg = fg }
            end,
          },
        },
        ActiveIcon = {
          condition = function(self)
            return self.is_active
          end,
          provider = "⚡",
          hl = function(self)
            local fg = "#333333"
            local bg = self.is_active and config.active_color.bg or config.visible_color.bg

            return { bg = bg }
          end,
        },
        WindowNumber = {
          condition = function(self)
            return not self.is_active and self.is_visible
          end,
          provider = function(self)
            local window_number = utils.get_window_number(self.bufnr)
            return window_number
            -- return config.number_chars[window_number]
            -- return window_number .. ". "
          end,
          hl = function(self)
            local fg = self.is_active and config.active_color.fg or config.visible_color.fg
            return { fg = fg }
          end,
        },
        FileNameAndIcon = {
          init = function(self)
            local filename = self.filename
            self.display_filename = filename == "" and "[No Name]" or utils:get_unique_filename(self.filename, true)
            local filename_length = string.len(self.display_filename)
            if filename_length < config.min_width then
              self.display_left_space = math.floor((config.min_width - filename_length) / 2)
              self.display_right_space = config.min_width - filename_length - self.display_left_space
            end
          end,
          {
            {
              name = "LeftSpace",
              condition = function(self)
                return self.display_left_space and self.display_left_space > 0
              end,
              provider = function(self)
                local space_size = self.display_left_space
                -- 减 1 是因为左边的 surround char
                if self.is_active or self.is_visible then space_size = space_size - 1 end
                -- 减 3 是因为左边的 window number（`1. ` ）
                -- if not self.is_active and self.is_visible then space_size = space_size - 1 end
                if space_size <= 0 then return "" end
                return string.rep(" ", space_size)
              end,
            },
            {
              name = "Icon",
              init = function(self)
                local filename = self.filename
                local extension = vim.fn.fnamemodify(filename, ":e")
                self.icon, self.icon_color =
                  require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
              end,
              provider = function(self)
                return self.icon and (self.icon .. " ")
              end,
              hl = function(self)
                return { fg = self.icon_color }
              end,
            },
            {
              name = "FileName",
              provider = function(self)
                return self.display_filename
              end,
            },
            {
              name = "RightSpace",
              condition = function(self)
                return self.display_right_space and self.display_right_space > 0
              end,
              provider = function(self)
                local space_size = self.display_right_space
                -- 减 1 是因为右边的 surround char
                if self.is_active or self.is_visible then space_size = space_size - 1 end
                if space_size <= 0 then return "" end

                -- if self.is_visible then space_size = space_size - 1 end
                return string.rep(" ", space_size)
              end,
            },
          },
        },
        FileFlags = {
          {
            condition = function(self)
              return vim.api.nvim_buf_get_option(self.bufnr, "modified")
            end,
            provider = " ◌ ",
            hl = { fg = "#2c2f3b" },
          },
          {
            condition = function(self)
              return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
            end,
            provider = "  ",
            hl = { fg = "orange" },
          },
        },
      },
      TabPage = {
        condition = function()
          return #vim.api.nvim_list_tabpages() >= 2
        end,
        { provider = "%=" },
        h_utils.make_tablist({
          provider = function(self)
            return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
          end,
          hl = function(self)
            return self.is_active and "TabLineSel" or "TabLine"
          end,
        }),
        { provider = "%999X 󰅙 %X", hl = "TabLine" },
      },
    }

    local FileInfoBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
      end,
      hl = function(self)
        if self.is_active then return config.active_color end
        if self.is_visible then return config.visible_color end
        return config.default_color
      end,
      -- components.buffer.ActiveIcon,
      -- components.buffer.WindowNumber,
      components.buffer.FileNameAndIcon,
      components.buffer.FileFlags,
    }

    local BufferLine = h_utils.make_buflist({
      { provider = " " },
      {
        components.buffer.surround.Left,
        FileInfoBlock,
        components.buffer.surround.Right,
      },
    })

    require("heirline").setup({
      tabline = { BufferLine, components.TabPage },
    })
  end,
}
