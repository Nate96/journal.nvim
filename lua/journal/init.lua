-- Directions
local FORWARD  =  1
local BACKWARD = -1
local JOURNAL_DIR = "/Journal/"

local function jump(direction)
   local current_buffer = vim.api.nvim_buf_get_name(0):match("(%d%d%d%d%-%d%d%-%d%d)")

   if current_buffer == nil then
      print("current page name is not in the correct formate")
   else
      local directory = vim.fn.getcwd() .. JOURNAL_DIR
      local files = vim.fn.readdir(directory)

      for index, file in ipairs(files) do
         if file:match("(%d%d%d%d%-%d%d%-%d%d)") == current_buffer then
            if index == 1 and direction == BACKWARD then
               print("You are at the first entry cannot jump backwards")
               break
            elseif index == #files and direction == FORWARD then
               print("You are at the last entry cannot jump forward")
               break
            else
               vim.api.nvim_command("edit " .. directory .. files[index + direction])
               break
            end
         end
      end
   end
end

local function jump_to_today()
   local directory = vim.fn.getcwd() .. JOURNAL_DIR
   local stat = vim.loop.fs_stat(directory)

   if stat and stat.type == "directory" then
      local files = vim.fn.readdir(directory)

      if #files == 0 then
         -- create in buffer with FORMAT: yyyy-mm-dd WEEKDAY
         vim.api.nvim_command("edit " .. directory .. os.date("%Y-%m-%d") .. ' ' .. os.date("%A") .. ".md")
      else
         local last_file_name  = files[#files]:match("(%d%d%d%d%-%d%d%-%d%d)")
         local current_file_name = vim.api.nvim_buf_get_name(0):match("(%d%d%d%d%-%d%d%-%d%d)")

         if current_file_name == last_file_name or #files == 0 then
            -- create in buffer with FORMAT: yyyy-mm-dd WEEKDAY
            vim.api.nvim_command("edit " .. directory .. os.date("%Y-%m-%d") .. ' ' .. os.date("%A") .. ".md")
         else
            -- jump to last entry
            vim.api.nvim_command("edit " .. directory .. files[#files])
         end
      end
   else
      if vim.fn.input("Journal/ does not exsist, do you want to create Journal/? y/n: ") == 'y' then
         os.execute("mkdir " .. directory)

         -- create in buffer wiht FORMAT: yyyy-mm-dd WEEKDAY
         vim.api.nvim_command("edit " .. directory .. os.date("%Y-%m-%d") .. ' ' .. os.date("%A") .. ".md")
      end
   end
end

local function clean_journal()
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

vim.keymap.set('n', '<leader>k', function () jump_to_today() end)
vim.keymap.set('n', '<leader>l', function() jump(FORWARD) end)
vim.keymap.set('n', '<leader>j', function() jump(BACKWARD) end)
vim.api.nvim_create_user_command("CleanJournal", clean_journal, {})

