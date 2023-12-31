return {
  {
    "kazhala/close-buffers.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>cc", ":BDelete! this<CR>", desc = "Delete Current Buffer" },
      { "<leader>ca", ":BDelete! all<CR>", desc = "Delete All Buffer" },
      { "<leader>co", ":BDelete! other<CR>", desc = "Delete Other Buffer" },
      { "<leader>cn", ":BDelete! nameless<CR>", desc = "Delete Nameless Buffer" },
      {
        "<leader>cs",
        function()
          local suffix = vim.fn.input("Suffix: ")
          if suffix ~= "" then vim.cmd(":BDelete! regex=.*[.]" .. suffix) end
        end,
        desc = "Delete Specify Suffix Buffer",
      },
      {
        "<leader>cg",
        function()
          local pattern = vim.fn.input("Glob Pattern: ")
          if pattern ~= "" then vim.cmd(":BDelete! glob=" .. pattern) end
        end,
        desc = "Delete Specify Suffix Buffer",
      },
    },
  },
  -- ui
  {
    enabled = false,
    "akinsho/bufferline.nvim",
    config = function()
      vim.o.mousemoveevent = true
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              highlight = "Directory",
              text_align = "center",
            },
          },
          always_show_bufferline = true,
          show_tab_indicators = false,
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            -- only show warning and error
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or "")
              s = s .. sym .. n
            end
            return s
          end,
          hover = {

            delay = 36,
            reveal = { "close" },
            enabled = true,
          },
          style_preset = "slant",
        },
      })
    end,
  },
  {
    "rebelot/heirline.nvim",
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local tabline = {}

      -- we redefine the filename component, as we probably only want the tail and not the relative path
      local TablineFileName = {
        provider = function(self)
          -- self.filename will be defined later, just keep looking at the example!
          local filename = self.filename
          filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
          return filename
        end,
        hl = function(self)
          return { bold = self.is_active or self.is_visible, italic = false }
        end,
      }

      -- this looks exactly like the FileFlags component that we saw in
      -- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
      -- also, we are adding a nice icon for terminal buffers.
      local TablineFileFlags = {
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
      }

      -- this is the default function used to retrieve buffers
      local get_bufs = function()
        return vim.tbl_filter(function(bufnr)
          return vim.api.nvim_buf_get_option(bufnr, "buflisted")
        end, vim.api.nvim_list_bufs())
      end

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
        TablineFileName,
        TablineFileFlags,
      }

      local TabPages = {
        condition = function()
          return #vim.api.nvim_list_tabpages() >= 2
        end,
        { provider = "%=" },
        utils.make_tablist({
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
      }

      -- The final touch!
      local TablineBufferBlock = utils.surround({ "", "" }, function(self)
        if self.is_active then
          return utils.get_highlight("TabLineSel").bg
        else
          return utils.get_highlight("TabLine").bg
        end
      end, { TablineFileNameBlock })

      local BufferLine = utils.make_buflist(TablineBufferBlock)

      local TabLine = { BufferLine, TabPages }
      require("heirline").setup({ tabline = TabLine })
    end,
  },
}
