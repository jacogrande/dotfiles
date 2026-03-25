local options = {

  -- Where to put new notes created from completion. Valid options are
  --  * "current_dir" - put new notes in same directory as the current buffer.
  --  * "notes_subdir" - put new notes in the default notes subdirectory.
  new_notes_location = "current_dir",

  -- Better UI settings
  ui = {
    enable = true,  -- Enable UI features
    update_debounce = 200,  -- Update delay in ms
    -- Define how various check boxes are displayed
    checkboxes = {
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
      [">"] = { char = "", hl_group = "ObsidianRightArrow" },
      ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
    },
    -- Use bullet char for other list items
    bullets = { char = "•", hl_group = "ObsidianBullet" },
    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    reference_text = { hl_group = "ObsidianRefText" },
    highlight_text = { hl_group = "ObsidianHighlightText" },
    tags = { hl_group = "ObsidianTag" },
    hl_groups = {
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#89ddff" },
      ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
      ObsidianTilde = { bold = true, fg = "#ff5370" },
      ObsidianBullet = { bold = true, fg = "#89ddff" },
      ObsidianRefText = { underline = true, fg = "#c792ea" },
      ObsidianExtLinkIcon = { fg = "#c792ea" },
      ObsidianTag = { italic = true, fg = "#89ddff" },
      ObsidianHighlightText = { bg = "#75662e" },
    },
  },

  -- Use Telescope for pickers
  picker = {
    name = "telescope.nvim",
    mappings = {
      new = "<C-x>",  -- Create a new note from the picker
      insert_link = "<C-l>",  -- Insert a link to the selected note
    },
  },

  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,

    -- Trigger completion at 2 chars.
    min_chars = 2,

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

  -- Disable plugin's default mappings since we're using NvChad's mapping system
  mappings = {},

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

  note_id_func = function(title)
    -- Extract the path and file name from the title
    local path = ""
    local file_name = ""

    if title ~= nil then
      -- Split the title into path and file name
      local parts = vim.split(title, "/", { plain = true })
      if #parts > 1 then
        path = table.concat(vim.list_slice(parts, 1, #parts - 1), "/")
        file_name = parts[#parts]:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If no path is given, just use the title as the file name
        file_name = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      end
    else
      -- If title is nil, just create a random file name
      for _ = 1, 4 do
        file_name = file_name .. string.char(math.random(65, 90))
      end
    end

    -- Construct the note ID by combining the path, timestamp, and file name
    local note_id = tostring(os.time()) .. "-" .. (path ~= "" and path .. "-" or "") .. file_name
    return note_id
  end,

}
return options
