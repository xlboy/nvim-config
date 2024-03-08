local u = require("terminal.utils")

--- Table based API for setting keybindings
---@param map_table table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
---@param base? table A base set of options to set on every keybinding
local function set_mappings(map_table, base)
  local _which_key_queue
  local function which_key_register()
    if _which_key_queue then
      local wk_avail, wk = pcall(require, "which-key")
      if wk_avail then
        for mode, registration in pairs(_which_key_queue) do
          wk.register(registration, { mode = mode })
        end
        _which_key_queue = nil
      end
    end
  end
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not keymap_opts.name then keymap_opts.name = keymap_opts.desc end
          if not _which_key_queue then _which_key_queue = {} end
          if not _which_key_queue[mode] then _which_key_queue[mode] = {} end
          _which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  if package.loaded["which-key"] then which_key_register() end -- if which-key is loaded already, register
end

set_mappings({
  n = {
    ["'d"] = { '"0d' },
    ["'c"] = { '"0c' },
    ["<S-w>"] = { "3w" },
    ["<S-b>"] = { "3b" },
    ["<leader>jo"] = { "<CMD>join<CR>" },
    ["<leader>all"] = { "ggVG" },
    ["<S-h>"] = { "^" },
    ["<S-l>"] = { "$" },
    ["<S-k>"] = { "8k" },
    ["<S-j>"] = { "8j" },
    ["<S-u>"] = { "20k" },
    ["<S-d>"] = { "20j" },
    ["<C-q>"] = { "<cmd>qa!<cr>" },
    ["<leader>q"] = { "<cmd>confirm q<cr>" },
    ["<leader>w"] = { "<cmd>w<cr>" },
    ["<leader>n"] = { "<cmd>enew<cr>" },
    ["<C-h>"] = { "<cmd>wincmd h<cr>" },
    ["<C-j>"] = { "<cmd>wincmd j<cr>" },
    ["<C-k>"] = { "<cmd>wincmd k<cr>" },
    ["<C-l>"] = { "<cmd>wincmd l<cr>" },
    ["|"] = { "<cmd>vsplit<cr>" },
    ["\\"] = { "<cmd>split<cr>" },
    ["<leader>un"] = { u.ui.change_number, desc = "UI - Change number mode" },
    ["{"] = { "<cmd>bprevious<CR>" },
    ["}"] = { "<cmd>bnext<CR>" },
    ["[t"] = { "<cmd>tabprevious<CR>" },
    ["]t"] = { "<cmd>tabnext<CR>" },
    ["<leader>gbl"] = { "<cmd>Telescope git_branches<CR>" },
    ["<leader>gfc"] = { "<cmd>Telescope git_status<CR>" },
    ["<leader>lazy"] = { "<cmd>Lazy<CR>" },
    ["<leader>ucc"] = {
      function()
        vim.wo.cursorcolumn = not vim.wo.cursorcolumn
      end,
    },
  },
  v = {
    ["y"] = { '"+ygv<esc>' },
    ["<S-h>"] = { "^" },
    ["<S-l>"] = { "$" },
    ["<S-k>"] = { "8k" },
    ["<S-j>"] = { "8j" },
    ["<S-u>"] = { "20k" },
    ["<S-d>"] = { "20j" },
    ["'d"] = { '"0d' },
    ["'c"] = { '"0c' },
    ["<S-w>"] = { "3w" },
    ["<S-b>"] = { "3b" },
  },
  i = {
    ["jk"] = { "<esc>" },
    ["kj"] = { "<esc>" },
  },
})
