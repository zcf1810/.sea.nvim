local plugin = {}

plugin.core = {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
        "nvim-lspconfig",
        {
            "quangnguyen30192/cmp-nvim-ultisnips",
            enabled = vim.g.feature_groups.lsp == "builtin",
            -- 故意不调 setup{}：它的 setup 用的是旧版 vim.validate 位置参数签名，
            -- 在这个 nvim 上会报 `opt: expected table, got string`；
            -- README 说只有要改默认行为时才需要 setup，默认值（show_snippets=expandable）够用
        }, -- ultisnips source：让模板出现在补全菜单里（模板文件用 ;se 打开）
        {
            "hrsh7th/cmp-nvim-lsp",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        }, --builtin lsp source
        {
            "hrsh7th/cmp-buffer",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        }, --buffer source
        {
            "hrsh7th/cmp-path",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        }, --path source
        {
            "hrsh7th/cmp-cmdline",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        }, -- for commandline complation
        {
            "dmitmel/cmp-cmdline-history",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        }, -- for commandline complation
        {
            "hrsh7th/cmp-calc",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        }, --for calc
        {
            "hrsh7th/cmp-emoji",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        },
        {
            "rcarriga/cmp-dap",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        },
        {
            "hrsh7th/cmp-nvim-lsp-signature-help",
            enabled = vim.g.feature_groups.lsp == "builtin",
            event = "InsertEnter",
        },
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local kind_icons = {
            Copilot = "",
            Text = " ",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "",
            Variable = "",
            Class = "ﴯ",
            Interface = "",
            Module = "",
            Property = " ",
            Unit = "",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "",
            Event = "",
            Operator = "",
            TypeParameter = " ",
        }
        local cmp = require("cmp")
        local compare = cmp.config.compare
        vim.cmd([[
            highlight CompNormal guibg=None guifg=None

            highlight CompBorder guifg=#ffaa55 guibg=#None

            autocmd! ColorScheme * highlight CompBorder guifg=#ffaa55 guibg=None
            autocmd FileType AerojumpFilter lua require('cmp').setup.buffer { enabled = false }
        ]])
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
        -- 补全高亮：default=true 表示主题若已定义则不覆盖
        --   CmpGhostText          光标后"即将补上"的灰色虚影
        --   CmpItemAbbrMatch      候选里跟你输入匹配上的字符（一眼看出为何匹配）
        --   CmpItemAbbrMatchFuzzy 模糊匹配命中的字符
        --   CmpItemMenu           每行右边的来源标签（[LSP]/[Snip]/[Buf]…）
        local cmp_hl = {
            CmpGhostText = { link = "Comment" },
            CmpItemAbbrMatch = { link = "Special" },
            CmpItemAbbrMatchFuzzy = { link = "Special" },
            CmpItemMenu = { link = "Comment" },
        }
        for name, spec in pairs(cmp_hl) do
            vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", spec, { default = true }))
        end
        -- 换主题后主题可能重置这些组，重新套一遍
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                for name, spec in pairs(cmp_hl) do
                    vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", spec, { default = true }))
                end
            end,
        })
        --highlight CompDocBorder guifg=# guibg=#None
        --autocmd! ColorScheme * highlight CompDocBorder guifg=#ffaa55 guibg=None
        --local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                completion = {
                    scrollbar = false,
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    --winhighlight = 'NormalFloat:NormalFloat,CompBorder:CompBorder',
                    winhighlight = "NormalFloat:CompNormal,FloatBorder:CompBorder",
                },
                documentation = {
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    --winhighlight = 'NormalFloat:CompNormal,FloatBorder:CompDocBorder',
                    winhighlight = "NormalFloat:CompNormal,FloatBorder:FloatBorder",
                },
            },

            mapping = cmp.mapping.preset.insert({

                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-x>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                --['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                --["<C-j>"] = cmp.mapping(function(fallback)
                --    cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                --end, {
                --    "i",
                --    "s", [> "c" (to enable the mapping in command mode) <]
                --}),
                --["<C-k>"] = cmp.mapping(function(fallback)
                --    cmp_ultisnips_mappings.jump_backwards(fallback)
                --end, {
                --    "i",
                --    "s", [> "c" (to enable the mapping in command mode) <]
                --}),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
                ["<C-y>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
                ["<C-l>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
                -- Tab / Shift-Tab 在补全列表里上下选择（Select 只高亮不插入，再按 <CR>/<C-y> 才确认）
                -- 不在补全状态时 fallback = 原来的 Tab 行为（你的 expandtab=4 → 4 个空格）
                -- 注：UltiSnips 的展开/跳转是 <C-j> / <C-k>，跟 Tab 不冲突
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "jupynium", priority = 60 }, -- consider higher priority than LSP
                { name = "copilot", priority = 200 },
                { name = "nvim_lsp", priority = 100 },
                { name = "ultisnips", priority = 80 }, -- 代码模板（UltiSnips）；之前被注释掉 → 菜单里看不到模板
                { name = "calc", priority = 100 },
                { name = "nvim_lsp_signature_help", priority = 100 },
                { name = "path", priority = 100 },
                { name = "buffer", priority = 100 },
                { name = "emoji", insert = true, priority = 100 },
            }),
            sorting = {
                priority_weight = 1.0,
                comparators = {
                    compare.score, -- 匹配得分（Jupyter kernel 候选排 LSP 前）
                    compare.exact, -- 完全匹配的排最前
                    compare.recently_used,
                    compare.locality,
                    compare.kind,      -- 同分时按类型（snippet/keyword 之类优先）
                    compare.sort_text, -- 尊重 LSP 给的 sortText（服务端认为最合适的排前）
                    compare.length,    -- 短的优先（输入 while 时 while 排在 while_loop 前）
                    compare.order,
                },
            },
            formatting = {
                format = function(entry, vim_item)
                    -- Kind icons
                    vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
                    -- Source
                    vim_item.menu = ({
                        buffer = "[Buf]",
                        nvim_lsp = "[LSP]",
                        ultisnips = "[Snip]",
                        nvim_lua = "[Lua]",
                        orgmode = "[Org]",
                        path = "[Path]",
                        dap = "[DAP]",
                        emoji = "[Emoji]",
                        calc = "[CALC]",
                        latex_symbols = "[LaTeX]",
                        cmdline_history = "[History]",
                        cmdline = "[Command]",
                        copilot = "[GIT]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
            enabled = function()
                return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
            end,
            -- 「显示最优的补全」：自动高亮选中排序最靠前的候选（但不插入，按 <CR>/<C-y> 才确认）
            preselect = cmp.PreselectMode.Item,
            -- 补全窗口行为：有候选就弹、只有一条也弹、不自动插入
            completion = { completeopt = "menu,menuone,noselect" },
            -- 「把需要补全的内容灰化」：在光标后用灰色虚影(ghost text)显示即将补上的那部分
            experimental = { ghost_text = { hl_group = "CmpGhostText" } },
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype("org", {
            sources = cmp.config.sources({
                { name = "orgmode" },
                { name = "buffer" },
                { name = "path" },
                { name = "calc" },
                { name = "ultisnips" },
                { name = "emoji", insert = true },
            }),
        })
        cmp.setup.filetype("markdown", {
            sources = cmp.config.sources({
                { name = "ultisnips" },
                { name = "buffer" },
                { name = "path" },
                { name = "calc" },
                { name = "emoji", insert = true },
            }),
        })
        cmp.setup.filetype("dap-repl", {
            sources = cmp.config.sources({
                { name = "dap" },
                { name = "path" },
            }),
        })
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
                { name = "buffer" },
            }),
        })

        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
                { name = "cmdline_history" },
            }),
        })

        -- Setup lspconfig.
        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        -- 只在真装了 Go 工具链时才启 gopls：lspconfig 的 gopls 会调 `go env GOMOD` 算 root_dir，
        -- 这台机器没装 go → 打开 .go 文件会报 `E475: Invalid value for argument cmd: 'go' is not executable`
        if vim.fn.executable("go") == 1 and vim.fn.executable("gopls") == 1 then
            require("lspconfig")["gopls"].setup({
                capabilities = capabilities,
            })
        end
    end,
}

plugin.mapping = function() end
return plugin
