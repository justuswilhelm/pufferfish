-- SPDX-FileCopyrightText: 2015-2025 Justus Perlwitz
--
-- SPDX-License-Identifier: GPL-3.0-or-later
-- Send_to_aider
-- =============
local M = {}

function print_error(text) vim.notify(text, vim.log.levels.ERROR) end

-- Check if path is a file
function validate_path(path)
    local stat = vim.uv.fs_stat(path)
    if not stat then
        print_error(string.format("Path '%s' does not exist.", path))
        return false
    end
    if stat.type ~= "file" then
        print_error(string.format(
                        "Can't add path '%s' because it's not a file.", path))
        return false
    end
    return true
end

-- Get the current buffer's path relative to project root
function M.get_relative_path()
    -- Either get root directory based on .git
    local cwd = vim.fs.root(0, '.git')
    if not cwd then
        -- Or get the current working directory
        cwd = vim.fn.getcwd()
    end

    -- Absolute path of current buffer
    local current_buffer_abs = vim.fs.abspath(vim.api.nvim_buf_get_name(0))
    -- Path to current buffer relative to working directory
    local current_buffer_rel = vim.fs.relpath(cwd, current_buffer_abs)

    return current_buffer_rel
end

-- Generic function to send text to aider
-- Validates that there's exactly one aider pane in the current tmux
-- sessin
function M.send_aider_command(text)
    -- Check TMUX environment
    if vim.env.TMUX == nil then
        print_error("Must run inside Tmux session.")
        return
    end

    -- Find aider pane in current session
    -- Sample output:
    -- # tmux list-panes -s -F "#{pane_title} [#{session_name}:#{window_index}.#{pane_index}]"
    -- [lithium] nvim ~/.dotfiles [dotfiles:0.0]
    -- [lithium] tmux list-panes -s - ~/.dotfiles [dotfiles:0.1]
    -- [lithium] aider ~/.dotfiles [dotfiles:0.2]
    local list_panes_cmd = {
        "tmux", "list-panes", "-s", "-F",
        "#{pane_title} [#{session_name}:#{window_index}.#{pane_index}]"
    }
    local result = vim.system(list_panes_cmd, {text = true}):wait()

    if result.code ~= 0 then
        print_error(
            string.format("Failed to list tmux panes: %s", result.stderr))
        return
    end

    local panes = vim.split(result.stdout, '\n', {trimempty = true})
    local pane_id

    local matches = {}
    for _, pane_line in ipairs(panes) do
        if pane_line:match("aider") then
            pane_id = pane_line:match("%[([^[]+:.+%..+)%]$")
            if not pane_id then
                print_error(string.format(
                                "Couldn't find full pane path in line %s",
                                pane_line))
                return
            end
            table.insert(matches, pane_id)
        end
    end

    if table.getn(matches) == 0 then
        print_error(string.format(
                        'Aider pane not found in current tmux session. Available panes:\n%s',
                        table.concat(panes)))
        return
    elseif table.getn(matches) > 1 then
        print_error(string.format(
                        'Several aider panes found in current tmux session. Available panes:\n%s',
                        table.concat(panes)))
        return
    end

    -- Generate a random-ish buffer name
    local buffer_name = string.format("send-to-aider-%06d",
                                      math.random(100000, 999999))

    -- Load text into tmux buffer via stdin
    local load_cmd = {"tmux", "load-buffer", "-b", buffer_name, "-"}
    local load_result = vim.system(load_cmd, {text = true, stdin = text}):wait()

    if load_result.code ~= 0 then
        print_error(string.format("Failed to load buffer to tmux: %s",
                                  load_result.stderr))
        return
    end

    -- Paste buffer into target pane
    local paste_cmd = {
        "tmux", "paste-buffer", "-dpr", "-b", buffer_name, "-t", pane_id
    }
    local paste_result = vim.system(paste_cmd, {text = true}):wait()

    if paste_result.code ~= 0 then
        print_error(string.format("Failed to paste buffer to tmux: %s",
                                  paste_result.stderr))
        return
    end

    -- Send Enter key
    local enter_cmd = {"tmux", "send-keys", "-t", pane_id, "C-m"}
    local enter_result = vim.system(enter_cmd, {text = true}):wait()

    if enter_result.code ~= 0 then
        print_error(string.format("Failed to send enter key to tmux: %s",
                                  enter_result.stderr))
        return
    end
end

-- add current buffer path to aider
function M.add_to_aider()
    local relative_path = M.get_relative_path()
    if not validate_path(relative_path) then return end
    M.send_aider_command(string.format("/add %s", relative_path))
end

-- add current buffer path to aider, read-only
function M.add_to_aider_read_only()
    local relative_path = M.get_relative_path()
    if not validate_path(relative_path) then return end
    M.send_aider_command(string.format("/read-only %s", relative_path))
end

-- drop current buffer path from aider
function M.drop_from_aider()
    local relative_path = M.get_relative_path()
    M.send_aider_command(string.format("/drop %s", relative_path))
end

-- get current visual selection
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
        return nil
    end
end

-- Send current visual selection to aider
function M.send_selection_to_aider()
    -- Maybe do this:
    -- M.add_to_aider()
    local text = get_visual_selection()
    if not text then
        print_error("No selection found", vim.log.levels.ERROR)
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
