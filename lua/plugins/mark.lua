local u = require("utils")
local t_extensions = require("telescope").extensions
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup({
        default = {
          select = function(list_item, list, options)
            local file_path = string.gsub(list_item.value, "^%s*(.-)%s*$", "%1")
            if vim.startswith(file_path, ">") then return vim.notify("选错啦…") end

            local file_pos = list_item.context
            vim.cmd("buffer " .. file_path)
            vim.api.nvim_win_set_cursor(0, { file_pos.row, file_pos.col })
          end,
        },
      })
    end,
    keys = {
      { ",a", "<cmd>lua require('harpoon'):list():append()<CR>", desc = "[Harpoon] Append" },
      {
        ",,",
        function()
          local h = require("harpoon")
          h.ui:toggle_quick_menu(h:list())
        end,
        desc = "[Harpoon] Toggle",
      },
    },
  },
  {
    "crusj/bookmarks.nvim",
    -- dir = u.basic.os_pick("D:\\project\\nvim\\bookmarks.nvim", "~/Desktop/xlboy/bookmarks.nvim"),
    -- event = "User Startup30s",
    keys = {
      { "<leader>ma", "<cmd>lua require('bookmarks').add_bookmarks()<CR>", desc = "[Bookmarks] Add" },
      { "<leader>mc", "<cmd>lua require('bookmarks.list').delete_on_virt()<CR>", desc = "[Bookmarks] Delete" },
      { "<leader>ml", "<cmd>lua require('bookmarks').toggle_bookmarks()<CR>", desc = "[Bookmarks] Show List" },
      { "<leader>ms", "<cmd>lua require('bookmarks.list').show_desc()<CR>", desc = "[Bookmarks] Show Desc" },
    },
    config = function()
      require("bookmarks").setup({
        keymap = { toggle = "<M-\\>" },
        virt_pattern = { "*.lua", "*.ts", "*.tsx", "*.js", "*.jsx" },
        fix_enable = true,
      })
      require("telescope").load_extension("bookmarks")
      vim.cmd("hi! link bookmarks_virt_text_hl BufferAlternateHINT")
    end,
  },
}
