 
local wezterm = require "wezterm"
local inspect = require "inspect".inspect
local m = {}
m._LICENSE = [[
  MIT LICENSE

  Copyright (c) 2025 Md. Yeamin Sarder (yeaminsardersr@gmail.com)

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]


-- keys are something like LEADER|CTRL-h>LEADER|CTRL-p
-- add * to set oneshot to false
-- like this LEADER|CTRL-r*>f will allow you to just press 'f's after pressing LEADER|CTRL-r

function m.map_simple(config, keys, action, apply_to)
   local apply_to = apply_to or config.keys
   if (not apply_to) then
      config.keys = {}
      apply_to = config.keys
   end
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
         key = string.gsub(pair[1], '%*', ''), action = action
      })
   elseif #pair == 2 then
      table.insert(apply_to, {
         key = string.gsub(pair[2], '%*', ''), action = action, mods = pair[1]
      })
   else
      wezterm.log_error("pairs does not have 1 or 2 element (" .. inspect(pair) .. ")")
      return 1
   end
   return 0
end

function m.map(config, keys, action, apply_to, k)
   local k = k or nil
   local apply_to = apply_to or config.keys
   if (not apply_to) then
      config.keys = {}
      apply_to = config.keys
   end
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
      local gt = k and k .. ' > ' or ''
      local k = gt .. table.concat(seq[1], '-')
      local keymap = keytab[k] or {}
      local lastpair = seq[1][#seq[1]]
      local one_shot = lastpair:sub(#lastpair, #lastpair) ~= '*'
      m.map_simple(
         config, { seq[1] },
         wezterm.action.ActivateKeyTable { name = k, one_shot = one_shot }, apply_to
      )
      table.remove(seq, 1)
      m.map(config, seq, action, keymap, k)
      keytab[k] = keymap
      config['key_tables'] = keytab
   end
   -- wezterm.log_info(inspect(seq))
end

return m
