local u = require("utils")
local g_config = require("config.config")
local config = {
  active_color = g_config.colors.window.active,
  visible_color = g_config.colors.window.visible,
  default_color = g_config.colors.window.default,
  default_surround_char = g_config.symbols.rounded_corner,
  min_width = 20,
}

return {
  enabled = true,
  "rebelot/heirline.nvim",
  event = "UIEnter",
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
            local window_number = u.buffer.get_window_number(self.bufnr, constants.FT_IGNORES)
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
            self.display_filename = filename == "" and "[No Name]" or u.buffer.get_unique_filename(self.filename, true)
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
