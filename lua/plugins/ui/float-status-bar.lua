local u = require("utils")
return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 1200,
  config = function()
    require("incline").setup({
      -- highlight = {
      --   groups = {
      --     InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
      --     InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
      --   },
      -- },
      window = { margin = { vertical = 0, horizontal = 1 } },
      hide = { cursorline = false },
      render = function(props)
        local u_filename = u.buffer.get_unique_filename(vim.api.nvim_buf_get_name(props.buf), false)
        if vim.bo[props.buf].modified then u_filename = "[+] " .. u_filename end

        local icon, color = require("nvim-web-devicons").get_icon_color(u_filename)

        return { { icon, guifg = color }, { " " }, { u_filename } }
      end,
    })
  end,
}
