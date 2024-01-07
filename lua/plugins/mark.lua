local t_extensions = require("telescope").extensions
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        cmd = {
          add = function(possible_value)
            -- get the current line idx
            local idx = vim.fn.line(".")

            -- read the current line
            local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
            if cmd == nil then return nil end

            return {
              value = cmd,
              context = {},
            }
          end,
          select = function(list_item, list, option)
            -- WOAH, IS THIS HTMX LEVEL XSS ATTACK??
            -- vim.cmd(list_item.value)
            print("🪚 value: " .. vim.inspect(list_item.value))
          end,
        },
      })

      vim.keymap.set("n", ",a", function()
        harpoon:list():append()
      end)
      vim.keymap.set("n", ",,", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
    end,
  },
  {
    "ten3roberts/bookmarks.nvim",
    branch = "feat-scoped-bookmarks",
    event = "User Startup30s",
    keys = {
      { "<leader>mt", description = "[bookmark] add or remove mark at current line" },
      { "<leader>mi", description = "[bookmark] add or edit mark annotation at current line" },
      { "<leader>mc", description = "[bookmark] clean all marks in local buffer" },
      { "<leader>mj", description = "[bookmark] jump to next mark in local buffer" },
      { "<leader>mk", description = "[bookmark] jump to previous mark in local buffer" },
      { "<leader>ml", description = "[bookmark] list all marks in local buffer" },
    },
    config = function()
      require("bookmarks").setup({
        scoped = true,
        on_attach = function(bufnr)
          local bm = require("bookmarks")
          local map = vim.keymap.set
          map("n", "<leader>mt", bm.bookmark_toggle) -- add or remove bookmark at current line
          map("n", "<leader>mi", bm.bookmark_ann) -- add or edit mark annotation at current line
          map("n", "<leader>mc", bm.bookmark_clean) -- clean all marks in local buffer
          map("n", "<leader>mj", bm.bookmark_next) -- jump to next mark in local buffer
          map("n", "<leader>mk", bm.bookmark_prev) -- jump to previous mark in local buffer
          map("n", "<leader>ml", function()
            t_extensions.bookmarks.list({ previewer = false })
          end)
        end,
      })
      require("telescope").load_extension("bookmarks")
    end,
  },
}
