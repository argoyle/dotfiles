-- Prefix a tab's label when a program in it needs you, and clear it when you
-- open the tab. Rex's own dot can't be restyled. Run with: rex do attention.lua --all
-- Claude Code reports `done`, not `blocked`, when it stops and waits for input.
-- ponytail: "seen" means the session's active tab; Rex doesn't expose client
-- focus, so a tab that finishes while Rex is in the background stays unmarked.
local MARKS = { blocked = "🔴", error = "🔴", done = "🟠" }
local RANK = { ["🔴"] = 2, ["🟠"] = 1 }

local states = {}

local function strip(label)
  for _, mark in pairs(MARKS) do
    if label:sub(1, #mark + 1) == mark .. " " then
      return label:sub(#mark + 2)
    end
  end
  return label
end

local function blocks_of(window)
  local ids = {}
  for _, layer in ipairs(window.layers or {}) do
    for _, block in ipairs(layer.blocks or {}) do
      table.insert(ids, block.block_id)
    end
  end
  return ids
end

local function set_mark(window, mark)
  local plain = strip(window.label)
  local label = mark and (mark .. " " .. plain) or plain
  if label ~= window.label then
    rex.session.set_window_label{ window_id = window.window_id, label = label }
  end
end

local function refresh()
  local view = rex.session.view{}
  if not view then return end -- the session was just destroyed
  for _, window in ipairs(view.windows) do
    local mark
    for _, id in ipairs(blocks_of(window)) do
      if window.window_id == view.active_window_id then
        states[id] = nil
      end
      local candidate = MARKS[states[id]]
      if candidate and (not mark or RANK[candidate] > RANK[mark]) then
        mark = candidate
      end
    end
    set_mark(window, mark)
  end
end

rex.on("terminal.program_status_changed", function(ctx, ev)
  states[ctx.block_id] = ev.record and ev.record.state
  refresh()
end)

rex.on("terminal.program_status_removed", function(ctx)
  states[ctx.block_id] = nil
  refresh()
end)

rex.on("session_view_changed", function()
  refresh()
end)
