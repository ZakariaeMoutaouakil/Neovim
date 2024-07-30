-- Set the leader key
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
print("The current leader key is: " .. vim.g.mapleader)

-- Set Spell Checking
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Function to toggle between English and French spell checking
local function toggle_spell_lang()
    if vim.opt.spelllang:get()[1] == "en_us" then
        vim.opt.spelllang = "fr"
        print("Spell check set to French")
    else
        vim.opt.spelllang = "en_us"
        print("Spell check set to English (US)")
    end
end

-- Key mapping to toggle spell check language
vim.keymap.set('n', '<F7>', toggle_spell_lang, { noremap = true, silent = true })

-- Now load the lazy config module
require("config.lazy")

