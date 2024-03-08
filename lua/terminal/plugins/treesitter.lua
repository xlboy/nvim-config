return {
  {
    "xlboy/nvim-treesitter",
    event = "User BufRead",
    -- lazy  = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = { "bash", "yaml", "query", "regex" },
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          node_decremental = "<BS>",
          scope_incremental = "<TAB>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
        },
        move = (function()
          local goto_source = {
            -- { key = "k", query = "@block.outer", desc = "block" },
            { key = "fo", query = "@function.outer", desc = "function" },
            { key = "fi", query = "@function.inner", desc = "function" },
            { key = "a", query = "@parameter.inner", desc = "argument" },
            { key = "r", query = "@return.outer", desc = "return" },
            { key = "if", query = "@conditional.outer", desc = "conditional" },
            { key = "l", query = "@loop.outer", desc = "loog(while, for, repeat)" },
            { key = "m", query = "@comment.outer", desc = "comment" },
          }
          local goto = { next = {}, prev = {} }
          for _, v in ipairs(goto_source) do
            goto.next["]" .. v.key] = { query = v.query, desc = "Next " .. v.desc }
            goto.prev["[" .. v.key] = { query = v.query, desc = "Previous " .. v.desc }
          end

          return {
            enable = true,
            set_jumps = true,
            goto_next_start = goto.next,
            goto_previous_start = goto.prev,
          }
        end)(),
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "[c", "<cmd>lua require('treesitter-context').go_to_context()<CR>", mode = "n" },
    },
  },
}
