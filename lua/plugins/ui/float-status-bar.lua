local u = require("utils")

local colors = {
  modified = {
    guifg = "#d6991d",
  },
}

local config = {
  active_color = { bg = "#17c0eb", fg = "#ffffff" },
  visible_color = { bg = "#2f3640", fg = "#afc5c7" },
  default_color = { bg = "none", fg = "#B0BEC5" },
  default_surround_char = { left = "", right = "" },
}

local buf_name_maps = {}

local render = {
  filename = function(props)
    local content = {}

    local is_modified = vim.api.nvim_get_option_value("modified", { buf = props.buf })
    if is_modified then content.guifg = colors.modified.guifg end

    if buf_name_maps[props.buf] then
      table.insert(content, buf_name_maps[props.buf])
      return content
    end

    local u_filename = u.buffer.get_unique_filename(vim.api.nvim_buf_get_name(props.buf), false)
    buf_name_maps[props.buf] = u_filename
    table.insert(content, u_filename)
    return content
  end,
  file_icon = function(props)
    local filename = vim.api.nvim_buf_get_name(props.buf)
    local icon, color = require("nvim-web-devicons").get_icon_color(filename)
    return { { icon, guifg = color } }
  end,
  modified_icon = function(props)
    local modified_icon = {}
    if vim.api.nvim_get_option_value("modified", { buf = props.buf }) then
      modified_icon = vim.tbl_extend("force", { "●" }, colors.modified)
    end
    return modified_icon
  end,
  diagnostics = function(props)
    local icons = { Error = "", Warn = "", Info = "" }

    local diagnostics = {}
    for severity, icon in pairs(icons) do
      local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
      if n > 0 then table.insert(diagnostics, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity }) end
    end

    if #diagnostics > 0 then table.insert(diagnostics, { "| ", guifg = "grey" }) end

    return diagnostics
  end,
}

return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  config = function()
    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = { guibg = "none" },
          InclineNormalNC = { guifg = "none" },
        },
      },
      window = {
        margin = { vertical = 2, horizontal = 1 },
        padding = 0,
      },
      hide = { cursorline = false },
      render = function(props)
        return {
          render.diagnostics(props),
          render.file_icon(props),
          { " " },
          render.filename(props),
          { " " },
        }
      end,
    })
  end,
}
