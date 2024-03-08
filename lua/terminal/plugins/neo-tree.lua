local u = require("terminal.utils")

return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>e",
      function()
        local old_ft = vim.bo.filetype
        vim.cmd("Neotree toggle focus left")
        local new_ft = vim.bo.filetype
        if old_ft == "neo-tree" or old_ft == new_ft then
          vim.cmd("FocusAutoresize")
          -- require("tint").disable()
          -- require("tint").enable()
        end
      end,
      desc = "Neotree toggle",
    },
    {
      "<leader>o",
      function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd.wincmd("p")
        else
          vim.cmd.Neotree("focus")
        end
      end,
      desc = "Toggle Explorer Focus",
    },
  },
  opts = function(_, opts)
    opts.sources = { "filesystem" }
    opts.source_selector = {
      sources = {
        { source = "filesystem" },
      },
    }
    opts.filesystem = {
      find_by_full_path_words = true,
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
    }

    opts.commands = {}
    opts.commands["reveal_in_finder"] = function(state)
      local node = state.tree:get_node()
      local file_dir = vim.fn.fnamemodify(node.path, ":h")
      u.fs.open_dir_in_finder(file_dir)
    end
    opts.commands["switch_to_editor"] = function()
      vim.cmd.wincmd("p")
    end

    opts.window = { mappings = {} }
    opts.window.mappings["<C-r>"] = "reveal_in_finder"
    opts.window.mappings["<leader>o"] = "switch_to_editor"
    opts.window.mappings["l"] = "open_with_window_picker"
    opts.window.mappings["h"] = "close_node"

    return opts
  end,
}
