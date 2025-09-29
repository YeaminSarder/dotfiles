local wezterm = require "wezterm"
local inspect = require "inspect".inspect
local m = {}

-- keys are something like LEADER|CTRL-h>LEADER|CTRL-p

-- function m.mapraw(config, keys_table, action)

function m.map_simple(config, keys, action, apply_to)
   local apply_to = apply_to or config.keys
   local seq = {}
   if type(keys) == 'string' then
      local keys = string.gsub(keys, "%s", "")
      for mod_ltr in string.gmatch(keys, "[^>]+") do
         local pair = {}
         for ms in string.gmatch(mod_ltr, "[^-]+") do
            table.insert(pair, ms)
         end
         table.insert(seq, pair)
      end
   elseif type(keys) == 'table' then
      seq = keys
   else
      wezterm.log_error("keys are either string or a table")
   end
   if #seq ~= 1 then
      wezterm.log_error("map_simple does not support sequences")
      return 1
   end
   local pair = seq[1]
   if #pair == 1 then
      table.insert(apply_to, {
         key = pair[1], action = action
      })
   elseif #pair == 2 then
      table.insert(apply_to, {
         key = pair[2], action = action, mods = pair[1]
      })
   else
      wezterm.log_error("pairs does not have 1 or 2 element (" .. inspect(pair) .. ")")
      return 1
   end
   return 0
end

function m.map(config, keys, action, apply_to)
   local apply_to = apply_to or config.keys
   local seq = {}
   if type(keys) == 'string' then
      local keys = string.gsub(keys, "%s", "")
      for mod_ltr in string.gmatch(keys, "[^>]+") do
         local pair = {}
         for ms in string.gmatch(mod_ltr, "[^-]+") do
            table.insert(pair, ms)
         end
         table.insert(seq, pair)
      end
   elseif type(keys) == 'table' then
      seq = keys
   else
      wezterm.log_error("keys are either string or a table")
   end
   if #seq == 1 then
      m.map_simple(config, seq, action, apply_to)
   elseif #seq > 1 then
      local keytab = config.key_tables or {}
      local k = table.concat(seq[1], '-')
      local keymap = keytab[k] or {}
      m.map_simple(
         config, { seq[1] },
         wezterm.action.ActivateKeyTable { name = k, one_shot = true }, apply_to
      )
      table.remove(seq, 1)
      m.map(config, seq, action, keymap)
      keytab[k] = keymap
      config['key_tables'] = keytab
   end
   -- wezterm.log_info(inspect(seq))
end

return m
