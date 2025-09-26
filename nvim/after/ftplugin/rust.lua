-- https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#zap-quick-setup
vim.keymap.set(
  "n",
  "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({'hover', 'actions'})
  end,
  { silent = true, buffer = true }
)
