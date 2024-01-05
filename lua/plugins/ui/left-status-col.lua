return {
  "luukvbaal/statuscol.nvim",
  commit = "3b629754420919575a9e5758027d6e1831dbf2aa",
  event = "BufRead",
  init = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.foldmethod = "indent"
  end,
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      thousands = true,
      segments = {
        { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        { text = { "%s" }, click = "v:lua.ScSa" },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
      },
    })
  end,
}
