-- 离线安装包标记检查
-- 装离线包时会在配置目录里放一个 .offline 文件，lazy / mason 看到它就不联网。
-- 注意：不能只看 vim.g.CONFIG —— 本配置里它早期指向 ~/.sea.nvim、
-- 之后又变成 stdpath("config")，所以两个位置都查一遍。
local M = {}

function M.enabled()
    local cands = { vim.fn.stdpath("config") .. "/.offline" }
    local c = vim.g.CONFIG
    if type(c) == "string" and c ~= "" then
        cands[#cands + 1] = c .. "/.offline"
    end
    for _, p in ipairs(cands) do
        if vim.fn.filereadable(p) == 1 then
            return true
        end
    end
    return false
end

return M
