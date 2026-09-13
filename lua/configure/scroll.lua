local plugin = {}

plugin.core = {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("neoscroll").setup({
            -- All these keys will be mapped to their corresponding default scrolling animation
            --mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
            --'<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = true, -- Stop at <EOF> when scrolling downwards
            use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
            respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
            easing_function = nil, -- Default easing function
            pre_hook = nil, -- Function to run before the scrolling animation starts
            post_hook = nil, -- Function to run after the scrolling animation ends
        })

        -- 自定义滚动映射。老写法 require("neoscroll.config").set_mappings(t) 已废弃，
        -- 每次启动会弹 "Neoscroll: set_mappings() is deprecated" 警告，改成直接调 helper 函数
        -- （同时必须用 scroll(lines, opts) 的新签名，老的位置参数签名也会弹警告）
        local neoscroll = require("neoscroll")
        local keymap = {
            ["<C-u>"] = function() neoscroll.scroll(-vim.wo.scroll, { move_cursor = true, duration = 100, easing = "sine" }) end,
            ["<C-d>"] = function() neoscroll.scroll(vim.wo.scroll, { move_cursor = true, duration = 100, easing = "quadratic" }) end,
            ["<C-b>"] = function() neoscroll.scroll(-vim.api.nvim_win_get_height(0), { move_cursor = true, duration = 150 }) end,
            ["<C-f>"] = function() neoscroll.scroll(vim.api.nvim_win_get_height(0), { move_cursor = true, duration = 150 }) end,
            ["<C-y>"] = function() neoscroll.scroll(-0.10, { move_cursor = false, duration = 30 }) end,
            ["<C-e>"] = function() neoscroll.scroll(0.10, { move_cursor = false, duration = 30 }) end,
            ["zt"] = function() neoscroll.zt({ half_win_duration = 50 }) end,
            ["zz"] = function() neoscroll.zz({ half_win_duration = 50 }) end,
            ["zb"] = function() neoscroll.zb({ half_win_duration = 50 }) end,
        }
        -- 和原来的 set_mappings 一样只映射 n / x 模式
        for key, func in pairs(keymap) do
            vim.keymap.set({ "n", "x" }, key, func, { silent = true, desc = "neoscroll " .. key })
        end
    end,
}

plugin.mapping = function() end

return plugin
