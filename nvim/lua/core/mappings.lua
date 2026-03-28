-- n, v, i, t = mode names

local M = {}

M.TSTools = {
  plugin = true,
  n = {
    ["<leader>oi"] = {"<cmd> TSToolsOrganizeImports <CR>", "Organize imports"},
    ["<leader>am"] = {"<cmd> TSToolsAddMissingImports <CR>", "Add missing imports"},
    ["<leader>fe"] = {"<cmd> TSToolsFixAll <CR>", "Fix all fixable errors"}
  }
}

M.Harpoon = {
  plugin = true,
  n = {
    ["<leader>ha"] = { function() require("harpoon"):list():append() end, "Add file to harpoon" },
    ["<leader>hh"] = { function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, "Toggle harpoon menu" },
    ["<leader>h1"] = { function() require("harpoon"):list():select(1) end, "Go to harpoon file 1" },
    ["<leader>h2"] = { function() require("harpoon"):list():select(2) end, "Go to harpoon file 2" },
    ["<leader>h3"] = { function() require("harpoon"):list():select(3) end, "Go to harpoon file 3" },
    ["<leader>h4"] = { function() require("harpoon"):list():select(4) end, "Go to harpoon file 4" },
    ["<C-S-P>"] = { function() require("harpoon"):list():prev() end, "Previous harpoon file" },
    ["<C-S-N>"] = { function() require("harpoon"):list():next() end, "Next harpoon file" },
  }
}

M.Oil = {
  plugin = true,
  n = {
    ["-"] = { "<cmd>Oil<cr>", "Open parent directory" },
  }
}

M.Debug = {
  plugin = true,
  n = {
    ["<leader>db"] = { function() require("dap").toggle_breakpoint() end, "Toggle breakpoint" },
    ["<leader>dB"] = { function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Set conditional breakpoint" },
    ["<leader>dc"] = { function() require("dap").continue() end, "Continue" },
    ["<leader>dC"] = { function() require("dap").run_to_cursor() end, "Run to cursor" },
    ["<leader>di"] = { function() require("dap").step_into() end, "Step into" },
    ["<leader>do"] = { function() require("dap").step_out() end, "Step out" },
    ["<leader>dO"] = { function() require("dap").step_over() end, "Step over" },
    ["<leader>dr"] = { function() require("dap").repl.toggle() end, "Toggle REPL" },
    ["<leader>dt"] = { function() require("dap").terminate() end, "Terminate" },
    ["<leader>du"] = { function() require("dapui").toggle() end, "Toggle DAP UI" },
    ["<leader>de"] = { function() require("dapui").eval() end, "Evaluate expression" },
  },
  v = {
    ["<leader>de"] = { function() require("dapui").eval() end, "Evaluate expression" },
  }
}

M.Test = {
  plugin = true,
  n = {
    ["<leader>tn"] = { function() require("neotest").run.run() end, "Run nearest test" },
    ["<leader>tf"] = { function() require("neotest").run.run(vim.fn.expand("%")) end, "Run test file" },
    ["<leader>td"] = { function() require("neotest").run.run({strategy = "dap"}) end, "Debug nearest test" },
    ["<leader>ts"] = { function() require("neotest").summary.toggle() end, "Toggle test summary" },
    ["<leader>to"] = { function() require("neotest").output.open({ enter = true, auto_close = true }) end, "Show test output" },
    ["<leader>tO"] = { function() require("neotest").output_panel.toggle() end, "Toggle test output panel" },
    ["<leader>tS"] = { function() require("neotest").run.stop() end, "Stop test" },
  }
}

M.Git = {
  plugin = true,
  n = {
    ["<leader>gd"] = { "<cmd>DiffviewOpen<cr>", "Open diffview" },
    ["<leader>gh"] = { "<cmd>DiffviewFileHistory<cr>", "Open file history" },
  }
}

M.Productivity = {
  plugin = true,
  n = {
    ["<leader>ut"] = { "<cmd>UndotreeToggle<cr>", "Toggle undotree" },
    ["<leader>rn"] = { function() return ":IncRename " .. vim.fn.expand("<cword>") end, "Incremental rename", opts = { expr = true } },
  }
}

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "Beginning of line" },
    ["<C-e>"] = { "<End>", "End of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  },

  n = {
    ["<Esc>"] = { ":noh <CR>", "Clear highlights" },

    -- auto indent everything
    ["<leader>in"] = { "mzgg=G`z", "Auto indent" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "Window left" },
    ["<C-l>"] = { "<C-w>l", "Window right" },
    ["<C-j>"] = { "<C-w>j", "Window down" },
    ["<C-k>"] = { "<C-w>k", "Window up" },

    -- section headings
    ["<leader>is"] = {
      function()
        vim.api.nvim_input("h")
        vim.api.nvim_put({"//=========  =========//"}, "", true, true)
        vim.api.nvim_input("bhi")
      end,
      "Insert section heading (comment)"
    },

    -- inline comment
    ["<leader>ic"] = {
      function()
        vim.api.nvim_put({"/*  */"}, "", true, true)
        vim.api.nvim_input("bhi")
      end,
      "Insert inline comment"
    },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

    -- toggle wrap
    ["<leader>tw"] = { "<cmd> set wrap! <CR>", "Toggle line wrap" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },

    -- move up and down
    ["<C-d>"] = { "<C-d>zz", "Move down half a screen" },
    ["<C-u>"] = { "<C-u>zz", "Move up half a screen" },

    -- newline enter
    ["<leader>s<CR>"] = {[[o<Esc>o<Esc>ko]], "Create three new lines and insert in the middle"},
    ["<leader>s<S-CR>"] = {[[O<Esc>O<Esc>jO]], "Create three new lines above and insert in the middle"},
    ["<leader><CR>"] = {[[o<Esc>]], "Create a new line below"},
    ["<leader>S-CR>"] = {[[O<Esc>]], "Create a new line above"},


    -- delete
    ["<leader>d"] = { '"_d', "Delete without yanking" },

    -- change
    ["c"] = { '"_c', "Change without yanking" },
    ["<leader>c"] = { 'c', "Change with yanking" },

    -- next and previous search results
    ["n"] = {"nzzzv", "Next search result"},
    ["N"] = {"Nzzzv", "Previous search result"},

    -- open trouble
    -- ["<leader>tt"] = { "<cmd> TroubleToggle 1 <CR>", "Open trouble" },

    -- buffers
    ["<leader>b"] = { "<cmd> enew <CR>", "New buffer" },
    ["<leader>lb"] = {"<cmd> e #<CR>", "Last buffer"},
    ["<leader>vs"] = {"<cmd> vsplit | bnext <CR>", "Vertical split with next buffer"},
    ["<leader>hs"] = {"<cmd> split | bnext <CR>", "Horizontal split with next buffer"},

    ["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },

    -- find/replace
    ["<leader>r"] = {":%s/\\<<C-r><C-w>\\>//g<left><left>", "Replace word under cursor"},
    ["<leader>fr"] = {":%s//g<left><left>", "Find and replace"},

    -- quickfix
    ["<leader>q"] = { "<cmd> copen <CR>", "Quickfix" },
    ["<leader>Q"] = { "<cmd> cclose <CR>", "Close quickfix" },

    -- copy
    ["<leader>y"] = { [["+y]], "Copy to clipboard" },

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },

    -- end/start of line with shift + l or h
    ["<S-l>"] = { "$", "End of line" },
    ["<S-h>"] = { "^", "Start of line" },
  },

  t = {
    ["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
  },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["J"] = { ":m '>+1<CR>gv=gv", "Move line down" },
    ["K"] = { ":m '<-2<CR>gv=gv", "Move line up" },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<tab>"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },

    ["<S-tab>"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },

    -- close buffer + hide terminal buffer
    ["<leader>x"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["<leader>l"] = {
      function()
        require("lsp_lines").toggle()
      end,
      "Toggle lsp_lines"
    },
    ["gD"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },

    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "LSP definition",
    },

    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },

    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },

    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "LSP signature help",
    },

    ["<leader>D"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "LSP definition type",
    },

    ["<leader>ra"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },

    ["gr"] = {
      function()
        vim.lsp.buf.references()
      end,
      "LSP references",
    },

    ["<leader>f"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
      end,
      "Goto prev",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "Goto next",
    },

    ["<leader>q"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "Diagnostic setloclist",
    },

    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "Add workspace folder",
    },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "Remove workspace folder",
    },

    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List workspace folders",
    },

  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

    -- focus
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files hidden=true <CR>", "Find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
    ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },
    ["<leader>ft"] = { "<cmd> TodoTelescope <CR>", "Find Todo Comment"},

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "Git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

    ["<leader>ma"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
  },
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    },

    -- new
    ["<leader>h"] = {
      function()
        require("nvterm.terminal").new "horizontal"
      end,
      "New horizontal term",
    },

    ["<leader>v"] = {
      function()
        require("nvterm.terminal").new "vertical"
      end,
      "New vertical term",
    },
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>wK"] = {
      function()
        vim.cmd "WhichKey"
      end,
      "Which-key all keymaps",
    },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input "WhichKey: "
        vim.cmd("WhichKey " .. input)
      end,
      "Which-key query lookup",
    },
  },
}

M.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd [[normal! _]]
        end
      end,

      "Jump to current context",
    },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>rh"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>ph"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },

    ["<leader>td"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },
}

return M
