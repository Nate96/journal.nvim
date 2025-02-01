local utils = {}

local ENTRY_DATE_FORMAT = "(%d%d%d%d%-%d%d%-%d%d)"
local ENTRY_NOT_FOUND = -1

-- Directions
local FORWARD  =  1
local BACKWARD = -1

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

   local files = vim.fn.readdir(journal_path)
   local current_entry_index = get_current_entry_index(files)

   if current_entry_index == ENTRY_NOT_FOUND then
      print(PROMPT_1)
   elseif current_entry_index == 1 and direction == BACKWARD then
      print(PROMPT_2)
   elseif current_entry_index == #files and direction == FORWARD then
      print(PROMPT_3)
   else
      vim.api.nvim_command("edit " .. journal_path .. files[current_entry_index + direction])
   end
end

--- Creates an markdwon file with the current os date in the following formate
--- yyyy-mm-dd WEEKDAY 
--- @param directory string
function utils.create_today_entry(directory)
   local nvim = vim.api.nvim_command
   nvim("edit " .. directory .. os.date("%Y-%m-%d") .. ' ' .. os.date("%A") .. ".md")
   nvim("w!")
end

return utils
