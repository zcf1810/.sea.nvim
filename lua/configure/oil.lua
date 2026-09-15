local plugin = {}
plugin.core = {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("oil").setup({
            default_file_explorer = true, -- 打开目录时用 oil 接管（不用 netrw）
            columns = { "icon" },
            view_options = { show_hidden = true },
            float = {
                padding = 2,
                max_width = 0.8,
                max_height = 0.8,
                border = "rounded",
                winblend = 0,
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "-" },
        action = "<CMD>Oil<CR>",
        short_desc = "打开所在目录（oil）",
        silent = true,
    })
end
return plugin
