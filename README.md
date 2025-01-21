# Purpose
A NeoVim plugin to help journalling.  


# Install 
add `use 'Nate96/journal.nvim'` to packer.lua  
add desired shortcuts to `after/plugin/journal.lua`  

## Example of journal.lua
'''lua   
local J = require("journal")

vim.keymap.set('n', '<leader>k', function () J.jump_to_today() end)  
vim.keymap.set('n', '<leader>l', function() J.jump_forward() end)  
vim.keymap.set('n', '<leader>j', function() J.jump_backward() end)  
vim.api.nvim_create_user_command("CleanJournal", function() J.clean_journal() end, {})  
'''  
