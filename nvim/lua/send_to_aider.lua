-- Send_to_aider
-- =============
local M = {}

-- Define patterns to match for aider panes
M.AIDER_PATTERNS = {"aid", "aider"}

-- Generic function to send aider commands
function M.send_aider_command(command)
    -- Check TMUX environment
    if vim.env.TMUX == nil then
        error("Must run inside Tmux session.")
    end

    -- Get the current buffer's path relative to Git root
    local git_root = vim.fs.root(0, '.git')
    if not git_root then
        error("Couldn't determine root. Are you inside a Git repository?")
    end

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

    -- Find aider pane
    local list_panes_cmd = {
        "tmux", "list-panes", "-F",
        "#{pane_title} [#{session_name}:#{window_index}.#{pane_index}]"
    }
    local result = vim.system(list_panes_cmd, { text = true }):wait()

    if result.code ~= 0 then
        error(string.format("Failed to list tmux panes: %s", result.stderr))
    end

    local panes = vim.split(result.stdout, '\n', {trimempty = true})
    local pane_id

    for _, pane_line in ipairs(panes) do
        for _, pattern in ipairs(M.AIDER_PATTERNS) do
            if pane_line:match(pattern) then
                pane_id = pane_line:match("%[(.+)%]")
                if not pane_id then
                    error(string.format(
                        "Couldn't find full pane path in line %s",
                        pane_line
                    ))
                end
                break
            end
        end
        if pane_id then break end
    end

    if not pane_id then
        error(string.format(
            'Aider pane not found in current window. Available panes:\n%s',
            table.concat(panes)
        ))
    end

    -- Send command to pane
    local cmd = {"tmux", "send-keys", "-t", pane_id,
                string.format("/%s %s", command, relative_path), "C-m"}
    local send_result = vim.system(cmd, { text = true }):wait()

    if send_result.code ~= 0 then
        error(string.format(
            "Failed to send keys to tmux: %s",
            send_result.stderr
        ))
    end
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
