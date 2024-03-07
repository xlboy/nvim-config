local ts_utils = require("nvim-treesitter.ts_utils")
local cursor_node = ts_utils.get_node_at_cursor()

-- 跳转到下一个子节点的结束位置，如果没有子节点，则跳到下一个兄弟节点的首个子节点的结束位置，以此类推
function jump_next_child_node_end()
  local node = cursor_node --- @type TSNode
  if node == nil then return end

  local nextNamedNode = node:named_child_count() > 0 and node:named_child(0)
    or node:next_named_sibling()
    or node:parent():next_named_sibling() --- @type TSNode
  -- 输出此 node 的 text

  if nextNamedNode then print(vim.inspect(ts_utils.get_node_text(nextNamedNode))) end
end

jump_next_child_node_end()
