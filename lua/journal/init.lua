local utils = require("journal.utils")

local M = {}

-- Directions
local FORWARD  =  1
local BACKWARD = -1

local JOURNAL_DIR = "/Journal/"

--- Jumpes to the previous entry
function M.jump_backward()
   local journal = vim.fn.getcwd() .. JOURNAL_DIR
   utils.jump(journal, BACKWARD)
end

--- Jumpes to the next entry
function M.jump_forward()
   local journal = vim.fn.getcwd() .. JOURNAL_DIR
   utils.jump(journal,FORWARD)
end

--- Jumpes to the entry with the current os date
function M.jump_to_today()
   local directory = vim.fn.getcwd() .. JOURNAL_DIR
   local stat = vim.loop.fs_stat(directory)
   local PROMPT_1 = "Journal/ does not exsist, do you want to create Journal/? y/n: "

   if stat and stat.type == "directory" then
      utils.create_today_entry(directory)
   elseif vim.fn.input(PROMPT_1) == 'y' then
      os.execute("mkdir " .. directory)
      utils.create_today_entry(directory)
   end
end

--- Deletes all empty entries
function M.clean_journal()
   local directory = vim.fn.getcwd() .. JOURNAL_DIR
   local files = vim.fn.readdir(directory)

   if files ~= nil then
      for _, file in ipairs(files) do
         local f = io.open(directory .. file, "r")
         local file_size = -1

         if f ~= nil then
            file_size = f:seek("end")
            f:close()
         end

         if file_size == 0 then
            local SUCCESS_MESSAGE = "successly deleted " .. file
            local success, err = os.remove(directory .. file)

            if success then
               print(SUCCESS_MESSAGE)
            else
               print("Error:" , err)
            end

         elseif file_size == -1 then
            print("err")
         end
      end
   else
      print(JOURNAL_DIR, " does not exsist")
   end
end

--- Opens the most recent Entry with the log type 
function M.jump_to_log_type()
   local PROMPT_1 = "Enter Log Type: "
   local WEEK = "week"
   local MONTH = "month"

   local directory = vim.fn.getcwd() .. JOURNAL_DIR
   local type = vim.fn.input(PROMPT_1)

   if type == WEEK then
      utils.get_most_recent_log_type(directory, "# Weekly Log")
   elseif type == MONTH then
      utils.get_most_recent_log_type(directory, "# Monthly Log")
   else
      print("Wrong log type.")
   end
end

return M
