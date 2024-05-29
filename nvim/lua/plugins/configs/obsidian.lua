local options = {
completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,

    -- Trigger completion at 2 chars.
    min_chars = 2,

    -- Where to put new notes created from completion. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "current_dir",


    -- Control how wiki links are completed with these (mutually exclusive) options:
    --
    -- 1. Whether to add the note ID during completion.
    -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
    -- Mutually exclusive with 'prepend_note_path' and 'use_path_only'.
    prepend_note_id = true,
    -- 2. Whether to add the note path during completion.
    -- E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
    -- Mutually exclusive with 'prepend_note_id' and 'use_path_only'.
    prepend_note_path = false,
    -- 3. Whether to only use paths during completion.
    -- E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
    -- Mutually exclusive with 'prepend_note_id' and 'prepend_note_path'.
    use_path_only = false,
  },
  workspaces = {
    {
      name = "personal",
      path = "~/vaults/personal",
    },
    {
      name = "dnd",
      path = "~/vaults/dnd",
    },
  },
  -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
  -- way then set 'mappings = {}'.
  mappings = {
    -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- Toggle check-boxes.
    ["<leader>cb"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
    ["<leader>ot"] = {
      action = function()
        return vim.cmd("ObsidianToday")
      end,
      opts = {buffer = true},
    },
    -- use a template
    ["<leader>ou"] = {
      action = function()
        return vim.cmd("ObsidianTemplate")
      end,
      opts = {buffer = true},
    }
  },

  templates = {
    subdir = "templates",
    date_format = "%B %-d, %Y",
    time_format = "%H:%M",
    substitutions = {
      directory = function()
        -- Use `vim.fn.expand('%:p')` to get the full path of the current file.
        local fullPath = vim.fn.expand('%:p')
        -- Use Lua pattern matching to extract the directory part.
        -- This pattern essentially captures the name after the last slash `/`
        -- but before a potential file name or another slash, typically the parent directory name.
        local directoryName = fullPath:match(".*/(.*)/.*")
        return directoryName
      end
    }
  },
  daily_notes = {
    -- Optional, if you keep daily notes in a separate directory.
    folder = "dailies",
    alias_format = "%B %-d, %Y",
    date_format = "%Y-%m-%d",
    template = "daily template.md",
  },
}

return options
