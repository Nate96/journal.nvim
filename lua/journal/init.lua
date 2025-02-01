local utils = require("utils")
local M = {}

-- Directions
local FORWARD  =  1
local BACKWARD = -1

local JOURNAL_DIR = "/Journal/"


function M.jump_backward()
   local journal = vim.fn.getcwd() .. JOURNAL_DIR
   utils.jump(journal, BACKWARD)
end

function M.jump_forward()
   local journal = vim.fn.getcwd() .. JOURNAL_DIR
   utils.jump(journal,FORWARD)
end

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

function M.clean_journal()
   local directory = vim.fn.getcwd() .. JOURNAL_DIR
   local files = vim.fn.readdir(directory)

   if files == nil then
      print("cannot perform action")
   else
      for _, file in ipairs(files) do
         local f = io.open(directory .. file, "r")
         local file_size = -1

         if f ~= nil then
            file_size = f:seek("end")
            f:close()
         end

         if file_size == 0 then
            print("deleting:", file)
            local success, err = os.remove(directory .. file)
            if success then
               print("success")
            else
               print("Error:" , err)
            end
         elseif file_size == -1 then
            print("err")
         end
      end
   end
end

return M
