local config = {
  active_color = { bg = "#17c0eb", fg = "#dff9fb" },
  visible_color = { bg = "#16a2c5", fg = "#82AAFF" },
  default_color = { bg = "#1e222a", fg = "#B0BEC5" },
  default_surround_char = { left = "", right = "" },
}

return {
  enabled = true,
  "rebelot/heirline.nvim",
  config = function()
    local h_conditions = require("heirline.conditions")
    local h_utils = require("heirline.utils")

    local components = {
      buffer = {
        ActiveOrVisibleIcon = {
          condition = function(self)
            return self.is_active or self.is_visible
          end,
          provider = function(self)
            return self.is_active and "● " or "○ "
          end,
          hl = function(self)
            return { bold = self.is_active }
          end,
        },
        surround = {
          Left = {
            condition = function(self)
              return self.is_active or self.is_visible
            end,
            provider = function(self)
              local str = config.default_surround_char.left
              return config.default_surround_char.left .. (self.is_active and "●" or "○") .. " "
            end,
            hl = { bg = "none" },
          },
          Right = {
            condition = function(self)
              return self.is_active or self.is_visible
            end,
            provider = config.default_surround_char.right,
          },
        },
        FileName = {
          provider = function(self)
            local filename = self.filename
            filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
            return filename
          end,
          hl = function(self)
            return { bold = self.is_active }
          end,
        },
        FileFlags = {
          {
            condition = function(self)
              return vim.api.nvim_buf_get_option(self.bufnr, "modified")
            end,
            provider = "[+]",
            hl = { fg = "green" },
          },
          {
            condition = function(self)
              return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
            end,
            provider = function(self)
              if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
                return "  "
              else
                return ""
              end
            end,
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
            if not self.is_active then
              return "TabLine"
            else
              return "TabLineSel"
            end
          end,
        }),
        { provider = "%999X 󰅙 %X", hl = "TabLine" },
      },
    }

    local TablineFileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
      end,
      hl = function(self)
        if self.is_active then return config.active_color end
        if self.is_visible then return config.visible_color end
        return config.default_color
      end,
      {
        components.buffer.surround.Left,
        components.buffer.FileName,
        components.buffer.surround.Right,
      },
      components.buffer.FileFlags,
    }

    -- The final touch!
    -- local edge = { { " ", "" }, { " ", " " }, { " ☾", "☽ " } }
    -- local TablineBufferBlock = h_utils.surround(edge[1], function(self)
    --   if self.is_active then return h_utils.get_highlight("TabLineSel").bg end
    --
    --   -- if self.is_active then
    --   --   return h_utils.get_highlight("TabLineSel").bg
    --   -- else
    --   --   return h_utils.get_highlight("TabLine").bg
    --   -- end
    -- end, { TablineFileNameBlock })

    local BufferLine = h_utils.make_buflist({
      { provider = " " },
      TablineFileNameBlock,
    })

    require("heirline").setup({
      tabline = { BufferLine, components.TabPage },
    })
  end,
}
