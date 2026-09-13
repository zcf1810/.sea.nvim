-- 离线安装包标记检查
-- 装离线包时会在配置目录里放一个 .offline 文件，lazy / mason 看到它就不联网。
-- 为什么要查这么多地方：本配置里 vim.g.CONFIG 早期指向 ~/.sea.nvim、之后又变成
-- stdpath("config")（会被 shada 恢复成旧值），个别机器还可能设了 XDG_CONFIG_HOME。
local M = {}

function M.enabled()
    local home = vim.fn.expand("~")
    local cands = {
        vim.fn.stdpath("config") .. "/.offline",
        home .. "/.config/nvim/.offline",
        home .. "/.sea.nvim/.offline",
    }
    local c = vim.g.CONFIG
    if type(c) == "string" and c ~= "" then
        cands[#cands + 1] = c .. "/.offline"
    end
    if vim.env.XDG_CONFIG_HOME and vim.env.XDG_CONFIG_HOME ~= "" then
        cands[#cands + 1] = vim.env.XDG_CONFIG_HOME .. "/nvim/.offline"
    end
    for _, p in ipairs(cands) do
        if vim.fn.filereadable(p) == 1 then
            return true
        end
    end
    return false
end

return M
