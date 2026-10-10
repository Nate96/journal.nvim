local utils = require("journal.utils")

local M = {}

-- Directions
local FORWARD  =  1
local BACKWARD = -1

--- Reads KEY=VALUE pairs from the plugin root's .env (git-ignored)
--- @return table
local function load_env()
   local env = {}
   local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")
   local f = io.open(root .. "/.env", "r")
   if not f then return env end
   for line in f:lines() do
      local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
      if key then env[key] = value:gsub('^["\'](.*)["\']$', "%1") end
   end
   f:close()
   return env
end

local config = {
   default_dir = load_env().JOURNAL_DEFAULT_DIR,
}

--- @param opts table|nil { default_dir = string }
function M.setup(opts)
   config = vim.tbl_extend("force", config, opts or {})
end

--- Walks up from the buffer's dir (fallback cwd) looking for Journal/ or Vault/Journal/
--- @return string journal directory with trailing slash
local function find_journal()
   local start = vim.fn.expand("%:p:h")
   if start == "" then start = vim.fn.getcwd() end
   for dir in vim.fs.parents(start .. "/x") do
      for _, p in ipairs({ dir .. "/Journal", dir .. "/Vault/Journal" }) do
         if vim.fn.isdirectory(p) == 1 then return p .. "/" end
      end
   end
   if config.default_dir and config.default_dir ~= "" then
      return (vim.fn.expand(config.default_dir):gsub("/*$", "/"))
   end
   return vim.fn.getcwd() .. "/Journal/"
end

--- Jumpes to the previous entry
function M.jump_backward()
   local journal = find_journal()
   utils.jump(journal, BACKWARD)
end

--- Jumpes to the next entry
function M.jump_forward()
   local journal = find_journal()
   utils.jump(journal,FORWARD)
end

--- Jumpes to the entry with the current os date
function M.jump_to_today()
   local directory = find_journal()
   local stat = vim.loop.fs_stat(directory)
   local PROMPT_1 = "Journal/ does not exsist, do you want to create Journal/? y/n: "

   if stat and stat.type == "directory" then
      utils.create_today_entry(directory)
   elseif vim.fn.input(PROMPT_1) == 'y' then
      vim.fn.mkdir(directory, "p")
      utils.create_today_entry(directory)
   end
end

--- Deletes all empty entries
function M.clean_journal()
   local directory = find_journal()
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
      print(directory, " does not exsist")
   end
end

--- Opens the most recent Entry with the log type 
function M.jump_to_log_type()
   local PROMPT_1 = "Enter Log Type: "
   local WEEK = "week"
   local MONTH = "month"

   local directory = find_journal()
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
