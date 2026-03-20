local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local entry_display = require 'telescope.pickers.entry_display'

local M = {}

local function get_tmux_sessions()
  local handle = io.popen 'tmux list-sessions 2>/dev/null'
  if not handle then
    return {}
  end

  local result = handle:read '*a'
  handle:close()

  local sessions = {}
  for line in result:gmatch '[^\r\n]+' do
    local name, windows, rest = line:match '^(.-):%s+(%d+)%s+windows?%s+%(created.-%)(.*)'
    if name then
      table.insert(sessions, {
        name = name,
        windows = tonumber(windows),
        attached = rest:match 'attached' ~= nil,
      })
    end
  end

  return sessions
end

function M.pick_session(opts)
  opts = opts or {}

  local sessions = get_tmux_sessions()
  if #sessions == 0 then
    vim.notify('No tmux sessions found', vim.log.levels.WARN)
    return
  end

  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = 30 },
      { width = 10 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value.name, 'TelescopeResultsIdentifier' },
      { entry.value.windows .. ' win', 'TelescopeResultsNumber' },
      { entry.value.attached and '(attached)' or '', 'TelescopeResultsComment' },
    }
  end

  pickers
    .new(opts, {
      prompt_title = 'Tmux Sessions',
      finder = finders.new_table {
        results = sessions,
        entry_maker = function(session)
          return {
            value = session,
            display = make_display,
            ordinal = session.name,
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            vim.fn.system { 'tmux', 'switch-client', '-t', selection.value.name }
          end
        end)
        return true
      end,
    })
    :find()
end

return M
