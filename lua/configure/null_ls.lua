local plugin = {}

plugin.core = {
    "nvimtools/none-ls.nvim", -- 原 jose-elias-alvarez/null-ls.nvim 仓库已被作者删除（404），改用维护中的 none-ls（API 兼容，模块名仍是 null-ls）
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function() end
return plugin
