-- Custom markdown table renderer with cell-internal wrapping.
-- Uses nowrap + overlay to replace wide pipe tables with box-drawing
-- borders and word-wrapped cell content sized to the window width.
-- Requires nowrap so the overlay fully covers each source line.

local M = {}
local ns = vim.api.nvim_create_namespace("md-table-wrap")

local B = {
  top = { "╭", "┬", "╮" },
  mid = { "├", "┼", "┤" },
  bot = { "╰", "┴", "╯" },
  v = "│",
  h = "─",
  hh = "━",
}

--- Parse pipe-table buffer lines into structured data.
function M.parse_table(lines)
  local result = { headers = {}, alignments = {}, rows = {} }
  for i, line in ipairs(lines) do
    local inner = line:match("^%s*|(.+)|%s*$")
    if not inner then goto next end
    local cells = {}
    for cell in (inner .. "|"):gmatch("(.-)%|") do
      cells[#cells + 1] = vim.trim(cell)
    end
    if i == 1 then
      result.headers = cells
    elseif i == 2 then
      for _, cell in ipairs(cells) do
        if cell:match("^:.*:$") then
          result.alignments[#result.alignments + 1] = "center"
        elseif cell:match(":$") then
          result.alignments[#result.alignments + 1] = "right"
        else
          result.alignments[#result.alignments + 1] = "left"
        end
      end
    else
      result.rows[#result.rows + 1] = cells
    end
    ::next::
  end
  return result
end

--- Word-wrap text to fit within a display-width budget.
function M.wrap_text(text, width)
  if width <= 0 or vim.fn.strdisplaywidth(text) <= width then
    return { text }
  end
  local lines, cur = {}, ""
  for word in text:gmatch("%S+") do
    if cur == "" then
      cur = word
    elseif vim.fn.strdisplaywidth(cur .. " " .. word) <= width then
      cur = cur .. " " .. word
    else
      lines[#lines + 1] = cur
      cur = word
    end
  end
  if cur ~= "" then lines[#lines + 1] = cur end
  return #lines > 0 and lines or { text }
end

--- Pad / align text to an exact display width.
function M.align_text(text, width, alignment)
  local pad = width - vim.fn.strdisplaywidth(text)
  if pad <= 0 then return text end
  if alignment == "center" then
    local l = math.floor(pad / 2)
    return string.rep(" ", l) .. text .. string.rep(" ", pad - l)
  elseif alignment == "right" then
    return string.rep(" ", pad) .. text
  end
  return text .. string.rep(" ", pad)
end

--- Distribute available width across columns.
-- Narrow columns keep their natural width; wide columns share the rest.
function M.calc_widths(td, avail, nc)
  local overhead = (nc + 1) + (nc * 2) -- │ borders + 1-space padding each side
  local space = avail - overhead
  local min_w = 5

  -- Natural (max-content) width per column
  local nat = {}
  for i = 1, nc do
    nat[i] = vim.fn.strdisplaywidth(td.headers[i] or "")
    for _, row in ipairs(td.rows) do
      nat[i] = math.max(nat[i], vim.fn.strdisplaywidth(row[i] or ""))
    end
    nat[i] = math.max(nat[i], min_w)
  end

  local total = 0
  for _, w in ipairs(nat) do total = total + w end
  if total <= space then return nat end

  -- Lock narrow columns at natural width, distribute remainder
  local widths, locked, rem = {}, {}, space
  for _ = 1, nc do
    local ul = 0
    for i = 1, nc do
      if not locked[i] then ul = ul + 1 end
    end
    if ul == 0 then break end
    local avg, changed = rem / ul, false
    for i = 1, nc do
      if not locked[i] and nat[i] <= avg then
        widths[i] = nat[i]
        locked[i] = true
        rem = rem - nat[i]
        changed = true
      end
    end
    if not changed then break end
  end

  local ul_nat = 0
  for i = 1, nc do
    if not locked[i] then ul_nat = ul_nat + nat[i] end
  end
  for i = 1, nc do
    if not locked[i] then
      widths[i] = ul_nat > 0
          and math.max(math.floor(rem * nat[i] / ul_nat), min_w)
        or min_w
    end
  end
  return widths
end

---------------------------------------------------------------------------
-- Virtual-text builders (all pad to avail so overlay covers the full line)
---------------------------------------------------------------------------

local function make_border(cw, chars, horiz, avail)
  local p = { chars[1] }
  for i, w in ipairs(cw) do
    p[#p + 1] = string.rep(horiz, w + 2)
    p[#p + 1] = i < #cw and chars[2] or chars[3]
  end
  local text = table.concat(p)
  local pad = avail - vim.fn.strdisplaywidth(text)
  if pad > 0 then text = text .. string.rep(" ", pad) end
  return text
end

local function make_row(cells, cw, aligns, nc, avail)
  local p = { B.v }
  for i = 1, nc do
    p[#p + 1] = " " .. M.align_text(cells[i] or "", cw[i], aligns[i] or "left") .. " " .. B.v
  end
  local text = table.concat(p)
  local pad = avail - vim.fn.strdisplaywidth(text)
  if pad > 0 then text = text .. string.rep(" ", pad) end
  return text
end

--- Wrap one logical row into 1+ visual line chunk-lists.
local function wrap_row(cells, cw, aligns, hl, nc, avail)
  local wrapped, max_h = {}, 1
  for i = 1, nc do
    wrapped[i] = M.wrap_text(cells[i] or "", cw[i])
    if #wrapped[i] > max_h then max_h = #wrapped[i] end
  end
  local vis = {}
  for li = 1, max_h do
    local c = {}
    for i = 1, nc do c[i] = wrapped[i][li] or "" end
    vis[#vis + 1] = { { make_row(c, cw, aligns, nc, avail), hl } }
  end
  return vis
end

---------------------------------------------------------------------------
-- Core render
---------------------------------------------------------------------------

function M.render(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local win = vim.fn.bufwinid(bufnr)
  if win == -1 then return end
  local info = vim.fn.getwininfo(win)[1]
  local avail = vim.api.nvim_win_get_width(win) - (info and info.textoff or 0)

  local crow = nil
  local ok_c, pos = pcall(vim.api.nvim_win_get_cursor, win)
  if ok_c then crow = pos[1] - 1 end

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
  if not ok or not parser then return end
  local trees = parser:parse()
  if not trees or not trees[1] then return end

  local qok, query = pcall(vim.treesitter.query.parse, "markdown", "(pipe_table) @table")
  if not qok then return end

  local HHL = "RenderMarkdownTableHead"
  local RHL = "RenderMarkdownTableRow"

  for _, node in query:iter_captures(trees[1]:root(), bufnr) do
    local sr, _, er, _ = node:range()

    local blines = vim.api.nvim_buf_get_lines(bufnr, sr, er, false)
    local td = M.parse_table(blines)
    local nc = #td.headers
    if nc == 0 then goto next end
    local cw = M.calc_widths(td, avail, nc)

    -- Source line 0 (header): overlay top border, virt_lines header content
    if crow ~= sr then
      local hdr_vis = wrap_row(td.headers, cw, td.alignments, HHL, nc, avail)
      vim.api.nvim_buf_set_extmark(bufnr, ns, sr, 0, {
        virt_text = { { make_border(cw, B.top, B.h, avail), HHL } },
        virt_text_pos = "overlay",
        virt_lines = hdr_vis,
      })
    end

    -- Source line 1 (separator): overlay header separator
    if sr + 1 < er and crow ~= sr + 1 then
      local sep_vl = nil
      if #td.rows == 0 then
        sep_vl = { { { make_border(cw, B.bot, B.h, avail), RHL } } }
      end
      vim.api.nvim_buf_set_extmark(bufnr, ns, sr + 1, 0, {
        virt_text = { { make_border(cw, B.mid, B.hh, avail), HHL } },
        virt_text_pos = "overlay",
        virt_lines = sep_vl,
      })
    end

    -- Data rows
    for ri, row in ipairs(td.rows) do
      local src = sr + 1 + ri
      if src >= er then break end
      if crow ~= src then
        local vis = wrap_row(row, cw, td.alignments, RHL, nc, avail)
        local first = table.remove(vis, 1)
        local vl = #vis > 0 and vis or nil

        if ri == #td.rows then
          vl = vl or {}
          vl[#vl + 1] = { { make_border(cw, B.bot, B.h, avail), RHL } }
        end

        vim.api.nvim_buf_set_extmark(bufnr, ns, src, 0, {
          virt_text = first,
          virt_text_pos = "overlay",
          virt_lines = vl,
        })
      end
    end

    ::next::
  end
end

---------------------------------------------------------------------------
-- Re-render on cursor line change (row-level anti-conceal)
---------------------------------------------------------------------------

local last_crow = nil

function M.on_cursor_moved(bufnr)
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  if row == last_crow then return end
  last_crow = row
  M.render(bufnr)
end

---------------------------------------------------------------------------
-- Setup
---------------------------------------------------------------------------

function M.setup()
  local grp = vim.api.nvim_create_augroup("MdTableWrap", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = grp,
    pattern = "markdown",
    callback = function(a)
      -- nowrap is required so the overlay covers the entire source line
      -- (with wrap, continuations leak below the overlay)
      vim.wo.wrap = false
      vim.o.sidescroll = 1
      vim.wo.sidescrolloff = 5

      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(a.buf) then M.render(a.buf) end
      end, 100)
    end,
  })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = grp,
    pattern = "*.md",
    callback = function(a)
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(a.buf) then M.render(a.buf) end
      end, 150)
    end,
  })

  vim.api.nvim_create_autocmd("WinResized", {
    group = grp,
    callback = function()
      for _, w in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(w)
        if vim.bo[buf].filetype == "markdown" then M.render(buf) end
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = grp,
    pattern = "*.md",
    callback = function(a) M.on_cursor_moved(a.buf) end,
  })

  -- Render current buffer if already markdown (FileType may have fired)
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype == "markdown" then
    vim.wo.wrap = false
    vim.o.sidescroll = 1
    vim.wo.sidescrolloff = 5
    vim.defer_fn(function() M.render(buf) end, 100)
  end
end

return M
