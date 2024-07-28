return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = {'string'},
        javascript = {'template_string'},
        java = false,
      },
      disable_filetype = { "TelescopePrompt" },
      fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey='Comment'
      },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')
      
      npairs.setup(opts)

      -- Add spaces between parentheses
      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        Rule(' ', ' ')
          :with_pair(function (opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1]..brackets[1][2],
              brackets[2][1]..brackets[2][2],
              brackets[3][1]..brackets[3][2],
            }, pair)
          end)
      }
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          Rule(bracket[1]..' ', ' '..bracket[2])
            :with_pair(function() return false end)
            :with_move(function(opts)
              return opts.prev_char:match('.%'..bracket[2]) ~= nil
            end)
            :use_key(bracket[2])
        }
      end

      -- LaTeX-specific rules
      npairs.add_rules({
        -- Add matching \] when typing \[
        Rule("\\[", "\\]", "tex"),
        Rule("\\(", "\\)", "tex"),

	-- Add matching $ when typing $, only if not followed or preceded by another $
	Rule("$", "$", "tex")
	  :with_pair(cond.not_before_regex("\\"))
	  :with_pair(cond.not_after_regex("\\"))
	  :with_pair(function(opts)
	    local before_last_char = opts.line:sub(opts.col - 2, opts.col - 2)
	    local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
	    if last_char == "$" and before_last_char ~= "$" then
	      -- Don't pair if we're between $$
	      return false
	    end
	    return true
	  end),

	-- Add matching $$ when typing $$, preventing overlapping with single $
	Rule("$$", "$$", "tex")
	  :with_pair(cond.not_before_regex("\\"))
	  :with_pair(cond.not_after_regex("\\"))
	  :with_pair(function(opts)
	    local last_two_chars = opts.line:sub(opts.col - 2, opts.col - 1)
	    return last_two_chars ~= "$$"
	  end)
      })

      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  }
}
