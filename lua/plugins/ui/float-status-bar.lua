local u = require("utils")
local config = require("config.config")

local buf_name_maps = {}

local helpers = {
  get_content_hl = function(props)
    return props.focused and config.colors.window.active or config.colors.window.visible
  end,
}

local render = {
  filename = function(props)
    local content_hl = helpers.get_content_hl(props)
    local content = { guifg = content_hl.fg, guibg = content_hl.bg }

    local is_modified = vim.api.nvim_get_option_value("modified", { buf = props.buf })
    if is_modified then content.guifg = config.colors.modified.fg end

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
    local content_hl = helpers.get_content_hl(props)

    local filename = vim.api.nvim_buf_get_name(props.buf)
    local icon, color = require("nvim-web-devicons").get_icon_color(filename)
    return { icon, guifg = color, guibg = content_hl.bg }
  end,
  modified_icon = function(props)
    local modified_icon = { guibg = helpers.get_content_hl(props).bg }
    if vim.api.nvim_get_option_value("modified", { buf = props.buf }) then
      modified_icon = vim.tbl_extend("force", { "●" }, { guifg = config.colors.modified.fg })
    end
    return modified_icon
  end,
  diagnostics = function(props)
    local icons = { Error = "", Warn = "", Info = "" }
    local content_bg = helpers.get_content_hl(props).bg

    local diagnostics = {}
    for severity, icon in pairs(icons) do
      local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
      if n > 0 then
        table.insert(diagnostics, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity, guibg = content_bg })
      end
    end

    if #diagnostics > 0 then table.insert(diagnostics, { "| ", guifg = "grey", guibg = content_bg }) end

    return diagnostics
  end,
  rounded_corner = {
    left = function(props)
      if props.focused then return { "", guifg = config.colors.window.active.bg, guibg = "None" } end
      return { "", guifg = config.colors.window.visible.bg }
    end,
    right = function(props)
      if props.focused then return { "", guifg = config.colors.window.active.bg, guibg = "None" } end
      return { "", guifg = config.colors.window.visible.bg }
    end,
  },
}

return {
  "b0o/incline.nvim",
  event = "BufRead",
  config = function()
    require("incline").setup({
      debounce_threshold = { falling = u.basic.os_pick(80, 150), rising = u.basic.os_pick(80, 150) },
      highlight = {
        groups = {
          InclineNormal = { guibg = "None", guifg = config.colors.window.active.fg },
          InclineNormalNC = { guibg = "None", guifg = config.colors.window.visible.fg },
        },
      },
      window = {
        placement = { horizontal = "center" },
        margin = { vertical = 3, horizontal = 0 },
        padding = 0,
        winhighlight = { active = {}, inactive = {} },
      },
      hide = { cursorline = true },
      ignore = { filetypes = config.ft_ignores },
      render = function(props)
        local filename = vim.api.nvim_buf_get_name(props.buf)
        if filename == "" then return end

        local content_hl = props.focused and config.colors.window.active or config.colors.window.visible

        return {
          render.rounded_corner.left(props),
          {
            guibg = content_hl.bg,
            guifg = content_hl.fg,
            render.diagnostics(props),
            render.file_icon(props),
            { " " },
            render.filename(props),
            { " " },
          },
          render.rounded_corner.right(props),
        }
      end,
    })
  end,
}
