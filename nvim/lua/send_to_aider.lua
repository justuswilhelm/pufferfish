-- SPDX-FileCopyrightText: 2015-2025 Justus Perlwitz
--
-- SPDX-License-Identifier: GPL-3.0-or-later
-- Send_to_aider
-- =============
local M = {}

-- Define patterns to match for aider panes
M.AIDER_PATTERNS = {"aid", "aider"}

-- Get the current buffer's path relative to the current working directory
function M.get_relative_path()
    -- This always returns a string
    local cwd = vim.fn.getcwd()

    -- This always returns a name
    local current_buffer = vim.api.nvim_buf_get_name(0)

    -- This always returns an absolute path
    local current_buffer_abs = vim.fs.abspath(current_buffer)

    -- This always returns a relative path
    local relative_path = vim.fs.relpath(cwd, current_buffer_abs)

    return relative_path
end

-- Generic function to send text to aider
function M.send_aider_command(text)
    -- Check TMUX environment
    if vim.env.TMUX == nil then
        vim.notify("Must run inside Tmux session.", vim.log.levels.ERROR)
        return
    end

    -- Find aider pane
    local list_panes_cmd = {
        "tmux", "list-panes", "-F",
        "#{pane_title} [#{session_name}:#{window_index}.#{pane_index}]"
    }
    local result = vim.system(list_panes_cmd, {text = true}):wait()

    if result.code ~= 0 then
        vim.notify(
            string.format("Failed to list tmux panes: %s", result.stderr),
            vim.log.levels.ERROR)
        return
    end

    local panes = vim.split(result.stdout, '\n', {trimempty = true})
    local pane_id

    for _, pane_line in ipairs(panes) do
        for _, pattern in ipairs(M.AIDER_PATTERNS) do
            if pane_line:match(pattern) then
                pane_id = pane_line:match("%[(.+)%]")
                if not pane_id then
                    vim.notify(string.format(
                                   "Couldn't find full pane path in line %s",
                                   pane_line), vim.log.levels.ERROR)
                    return
                end
                break
            end
        end
    end

    if not pane_id then
        vim.notify(string.format(
                       'Aider pane not found in current window. Available panes:\n%s',
                       table.concat(panes)), vim.log.levels.ERROR)
        return
    end

    -- Generate a random-ish buffer name
    local buffer_name = string.format("send-to-aider-%06d",
                                      math.random(100000, 999999))

    -- Load text into tmux buffer via stdin
    local load_cmd = {"tmux", "load-buffer", "-b", buffer_name, "-"}
    local load_result = vim.system(load_cmd, {text = true, stdin = text}):wait()

    if load_result.code ~= 0 then
        vim.notify(string.format("Failed to load buffer to tmux: %s",
                                 load_result.stderr), vim.log.levels.ERROR)
        return
    end

    -- Paste buffer into target pane
    local paste_cmd = {
        "tmux", "paste-buffer", "-dpr", "-b", buffer_name, "-t", pane_id
    }
    local paste_result = vim.system(paste_cmd, {text = true}):wait()

    if paste_result.code ~= 0 then
        vim.notify(string.format("Failed to paste buffer to tmux: %s",
                                 paste_result.stderr), vim.log.levels.ERROR)
        return
    end

    -- Send Enter key
    local enter_cmd = {"tmux", "send-keys", "-t", pane_id, "C-m"}
    local enter_result = vim.system(enter_cmd, {text = true}):wait()

    if enter_result.code ~= 0 then
        vim.notify(string.format("Failed to send enter key to tmux: %s",
                                 enter_result.stderr), vim.log.levels.ERROR)
        return
    end
end

-- Function to add current buffer path to aider
function M.add_to_aider()
    local relative_path = M.get_relative_path()
    M.send_aider_command(string.format("/add %s", relative_path))
end

-- Function to add current buffer path to aider, read-only
function M.add_to_aider_read_only()
    local relative_path = M.get_relative_path()
    M.send_aider_command(string.format("/read-only %s", relative_path))
end

-- Function to drop current buffer path from aider
function M.drop_from_aider()
    local relative_path = M.get_relative_path()
    M.send_aider_command(string.format("/drop %s", relative_path))
end

-- Function to get visual selection in pure Lua
local function get_visual_selection()
    -- https://github.com/nvim-telescope/telescope.nvim/issues/1923#issuecomment-2495851785
    local current_clipboard_content = vim.fn.getreg('"')

    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    vim.fn.setreg('"', current_clipboard_content)

    -- text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ''
    end
end

-- Function to send current visual selection to aider
function M.send_selection_to_aider()
    -- Maybe do this:
    -- M.add_to_aider()

    local text = get_visual_selection()

    if text == '' then
        vim.notify("No selection found", vim.log.levels.ERROR)
        return
    end

    M.send_aider_command(text)
end

function M.setup()
    vim.keymap.set('n', '<Leader>aba', M.add_to_aider,
                   {desc = "Add current buffer to aider"})
    vim.keymap.set('n', '<Leader>abr', M.add_to_aider_read_only,
                   {desc = "Add current buffer to aider as read-only"})
    vim.keymap.set('n', '<Leader>abd', M.drop_from_aider,
                   {desc = "Drop current buffer from aider"})
    vim.keymap.set('v', '<Leader>abs', M.send_selection_to_aider,
                   {desc = "Send current selection to aider"})
end

return M
