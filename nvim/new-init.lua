-- fzf-lua
-- =======
-- This replaces nvim-tree and ctrlp for me
require("fzf-lua").setup({
    winopts = {
        preview = {
            flip_columns = 200,
        },
    },
})
vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent=true })

-- Other
-- =====
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
-- ------------
vim.api.nvim_set_keymap("n", "<leader>oo", "<cmd>:Other<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>os", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ov", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>oc", "<cmd>:OtherClear<CR>", { noremap = true, silent = true })

-- Nvim-Cmp
-- ========
local cmp = require'cmp'

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.disable,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources(
        { { name = 'nvim_lsp' } },
        { { name = 'buffer' } }
    ),
})

-- Language Server Protocol
-- ========================
-- Capabilities added as per nvim-cmp README
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.tsserver.setup {
    capabilities = capabilities
}
lspconfig.svelte.setup {
    capabilities = capabilities
}
lspconfig.pyright.setup {
    capabilities = capabilities
}

-- Key mappings
-- ------------
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

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
    vim.keymap.set('n', 'gD', function() vim.cmd("split") vim.lsp.buf.declaration() end, opts)
    vim.keymap.set('n', 'gd', function() vim.cmd("split") vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, opts)
  end,
})

-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        -- Required for spellcheck, some LaTex highlights and
        -- code block highlights that do not have ts grammar
        additional_vim_regex_highlighting = {'diff', 'org'},
        disable = { "diff" },
    },
    ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
})

require("nvim-surround").setup()
