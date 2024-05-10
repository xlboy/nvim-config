local u = require("terminal.utils")
local config = require("terminal.config.config")

local helpers = {
  get_content_hl = function(props)
    return props.focused and config.colors.window.active or config.colors.window.visible
  end,
}

local render = {
  filename = function(props)
    local content_hl = helpers.get_content_hl(props)
    local filename_content = { guifg = content_hl.fg, guibg = content_hl.bg }

    local is_modified = vim.api.nvim_get_option_value("modified", { buf = props.buf })
    if is_modified then filename_content.guifg = config.colors.modified.fg end

    local filepath = vim.api.nvim_buf_get_name(props.buf)
    local filename = vim.fn.fnamemodify(filepath, ":t")
    local relative_path = vim.fn.fnamemodify(filepath, ":~:." .. vim.fn.getcwd() .. ":.")

    table.insert(filename_content, filename)

    return filename_content
  end,
  directory_path = function(props)
    local content_hl = helpers.get_content_hl(props)
    local filepath = vim.api.nvim_buf_get_name(props.buf)
    local relative_path = vim.fn.fnamemodify(filepath, ":~:." .. vim.fn.getcwd() .. ":.")
    local directory_path = vim.fn.fnamemodify(relative_path, ":h")
    return { directory_path, guifg = content_hl.comment }
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
  line_number = function(props)
    local content_hl = helpers.get_content_hl(props)
    local line_number = vim.api.nvim_win_get_cursor(props.win)[1]
    local line_percent = math.floor(line_number / vim.api.nvim_buf_line_count(props.buf) * 100)
    return {
      { string.format("L%s,P%s%%", line_number, line_percent), guifg = content_hl.comment, guibg = content_hl.bg },
    }
  end,
}

return {
  "b0o/incline.nvim",
  event = "User BufRead",
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

        local diagnostics = render.diagnostics(props)
        local separator = { " | ", guifg = "grey" }
        local recorder_text = require("recorder").displaySlots() .. require("recorder").recordingStatus()

        return {
          render.rounded_corner.left(props),
          {
            guibg = content_hl.bg,
            guifg = content_hl.fg,
            { recorder_text, guifg = "#ff9e64" },
            recorder_text ~= "" and separator or {},
            render.line_number(props),
            separator,
            diagnostics,
            #diagnostics == 0 and {} or separator,
            render.file_icon(props),
            { " " },
            render.filename(props),
            separator,
            render.directory_path(props),
          },
          render.rounded_corner.right(props),
        }
      end,
    })
  end,
}
