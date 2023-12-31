return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  enabled = false,
  keys = {
    {
      "<leader>ue",
      function()
        local old_ft = vim.bo.filetype
        require("edgy").toggle()
        local new_ft = vim.bo.filetype
        if old_ft == "neo-tree" or old_ft == new_ft then vim.cmd("FocusAutoresize") end
      end,
      desc = "Edgy Toggle",
    },
      -- stylua: ignore
      { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
  },
  opts = function()
    local opts = {
      animate = { enabled = false },
      bottom = {
        "Trouble",
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          -- don't open help files in edgy that we're editing
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        -- { ft = "spectre_panel", size = { height = 0.4 } },
        { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
      },
      left = {
        {
          title = "Neo Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          pinned = true,
          open = function()
            vim.api.nvim_input("<esc><space>e")
          end,
          size = { height = 0.8 },
        },
        {
          title = "Symbol Outline",
          ft = "Outline",
        },
      },
      keys = {
        -- increase width
        ["<c-Right>"] = function(win)
          win:resize("width", 2)
        end,
        -- decrease width
        ["<c-Left>"] = function(win)
          win:resize("width", -2)
        end,
        -- increase height
        ["<c-Up>"] = function(win)
          win:resize("height", 2)
        end,
        -- decrease height
        ["<c-Down>"] = function(win)
          win:resize("height", -2)
        end,
      },
    }
    return opts
  end,
}
