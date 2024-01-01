local config = {}

return {
  "rebelot/heirline.nvim",
  config = function()
    local h_conditions = require("heirline.conditions")
    local h_utils = require("heirline.utils")

    local components = {
      buffer = {
        FileName = {
          provider = function(self)
            -- self.filename will be defined later, just keep looking at the example!
            local filename = self.filename
            filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
            return filename
          end,
          hl = function(self)
            return { bold = self.is_active or self.is_visible, italic = false }
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
        { provider = "%999X  %X", hl = "TabLine" },
      },
    }

    local TablineFileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
      end,
      hl = function(self)
        if self.is_active then
          return "TabLineSel"
          -- why not?
          -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
          --     return { fg = "gray" }
        else
          return "TabLine"
        end
      end,
      on_click = {
        callback = function(_, minwid, _, button)
          if button == "m" then -- close on mouse middle click
            vim.schedule(function()
              vim.api.nvim_buf_delete(minwid, { force = false })
            end)
          else
            vim.api.nvim_win_set_buf(0, minwid)
          end
        end,
        minwid = function(self)
          return self.bufnr
        end,
        name = "heirline_tabline_buffer_callback",
      },
      components.buffer.FileName,
      components.buffer.FileFlags,
    }

    -- The final touch!
    local TablineBufferBlock = h_utils.surround({ " ", "" }, function(self)
      if self.is_active then
        return h_utils.get_highlight("TabLineSel").bg
      else
        return h_utils.get_highlight("TabLine").bg
      end
    end, { TablineFileNameBlock })

    local BufferLine = h_utils.make_buflist(TablineBufferBlock)

    require("heirline").setup({ tabline = { BufferLine, components.TabPage } })
  end,
}
