-- SPDX-FileCopyrightText: 2007-2015 Antoine Imbert <antoine.imbert+ackvim@gmail.com> and contributors
--
-- SPDX-License-Identifier: Vim

local M = {}

-- Module state
M.searching_filepaths = false
M.using_loclist = false

-- Check if dispatch is available and configured
local function check_dispatch()
  if vim.g.ack_use_dispatch == nil then
    vim.g.ack_use_dispatch = 0
  end

  if vim.g.ack_use_dispatch == 1 then
    if vim.fn.exists(':Dispatch') == 0 then
      warn('Dispatch not loaded! Falling back to g:ack_use_dispatch = 0.')
      vim.g.ack_use_dispatch = 0
    end
  end
end

-- Warning function
local function warn(msg)
  vim.api.nvim_echo({{'Ack: ' .. msg, 'WarningMsg'}}, true, {})
end

-- Initialize state for an :Ack* or :LAck* search
local function init(cmd)
  searching_filepaths = string.match(cmd, '-g$') and true or false
  using_loclist = string.match(cmd, '^l') and true or false

  if vim.g.ack_use_dispatch == 1 and using_loclist then
    warn('Dispatch does not support location lists! Proceeding with quickfix...')
    using_loclist = false
  end
end

-- Are we finding matching files, not lines? (the -g option -- :AckFile)
local function is_searching_filepaths()
  return searching_filepaths
end

-- Were we invoked with a :LAck command?
local function is_using_loclist()
  return using_loclist
end

-- Predicate for whether mappings are enabled for list type of current search.
local function is_using_list_mappings()
  if is_using_loclist() then
    return vim.g.ack_apply_lmappings
  else
    return vim.g.ack_apply_qmappings
  end
end

-- Get documentation locations
local function get_doc_locations()
  local dp = ''
  local rtp_paths = vim.split(vim.o.rtp, ',')

  for _, p in ipairs(rtp_paths) do
    local doc_path = p .. '/doc/'
    if vim.fn.isdirectory(doc_path) == 1 then
      dp = doc_path .. '*.txt ' .. dp
    end
  end

  return dp
end

-- Highlight search results
local function highlight(args)
  if vim.g.ackhighlight == 0 then
    return
  end

  -- Extract search pattern from args
  local pattern = vim.fn.matchstr(args, "\\v(-)\\@<!(\\<)\\@<=\\w+|['\"]\\zs.{-}\\ze['\"]")
  vim.fn.setreg('/', pattern)
  vim.cmd('let &hlsearch=1')
end

-- Quick help function
local function quick_help()
  local help_file = vim.fn.globpath(vim.o.rtp, 'doc/ack_quick_help.txt')
  vim.cmd('edit ' .. help_file)

  vim.cmd('silent normal! gg')
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'hide'
  vim.bo.buflisted = false
  vim.bo.modifiable = false
  vim.bo.swapfile = false
  vim.bo.filetype = 'help'
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.wrap = false
  vim.wo.foldmethod = 'diff'
  vim.wo.foldlevel = 20

  vim.keymap.set('n', '?', function()
    vim.cmd('q!')
    M.ShowResults()
  end, { buffer = true, silent = true })
end

-- Apply mappings to quickfix/location list
local function apply_mappings()
  if not is_using_list_mappings() or vim.bo.filetype ~= 'qf' then
    return
  end

  local wintype = is_using_loclist() and 'l' or 'c'
  local closemap = ':' .. wintype .. 'close<CR>'
  vim.g.ack_mappings.q = closemap

  vim.keymap.set('n', '?', quick_help, { buffer = true, silent = true })

  if vim.g.ack_autoclose == 1 then
    -- Map all ack_mappings to close after action
    for key, mapping in pairs(vim.g.ack_mappings) do
      vim.keymap.set('n', key, mapping .. closemap, { buffer = true, silent = true })
    end
    vim.keymap.set('n', '<CR>', '<CR>' .. closemap, { buffer = true, silent = true })
  else
    for key, mapping in pairs(vim.g.ack_mappings) do
      vim.keymap.set('n', key, mapping, { buffer = true, silent = true })
    end
  end

  if vim.g.ackpreview then
    vim.keymap.set('n', 'j', 'j<CR><C-W><C-P>', { buffer = true, silent = true })
    vim.keymap.set('n', 'k', 'k<CR><C-W><C-P>', { buffer = true, silent = true })
    vim.keymap.set('n', '<Down>', 'j', { buffer = true, silent = true })
    vim.keymap.set('n', '<Up>', 'k', { buffer = true, silent = true })
  end
end

-- Search with Dispatch
local function search_with_dispatch(grepprg, grepargs, grepformat)
  local makeprg_bak = vim.bo.makeprg
  local errorformat_bak = vim.bo.errorformat

  local final_grepprg = grepprg
  if is_searching_filepaths() then
    final_grepprg = grepprg .. ' -g'
  end

  vim.bo.makeprg = final_grepprg .. ' ' .. grepargs
  vim.bo.errorformat = grepformat

  vim.cmd('Make')

  -- Restore settings
  vim.bo.makeprg = makeprg_bak
  vim.bo.errorformat = errorformat_bak
end

-- Search with grep
local function search_with_grep(grepcmd, grepprg, grepargs, grepformat)
  local grepprg_bak = vim.bo.grepprg
  local grepformat_bak = vim.o.grepformat

  vim.bo.grepprg = grepprg
  vim.o.grepformat = grepformat

  vim.cmd('silent ' .. grepcmd .. ' ' .. grepargs)

  -- Restore settings
  vim.bo.grepprg = grepprg_bak
  vim.o.grepformat = grepformat_bak
end

-- Main Ack function
function M.Ack(cmd, args)
  check_dispatch()
  init(cmd)
  vim.cmd('redraw')

  -- Local values for search
  local grepprg = vim.g.ackprg
  local grepformat = '%f:%l:%c:%m,%f:%l:%m'  -- Include column number

  -- Strip options for filepath search
  if is_searching_filepaths() then
    grepprg = string.gsub(grepprg, '-H', '')
    grepprg = string.gsub(grepprg, '--column', '')
    grepformat = '%f'
  end

  -- Check for empty search
  if args == '' then
    if vim.g.ack_use_cword_for_empty_search == 0 then
      print('No regular expression found.')
      return
    end
  end

  -- Use word under cursor if no pattern provided
  local grepargs = args == '' and vim.fn.expand('<cword>') or args

  -- Bypass search if cursor is on blank string
  if grepargs == '' then
    print('No regular expression found.')
    return
  end

  -- Escape special characters
  local escaped_args = vim.fn.escape(grepargs, '|#%')

  print('Searching ...')

  if vim.g.ack_use_dispatch == 1 then
    search_with_dispatch(grepprg, escaped_args, grepformat)
  else
    search_with_grep(cmd, grepprg, escaped_args, grepformat)
  end

  M.ShowResults()
  highlight(grepargs)
end

-- Search from current search register
function M.AckFromSearch(cmd, args)
  local search = vim.fn.getreg('/')
  -- Translate vim regex to perl regex
  search = string.gsub(search, '\\<', '\\b')
  search = string.gsub(search, '\\>', '\\b')
  M.Ack(cmd, '"' .. search .. '" ' .. args)
end

-- Search help files
function M.AckHelp(cmd, args)
  local doc_args = args .. ' ' .. get_doc_locations()
  M.Ack(cmd, doc_args)
end

-- Search files in current tab
function M.AckWindow(cmd, args)
  local files = vim.fn.tabpagebuflist()

  -- Remove duplicates
  local unique_files = {}
  local seen = {}
  for _, bufnr in ipairs(files) do
    if not seen[bufnr] then
      table.insert(unique_files, bufnr)
      seen[bufnr] = true
    end
  end

  -- Get buffer names
  local filenames = {}
  for _, bufnr in ipairs(unique_files) do
    local name = vim.fn.bufname(bufnr)
    if name ~= '' then
      table.insert(filenames, vim.fn.shellescape(vim.fn.fnamemodify(name, ':p')))
    end
  end

  local file_args = args .. ' ' .. table.concat(filenames, ' ')
  M.Ack(cmd, file_args)
end

-- Show results in quickfix or location list
function M.ShowResults()
  local handler = is_using_loclist() and vim.g.ack_lhandler or vim.g.ack_qhandler
  vim.cmd(handler)
  apply_mappings()
  vim.cmd('redraw!')
end

function M.setup()
    if not vim.g.ack_default_options then
      vim.g.ack_default_options = " -s -H --nopager --nocolor --nogroup --column"
    end

    -- Location of the ack utility
    if not vim.g.ackprg then
      if vim.fn.executable('ack-grep') == 1 then
        vim.g.ackprg = "ack-grep"
      elseif vim.fn.executable('ack') == 1 then
        vim.g.ackprg = "ack"
      elseif vim.fn.executable('ag') == 1 then
          vim.g.ackprg = 'ag --vimgrep'
      else
        return
      end
      vim.g.ackprg = vim.g.ackprg .. vim.g.ack_default_options
    end

    if vim.g.ack_apply_qmappings == nil then
      vim.g.ack_apply_qmappings = vim.g.ack_qhandler == nil
    end

    if vim.g.ack_apply_lmappings == nil then
      vim.g.ack_apply_lmappings = vim.g.ack_lhandler == nil
    end

    local s_ack_mappings = {
      t = "<C-W><CR><C-W>T",
      T = "<C-W><CR><C-W>TgT<C-W>j",
      o = "<CR>",
      O = "<CR><C-W>p<C-W>c",
      go = "<CR><C-W>p",
      h = "<C-W><CR><C-W>K",
      H = "<C-W><CR><C-W>K<C-W>b",
      v = "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t",
      gv = "<C-W><CR><C-W>H<C-W>b<C-W>J"
    }

    if vim.g.ack_mappings then
      vim.g.ack_mappings = vim.tbl_extend("force", s_ack_mappings, vim.g.ack_mappings)
    else
      vim.g.ack_mappings = s_ack_mappings
    end

    if not vim.g.ack_qhandler then
      vim.g.ack_qhandler = "botright copen"
    end

    if not vim.g.ack_lhandler then
      vim.g.ack_lhandler = "botright lopen"
    end

    if vim.g.ackhighlight == nil then
      vim.g.ackhighlight = 0
    end

    if vim.g.ack_autoclose == nil then
      vim.g.ack_autoclose = 0
    end

    if vim.g.ack_autofold_results == nil then
      vim.g.ack_autofold_results = 0
    end

    if vim.g.ack_use_cword_for_empty_search == nil then
      vim.g.ack_use_cword_for_empty_search = 1
    end

    vim.api.nvim_create_user_command('Ack', function(opts)
      M.Ack('grep' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*', complete = 'file' })

    vim.api.nvim_create_user_command('AckAdd', function(opts)
      M.Ack('grepadd' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*', complete = 'file' })

    vim.api.nvim_create_user_command('AckFromSearch', function(opts)
      M.AckFromSearch('grep' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*', complete = 'file' })

    vim.api.nvim_create_user_command('LAck', function(opts)
      M.Ack('lgrep' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*', complete = 'file' })

    vim.api.nvim_create_user_command('LAckAdd', function(opts)
      M.Ack('lgrepadd' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*', complete = 'file' })

    vim.api.nvim_create_user_command('AckFile', function(opts)
      M.Ack('grep' .. (opts.bang and '!' or '') .. ' -g', opts.args)
    end, { bang = true, nargs = '*', complete = 'file' })

    vim.api.nvim_create_user_command('AckHelp', function(opts)
      M.AckHelp('grep' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*', complete = 'help' })

    vim.api.nvim_create_user_command('LAckHelp', function(opts)
      M.AckHelp('lgrep' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*', complete = 'help' })

    vim.api.nvim_create_user_command('AckWindow', function(opts)
      M.AckWindow('grep' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*' })

    vim.api.nvim_create_user_command('LAckWindow', function(opts)
      M.AckWindow('lgrep' .. (opts.bang and '!' or ''), opts.args)
    end, { bang = true, nargs = '*' })
end

return M
