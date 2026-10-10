# Purpose
A NeoVim plugin to help journalling. This plugin aims to mimic Daily Notes from   
obsidian. https://help.obsidian.md/Plugins/Daily+notes.  


# Install 
add `use 'Nate96/journal.nvim'` to packer.lua  
add desired shortcuts to `after/plugin/journal.lua`  

Requires NeoVim 0.10+.

## Journal location
The journal dir is found by walking up from the current buffer's dir (or cwd). At each parent
it checks `<dir>/Journal`, then `<dir>/Vault/Journal`; the first hit wins. If none is found,
`:Today` offers to create `Journal/` in the current working directory.

Only files named `YYYY-MM-DD*.md` count as entries. Panning keeps the alternate file
(`<C-^>` returns to where you were) and wipes the previous unmodified entry buffer.

## Example of journal.lua
```  
local J = require("journal")

vim.keymap.set('n', "<leader>k", function () J.jump_to_today() end)  
vim.keymap.set('n', "<leader>l", function() J.jump_forward() end)  
vim.keymap.set('n', "<leader>j", function() J.jump_backward() end)  
vim.api.nvim_create_user_command("CleanJournal", function() J.clean_journal() end, {})  
```  
