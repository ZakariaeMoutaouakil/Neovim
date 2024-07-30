-- Set the leader key
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
print("The current leader key is: " .. vim.g.mapleader)

-- Set Spell Checking
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Now load the lazy config module
require("config.lazy")

