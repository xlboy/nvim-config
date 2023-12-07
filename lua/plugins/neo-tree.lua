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
    { "<leader>e", "<cmd>Neotree toggle focus<cr>", desc = "Neotree toggle" },
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
    opts.sources = {
      "filesystem",
    }
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
      if node then
        vim.fn.execute("!open -R " .. node.path)
      end
    end
    opts.commands["switch_to_editor"] = function()
      vim.cmd.wincmd("p")
    end

    opts.window = { mappings = {} }
    opts.window.mappings["<C-r>"] = "reveal_in_finder"
    opts.window.mappings["<leader>o"] = "switch_to_editor"

    return opts
  end,
}
