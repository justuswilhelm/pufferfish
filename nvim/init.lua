vim.cmd.source("~/.config/nvim/init_base.lua")
-- Plugin Specific Settings
-- ========================
-- Load plugins
-- ------------
local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.config/nvim/plugged")

-- Language specific
-- -----------------
Plug("evanleck/vim-svelte", { branch = "main"})
Plug("guersam/vim-j", { ['for'] = "j"})
Plug("leafgarland/typescript-vim")
Plug("othree/html5.vim")
Plug("pangloss/vim-javascript")
-- TODO Still needed? Justus 2023-03-10
Plug("elzr/vim-json", {['for'] = "json"})
Plug("dag/vim-fish", {['for'] = "fish"})
Plug("hynek/vim-python-pep8-indent", {['for'] = "python"})
Plug("tpope/vim-markdown", {['for'] = "markdown"})

-- Ascii stuff
-- -----------
Plug("jbyuki/venn.nvim")

-- Treesitter
-- ----------
Plug("nvim-treesitter/nvim-treesitter")
-- Works with treesitter
Plug("kylechui/nvim-surround")

-- nvim-orgmode
-- ------------
Plug("nvim-orgmode/orgmode")

-- Improve editor appearance
-- -------------------------
Plug("airblade/vim-gitgutter")

-- Improve general editor behavior
-- -------------------------------
Plug("christoomey/vim-tmux-navigator")
Plug("ibhagwan/fzf-lua", {branch= "main"})
Plug("easymotion/vim-easymotion")
Plug("editorconfig/editorconfig-vim")
Plug("epeli/slimux")
Plug("hrsh7th/vim-vsnip")
Plug("hrsh7th/vim-vsnip-integ")
Plug("jeffkreeftmeijer/vim-numbertoggle")
Plug("nvim-tree/nvim-tree.lua")
Plug("rgroli/other.nvim")
Plug("mileszs/ack.vim")
Plug("tpope/vim-fugitive")

-- LSP Config
-- ----------
Plug("neovim/nvim-lspconfig")

-- Autocomplete
-- ------------
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/nvim-cmp")
-- For vsnip
Plug("hrsh7th/cmp-vsnip")

vim.call('plug#end')
-- Slimux
-- ------
vim.cmd([[
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
map <Leader>a :SlimuxShellLast<CR>
map <Leader>k :SlimuxSendKeysLast<CR>
]])

-- fzf-lua
-- -------
-- This replaces nvim-tree and ctrlp for me
require("fzf-lua").setup({
    winopts = {
        preview = {
            flip_columns = 200,
        },
    },
})
vim.keymap.set("n", "<c-P>", require('fzf-lua').files, { silent=true })
vim.keymap.set("n", "<c-T>", require('fzf-lua').buffers, { silent=true })

-- Other
-- -----
require("other-nvim").setup({
    rememberBuffers = false,
    mappings = {
        {
            pattern = "/Pipfile$",
            target = "/Pipfile.lock",
        },
        {
            pattern = "/Pipfile.lock$",
            target = "/Pipfile",
        },
        {
            -- src/routes/dashboard/workspace-board/[workspaceBoardUuid]/+page.ts
            pattern = "/src/routes/(.*)%+page.*$",
            target = {
                {
                    -- src/routes/dashboard/workspace-board/[workspaceBoardUuid]/+page.svelte
                    target = "/src/routes/%1+page.svelte",
                    context = "page",
                },
                {
                    -- src/routes/dashboard/workspace-board/[workspaceBoardUuid]/+page.ts
                    target = "/src/routes/%1+page.ts",
                    context = "page-data",
                },
            },
        },
        {
            -- src/routes/dashboard/workspace-board/[workspaceBoardUuid]/+layout.ts
            pattern = "/src/routes/(.*)%+layout.*$",
            target = {
                {
                    -- src/routes/dashboard/workspace-board/[workspaceBoardUuid]/+layout.svelte
                    target = "/src/routes/%1+layout.svelte",
                    context = "layout",
                },
                {
                    -- src/routes/dashboard/workspace-board/[workspaceBoardUuid]/+layout.ts
                    target = "/src/routes/%1+layout.ts",
                    context = "layout-data",
                },
            },
        },
        {
            pattern = "/src/lib/(.*).svelte$",
            target = "/src/stories/%1.stories.ts",
            context = "story",
        },
        {
            pattern = "/(.*)/views.py$",
            target = "/%1/test/test_views.py",
            context = "view tests",
        },
        {
            pattern = "/(.*)/test/test_views.py$",
            target = "/%1/views.py",
            context = "views",
        },
    },
    style = {
        -- How the plugin paints its window borders
        -- Allowed values are none, single, double, rounded, solid and shadow
        border = "solid",

        -- Column seperator for the window
        seperator = "|",

        -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
        width = 0.7,

        -- min height in rows.
        -- when more columns are needed this value is extended automatically
        minHeight = 2
    },
})
-- Key mappings
vim.api.nvim_set_keymap("n", "<leader>oo", "<cmd>:Other<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>os", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ov", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>oc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })

-- Nvim-Cmp
-- --------
local cmp = require'cmp'
cmp.setup.filetype(
    { "python", "svelte", "typescript" },
    {
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            end,
        },
        preselect = cmp.PreselectMode.None,
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.disable,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            -- ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources(
            { { name = 'buffer' }, { name = 'vsnip' }, { name = 'nvim_lsp' } },
            { { name = 'buffer' } }
        ),
    }
)

-- Language Server Protocol
-- ------------------------
-- Capabilities added as per nvim-cmp README
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.tsserver.setup {
    capabilities = capabilities,
    cmd = { 'npm', 'run', 'typescript-language-server', '--', '--stdio' },
}
lspconfig.svelte.setup {
    capabilities = capabilities,
    cmd = { 'npm', 'run', 'svelteserver', '--', '--stdio' },
}
lspconfig.pyright.setup {
    capabilities = capabilities
}
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', function() vim.cmd("split") vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, opts)

    -- Potential keymap graveyard Justus 2023-08-02
    vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gD', function() vim.cmd("split") vim.lsp.buf.declaration() end, opts)
  end,
})

-- Nvim orgmode
-- ------------
-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
-- ------------------------
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        -- Required for spellcheck, some LaTex highlights and
        -- code block highlights that do not have ts grammar
        additional_vim_regex_highlighting = {
            "diff",
            "gitcommit",
            "org",
            "svelte",
        },
        -- disable = { "diff" },
    },
    ensure_installed = {
        "lua",
        "org",
        "svelte",
        "typescript",
        "markdown",
    },
}

-- TODO is the following needed?
require('orgmode').setup({
})

-- Nvim surround
-- -------------
require("nvim-surround").setup()

-- venn.nvim
-- ---------
-- enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>venn', ":lua Toggle_venn()<CR>", { noremap = true})

-- fugitive
-- --------
vim.api.nvim_set_keymap('n', '<leader>gap', ":Git add -p<CR>", { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gm', ":Git commit<CR>", { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gdd', ":Git diff<CR>", { noremap = true})
vim.api.nvim_set_keymap('n', '<leader>gdc', ":Git diff --cached<CR>", { noremap = true})

-- vim-vsnip
-- ---------
vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippets/")
vim.keymap.set(
    "i", "<Tab>",
    "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'",
    -- TODO maybe switch to something like this:
    -- function()
    --     if vim.fn["vsnip#available"](1) then
    --         return "<Plug>(vsnip-export-or-jump)"
    --     else
    --         return "<Tab>"
    --     end
    -- end,
    {expr=true}
)

-- Svelte
-- ------
vim.g.svelte_preprocessor_tags = {
    { name = "ts", tag = "script", as = "typescript" }
}
vim.g.svelte_preprocessors = { "ts", "typescript" }

-- ack.vim
-- =======
if vim.fn.executable("ag") then
    vim.g.ackprg = "ag --vimgrep"
end
vim.api.nvim_set_keymap('v', '<leader>ack', ":<C-u>Ack! \"<C-R><C-W>\"<CR>", {})
vim.api.nvim_set_keymap('n', '<leader>ag', ":Ack ", {})

-- EditorConfig
-- ------------
-- Don't let EditorConfig mess with our configuration
vim.g.EditorConfig_preserve_formatoptions = 1
