-- General configuration
-- =====================
nvim_init_file = vim.fn.expand("~/.config/nvim/init.lua")
vim.cmd.source("~/.config/nvim/init_base.lua")

-- Plug
-- ====
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
Plug("nvim-orgmode/orgmode")
-- Read .editorconfig
Plug("editorconfig/editorconfig-vim")
-- If this isn't enabled, indentation on the next line is wrong.
Plug("hynek/vim-python-pep8-indent", {['for'] = "python"})
Plug("ledger/vim-ledger", {["for"] = "ledger"})
-- Commenting these out -- add back if needed Justus 2023-11-15
-- TODO Still needed? Justus 2023-03-10
-- Plug("elzr/vim-json", {['for'] = "json"})
-- Plug("dag/vim-fish", {['for'] = "fish"})
-- Plug("tpope/vim-markdown", {['for'] = "markdown"})

-- Ascii stuff
-- -----------
Plug("jbyuki/venn.nvim")

-- Treesitter
-- ----------
Plug("nvim-treesitter/nvim-treesitter")
-- Works with treesitter
Plug("kylechui/nvim-surround")

-- Improve editor appearance
-- -------------------------
Plug("jeffkreeftmeijer/vim-numbertoggle")

-- Improve general editor behavior
-- -------------------------------
Plug("easymotion/vim-easymotion")

-- tmux interaction
-- ----------------
Plug("epeli/slimux")
Plug("christoomey/vim-tmux-navigator")

-- Search and file jump
-- --------------------
Plug("mileszs/ack.vim")
Plug("ibhagwan/fzf-lua", {branch= "main"})
Plug("rgroli/other.nvim")

-- Git
-- ---
Plug("tpope/vim-fugitive")

-- Autocomplete
-- ------------
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")

-- Snippets
-- --------
Plug("hrsh7th/vim-vsnip")
Plug("hrsh7th/vim-vsnip-integ")
Plug("hrsh7th/cmp-vsnip")

-- LSP Config
-- ----------
Plug("neovim/nvim-lspconfig")
Plug("hrsh7th/cmp-nvim-lsp")

vim.call('plug#end')

-- Slimux
-- ======
vim.keymap.set("n", "<leader>s", ":SlimuxREPLSendLine<CR>")
vim.keymap.set("v", "<leader>s", ":SlimuxREPLSendSelection<CR>")
-- TODO investigate if these two commands still work
-- vim.keymap.set("n", "<leader>a", ":SlimuxShellLast<CR>")
-- vim.keymap.set("n", "<leader>k", ":SlimuxSendKeysLast<CR>")

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
vim.keymap.set("n", "<c-P>", require('fzf-lua').files, { silent=true })
vim.keymap.set("n", "<c-T>", require('fzf-lua').buffers, { silent=true })

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
vim.keymap.set("n", "<leader>os", "<cmd>:OtherSplit<CR>")
-- TODO investigate if these three are still needed
-- vim.keymap.set("n", "<leader>oo", "<cmd>:Other<CR>")
-- vim.keymap.set("n", "<leader>ov", "<cmd>:OtherVSplit<CR>")
-- vim.keymap.set("n", "<leader>oc", "<cmd>:OtherClear<CR>")

-- Nvim-Cmp
-- ========
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
            {
                { name = 'buffer' },
                { name = 'vsnip' },
                { name = 'nvim_lsp' },
                { name = 'orgmode' },
            },
            {
                { name = 'buffer' },
            }
        ),
    }
)

-- Language Server Protocol
-- ========================
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

-- Treesitter configuration
-- ========================
-- Load in orgmode grammar
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        -- Required for spellcheck, some LaTex highlights and
        -- code block highlights that do not have ts grammar
        additional_vim_regex_highlighting = {
            "diff",
            "gitcommit",
            "svelte",
            "org",
        },
        -- disable = { "sh" },
    },
    indent = {
        enable = true,
    },
    ensure_installed = {
        "lua",
        "svelte",
        "typescript",
        "markdown",
        "org",
        "ledger",
    },
}
-- Folding
-- -------
-- Use treesitter to do our folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldclose = all
vim.opt.foldminlines = 150

-- fold autocommand
-- ----------------
-- Inspired by https://www.jmaguire.tech/posts/treesitter_folding/
local OpenFolds = vim.api.nvim_create_augroup("OpenFolds", { clear = true })
-- XXX Problem: this is executed even when calling :edit to reload it.
-- On a simple reload, we don't want to have this autocmd called
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
   pattern = "*",
   group = OpenFolds,
   command = "normal zR",
})

-- Nvim surround
-- =============
require("nvim-surround").setup()

-- venn.nvim
-- =========
-- enable or disable keymappings
function toggle_venn()
    if vim.b.venn_enabled then
        print("disabling venn mode")
        vim.b.venn_enabled = false
        vim.opt_local.virtualedit = ""
        vim.cmd.mapclear("<buffer>")
    else
        print("enabling venn mode")
        vim.b.venn_enabled = true
        vim.opt_local.virtualedit = "all"
        opts = { buffer = true }
        -- draw a line on HJKL keystokes
        -- TODO call VBox function directly here
        vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", opts)
        vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", opts)
        vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", opts)
        vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", opts)
        -- draw a box by pressing "f" with visual selection
        vim.keymap.set("v", "f", ":VBox<CR>", opts)

        set_line = require"venn".set_line
        set_arrow = require"venn".set_arrow
        set_line({ "s", "s" , " ", " " }, '|')
        set_line({ " ", "s" , " ", "s" }, '.')
        set_line({ "s", " " , " ", "s" }, '.')
        set_line({ " ", "s" , "s", " " }, '.')
        set_line({ "s", " " , "s", " " }, '.')
        set_line({ " ", "s" , "s", "s" }, '+')
        set_line({ "s", " " , "s", "s" }, '+')
        set_line({ "s", "s" , " ", "s" }, '+')
        set_line({ "s", "s" , "s", " " }, '+')
        set_line({ " ", " " , "s", "s" }, '-')
        set_arrow("up", '^')
        set_arrow("down", 'v')
        set_arrow("left", '<')
        set_arrow("right", '>')
    end
end
-- toggle keymappings for venn using <leader>v
vim.keymap.set('n', '<leader>venn', toggle_venn)

-- fugitive
-- ========
vim.keymap.set('n', '<leader>gap', ":Git add -p<CR>")
vim.keymap.set('n', '<leader>gm', ":Git commit<CR>")
vim.keymap.set('n', '<leader>gdd', ":Git diff<CR>")
vim.keymap.set('n', '<leader>gdc', ":Git diff --cached<CR>")

-- vim-vsnip
-- =========
vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippets/")
vim.cmd([[
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
]])
-- XXX This one didn't work well
-- vim.keymap.set(
--     "i", "<Tab>",
--     "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'",
--     -- This one doesn't work very well either ...
--     -- function()
--     --     if vim.fn["vsnip#available"](1) then
--     --         return "<Plug>(vsnip-export-or-jump)"
--     --     else
--     --         return "<Tab>"
--     --     end
--     -- end,
--     {expr=true}
-- )

-- Svelte
-- ======
vim.g.svelte_preprocessor_tags = {
    { name = "ts", tag = "script", as = "typescript" }
}
vim.g.svelte_preprocessors = { "ts", "typescript" }

-- ack.vim
-- =======
if vim.fn.executable("ag") then
    vim.g.ackprg = "ag --vimgrep"
end
-- Search for selected text
vim.keymap.set('v', '<leader>ack', ":<C-u>Ack! \"<C-R><C-W>\"<CR>")
vim.keymap.set('n', '<leader>ag', ":Ack ")
-- Search for the current file
vim.keymap.set('n', '<leader>af', ":Ack %:t<CR>")

-- EditorConfig
-- ============
-- Don't let EditorConfig mess with our configuration
vim.g.EditorConfig_preserve_formatoptions = 1

-- Clear registers
vim.api.nvim_create_user_command(
    'WipeReg',
    function()
        -- ascii '"' to 'z'
        for i=34,122 do
            char = string.char(i)
            cmd = string.format("silent! call setreg('%s', [])", char)
            vim.cmd(cmd)
        end
    end,
    { nargs = 0}
)

-- Orgmode.nvim
-- ============
require('orgmode').setup({
    org_startup_indented = false,
    org_adapt_indentation = false,
})

-- EasyMotion
-- ==========
-- Taking a hint from
-- https://github.com/easymotion/vim-easymotion#minimal-configuration-tutorial
-- accessed on 2023-11-15
-- Disable default mappings
vim.g.EasyMotion_do_mapping = 0
vim.g.EasyMotion_keys = 'qwertyuiasdfghjkzxcvbnm'

vim.keymap.set("n", "<Leader>w", "<Plug>(easymotion-bd-w)")
vim.keymap.set("n", "<Leader>e", "<Plug>(easymotion-bd-e)")

-- Turn on case-insensitive feature
vim.g.EasyMotion_smartcase = 1

-- JK motions: Line motions
vim.keymap.set("n", "<Leader>j", "<Plug>(easymotion-j)")
vim.keymap.set("n", "<Leader>k", "<Plug>(easymotion-k)")


-- vim-ledger
-- ==========
vim.g.ledger_accounts_cmd = "hledger accounts"
vim.g.ledger_is_hledger = true
