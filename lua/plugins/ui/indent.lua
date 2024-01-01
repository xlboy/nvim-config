return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "UIEnter",
  config = function()
    vim.cmd("highlight XlboyIndentScope guifg=#7bdfd0")
    require("ibl").setup({
      indent = { char = "│" },
      scope = {
        show_start = false,
        show_end = false,
        highlight = "XlboyIndentScope",
      },
      exclude = {
        buftypes = { "nofile", "terminal" },
        filetypes = { "help", "alpha", "dashboard", "lazy", "neogitstatus", "NvimTree", "neo-tree" },
      },
    })
  end,
}
