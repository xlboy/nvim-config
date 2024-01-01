local config = {
  active_color = { bg = "#17c0eb", fg = "#ffffff" },
  visible_color = { bg = "#2f3640", fg = "#dff9fb" },
  default_color = { bg = "none", fg = "#B0BEC5" },
  default_surround_char = { left = "", right = "" },
}

local utils = {
  get_window_number = function(bufnr, ft_ignores)
    ft_ignores = ft_ignores or { "neo-tree" }
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
            return window_number .. ". "
          end,
          hl = function(self)
            local fg = self.is_active and config.active_color.fg or config.visible_color.fg
            return { fg = fg }
          end,
        },
        FileIcon = {
          -- condition = function(self)
          --   return not self.is_active
          -- end,
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
        FileName = {
          provider = function(self)
            local filename = self.filename
            filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
            -- return " " .. filename .. " "
            return filename
          end,
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
      components.buffer.WindowNumber,
      components.buffer.FileIcon,
      components.buffer.FileName,
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
