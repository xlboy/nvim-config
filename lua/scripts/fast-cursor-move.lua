local fn = vim.fn

local get_move_step = (function()
  local prev_direction
  local prev_time = 0
  local move_count = 0
  local ACCELERATION_TABLE_VERTICAL = { 5, 10, 15, 20, 30, 40, 50 }
  local ACCELERATION_TABLE_HORIZONTAL = { 5, 10, 15, 20 }

  local ACCELERATION_LIMIT = 50
  return function(direction)
    if direction ~= prev_direction then
      prev_time = 0
      move_count = 0
      prev_direction = direction
    else
      local time = vim.loop.hrtime()
      local elapsed = (time - prev_time) / 1e6
      if elapsed > ACCELERATION_LIMIT then
        move_count = 0
      else
        move_count = move_count + 1
      end
      prev_time = time
    end

    local acceleration_table = (
      (direction == "j" or direction == "k") and ACCELERATION_TABLE_VERTICAL or ACCELERATION_TABLE_HORIZONTAL
    )
    -- calc step
    for idx, count in ipairs(acceleration_table) do
      if move_count < count then return idx end
    end
    return #acceleration_table
  end
end)()

local function get_move_chars(direction)
  if direction == "j" then
    return "gj"
  elseif direction == "k" then
    return "gk"
  else
    return direction
  end
end

local function move(direction)
  local move_chars = get_move_chars(direction)

  if fn.reg_recording() ~= "" or fn.reg_executing() ~= "" then return move_chars end

  if vim.v.count > 0 then return move_chars end

  local step = get_move_step(direction)
  return step .. move_chars
end

local function setup()
  for _, motion in ipairs({
    "h",
    "j",
    "k",
    "l", --[[ "w", "b" ]]
  }) do
    vim.keymap.set({ "n", "v" }, motion, function()
      return move(motion)
    end, { expr = true })
  end
end

vim.defer_fn(setup, 500)
