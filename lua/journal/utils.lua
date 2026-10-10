local utils = {}

local ENTRY_DATE_FORMAT = "(%d%d%d%d%-%d%d%-%d%d)"
local ENTRY_NOT_FOUND = -1

local ENTRY_FILE_PATTERN = "^%d%d%d%d%-%d%d%-%d%d.*%.md$"

-- Directions
local FORWARD  =  1
local BACKWARD = -1

--- Returns sorted journal entry filenames (YYYY-MM-DD*.md)
--- @param directory string
--- @return table
local function list_entries(directory)
   return vim.fn.readdir(directory, function(name)
      return name:match(ENTRY_FILE_PATTERN) and 1 or 0
   end)
end

--- Opens path without touching the alternate file; wipes the previous buffer if it was
--- an unmodified journal entry not shown in another window
--- @param path string
function utils.open_entry(path)
   local prev = vim.api.nvim_get_current_buf()
   local was_entry = vim.api.nvim_buf_get_name(prev):match("/Journal/%d%d%d%d%-%d%d%-%d%d")
   vim.cmd("keepalt edit " .. vim.fn.fnameescape(path))
   if was_entry and prev ~= vim.api.nvim_get_current_buf()
      and not vim.bo[prev].modified and #vim.fn.win_findbuf(prev) == 0 then
      vim.api.nvim_buf_delete(prev, {})
   end
end

--- Returns the index of the current entry within journal directory
--- @param files table
--- @return number
local function get_current_entry_index(files)
   local current_entry = vim.api.nvim_buf_get_name(0):match(ENTRY_DATE_FORMAT)

   for index, file in ipairs(files) do
      if file:match(ENTRY_DATE_FORMAT) == current_entry then
         return index
      end
   end

   return -1
end

--- Jumps to the next entry or the previous entry
--- @param journal_path string
--- @param direction number
function utils.jump(journal_path, direction)
   local PROMPT_1 = "current page name is not in the correct formate"
   local PROMPT_2 = "You are at the first entry cannot jump backwards"
   local PROMPT_3 = "You are at the last entry cannot jump forward"

   local files = list_entries(journal_path)
   local current_entry_index = get_current_entry_index(files)

   if current_entry_index == ENTRY_NOT_FOUND then
      print(PROMPT_1)
   elseif current_entry_index == 1 and direction == BACKWARD then
      print(PROMPT_2)
   elseif current_entry_index == #files and direction == FORWARD then
      print(PROMPT_3)
   else
      utils.open_entry(journal_path .. files[current_entry_index + direction])
   end
end

--- Creates an markdwon file with the current os date in the following formate
--- yyyy-mm-dd WEEKDAY 
--- @param directory string
function utils.create_today_entry(directory)
   utils.open_entry(directory .. os.date("%Y-%m-%d") .. ' ' .. os.date("%A") .. ".md")
   vim.cmd("w!")
end


--- Iterates the Journal backwards to find the most recent log type
--- @param directory string
--- @param key_word string
function utils.get_most_recent_log_type(directory, key_word)
   local files = list_entries(directory)

   for i = 1, #files do
      local index = #files + 1 - i
      local file = io.open(directory .. files[index], "r")

      if file then
         for line in file:lines() do
            local match = string.find(line, key_word)

            if match then
               file:close()
               utils.open_entry(directory .. files[index])
               return
            end
         end
      end
   end

    print("NOT FOUND")
end

return utils
