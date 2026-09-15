local plugin = {}
plugin.core = {
    "ThePrimeagen/harpoon",
    branch = "harpoon2", -- 默认分支是老的 v1，v2 API 要显式指定
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local harpoon = require("harpoon")
        harpoon:setup({}) -- v2 要求必须调用

        _G._harpoon_menu = function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end
        _G._harpoon_add = function()
            harpoon:list():add()
            vim.notify("已钉住: " .. vim.fn.expand("%:t"), vim.log.levels.INFO, { title = "Harpoon" })
        end
        _G._harpoon_jump = function(n)
            harpoon:list():select(n)
        end
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    -- 说明：harpoon 官方示例用 <leader>a，但本配置里 <leader>a 是 AI 组，
    --       所以挪到 <leader>i（菜单/钉住）+ <leader>1~4（跳转）
    mappings.register({
        mode = "n",
        key = { "<leader>", "i" },
        action = "<cmd>lua _G._harpoon_menu()<cr>",
        short_desc = "Harpoon 文件列表",
        silent = true,
    })
    -- 用 <leader>P（Pin）：<leader>I 已被 bufferline 的"跳到第 18 个 buffer"占用，
    -- <leader>1~9 同理不能动
    mappings.register({
        mode = "n",
        key = { "<leader>", "P" },
        action = "<cmd>lua _G._harpoon_add()<cr>",
        short_desc = "Harpoon 钉住当前文件",
        silent = true,
    })
    -- 不占用 <leader>1~9：那是 bufferline 的"跳到第 N 个 buffer"。
    -- 选文件用 <leader>i 打开 harpoon 菜单后按 1~4 / j k 选。
    -- 手动跳第 N 个：:lua _G._harpoon_jump(2)
end
return plugin
