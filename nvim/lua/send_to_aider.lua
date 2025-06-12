-- Send_to_aider
-- =============
local M = {}

-- Define patterns to match for aider panes
M.AIDER_PATTERNS = {"aid", "aider"}

-- Send keys to a tmux pane
-- text is an array of keys to send, either a string or a special
-- shortcut like C-m
local function send_to_tmux_pane(pane, text)
    local cmd = {"tmux", "send-keys", "-t", pane}

    for _, item in ipairs(text) do
        table.insert(cmd, item)
    end

    local result = vim.system(cmd, { text = true }):wait()

    if result.code ~= 0 then
        error(string.format("Failed to send keys to tmux: %s", result.stderr))
    end
end

-- Find aider pane in the current tmux window
local function find_aider_pane()
    -- Get list of pane command and paths
    -- Example:
    -- 0: nvim README.md ~/.dotfiles [dotfiles:0.0]
    -- 1: aid nvim/lua/send_to ~/.dotfiles [dotfiles:0.1]
    -- 2: tmux list-panes -F " ~/.dotfiles [dotfiles:0.2]
    local list_panes_cmd = {
        "tmux", "list-panes", "-F",
        "#{pane_title} [#{session_name}:#{window_index}.#{pane_index}]"
    }
    local result = vim.system(list_panes_cmd, { text = true }):wait()

    if result.code ~= 0 then
        error(string.format("Failed to list tmux panes: %s", result.stderr))
    end

    local panes = vim.split(result.stdout, '\n', {trimempty = true})

    -- Look for aider pane in the list
    for _, pane_line in ipairs(panes) do
        for _, pattern in ipairs(M.AIDER_PATTERNS) do
            if pane_line:match(pattern) then
                local full_path = pane_line:match("%[(.+)%]")
                if not full_path then
                    error(string.format("Couldn't find full pane path in line %s", pane_line))
                end
                return full_path
            end
        end
    end

    local err_msg = string.format(
        'Aider pane not found in current window. Available panes:\n%s',
        table.concat(panes)
    )
    error(err_msg)
end

-- Check TMUX environment variable to check whether we are in tmux or not
local function check_inside_tmux()
    if vim.env.TMUX == nil then
        error("Must run inside Tmux session.")
    end
end

-- Get the current buffer's path relative to Git root
local function get_relative_buffer_path()
    -- Get the root of where we are based on the `.git` directory
    local git_root = vim.fs.root(0, '.git')
    if not git_root then
        error("Couldn't determine root. Are you inside a Git repository?")
    end

    -- Get path of the current buffer relative to the .git marker
    -- because aider uses the .git marker as the path reference
    local current_buffer = vim.api.nvim_buf_get_name(0)
    if not current_buffer then
        error("Couldn't determine current buffer path")
    end
    local current_buffer_abs = vim.fs.abspath(current_buffer)
    if not current_buffer_abs then
        error(string.format(
            "Couldn't determine absolute path of current buffer %s",
            current_buffer
        ))
    end
    local relative_path = vim.fs.relpath(git_root, current_buffer_abs)
    if not relative_path then
        error(string.format(
            "Couldn't retrieve path of %s relative to %s",
            current_buffer_abs,
            git_root
        ))
    end

    return relative_path
end

-- Generic function to send aider commands
function M.send_aider_command(command)
    check_inside_tmux()
    local relative_path = get_relative_buffer_path()
    send_to_tmux_pane(
        find_aider_pane(),
        {string.format("/%s %s", command, relative_path), "C-m"}
    )
end

-- Function to add current buffer path to aider
function M.add_to_aider()
    M.send_aider_command("add")
end

-- Function to add current buffer path to aider, read-only
function M.add_to_aider_read_only()
    M.send_aider_command("read-only")
end

-- Function to drop current buffer path from aider
function M.drop_from_aider()
    M.send_aider_command("drop")
end

function M.setup()
    vim.keymap.set('n', '<Leader>aba', M.add_to_aider, {
        desc = "Add current buffer to aider"
    })
    vim.keymap.set('n', '<Leader>abr', M.add_to_aider_read_only, {
        desc = "Add current buffer to aider as read-only"
    })
    vim.keymap.set('n', '<Leader>abd', M.drop_from_aider, {
        desc = "Drop current buffer from aider"
    })
end

return M
