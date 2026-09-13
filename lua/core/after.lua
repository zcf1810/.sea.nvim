-- special setting
local timer = vim.loop.new_timer()
local hl_fun = require("util.highlight")
timer:start(
    1000,
    0,
    vim.schedule_wrap(function()
        vim.cmd("hi! link SignColumn LineNr") --set VertSplit color to black
        vim.cmd("autocmd ColorScheme, VimEnter * highlight! link SignColumn LineNr")

        vim.cmd("hi VertSplit ctermfg=black guifg=black") --set VertSplit color to black
        vim.cmd("hi StatusLine ctermfg=black guifg=black") --set HSplit color to black

        vim.cmd("highlight clear WhichKeyDesc")
        vim.cmd("highlight WhichKeyDesc guifg=#98be65")

        local normal = hl_fun.get_highlight_values("Normal")
        local darkbg = hl_fun.brighten(normal.background, -5) -- darken by 5%
        hl_fun.highlight("DarkNormal", { bg = darkbg, fg = normal.foreground })

        local telescope_border = "#9a95bf"
        hl_fun.highlight("TelescopePromptBorder", { bg = darkbg, fg = telescope_border })
        hl_fun.highlight("TelescopeResultsBorder", { bg = darkbg, fg = telescope_border })
        hl_fun.highlight("TelescopePreviewBorder", { bg = darkbg, fg = telescope_border })

        vim.cmd("highlight! link TelescopeNormal DarkNormal")
        vim.cmd("highlight WhichKeyDesc guifg=#98be65")
        vim.cmd("hi! link CodeActionNumber @keyword")
    end)
)

-- ─────────────────────────────────────────────────────────────
-- 外部改动自动刷新 buffer
-- 用途：Claude Code 用 bash/sed 直接写盘时（不走 diff 那条路），你这边窗口也跟着更新
-- 两个坑（实测出来的）：
--   1) 必须 vim.schedule 出去再 :checktime —— 直接在 autocmd 回调里调用不会真的重载
--   2) 不用 CursorHold：本配置 updatetime=30，挂上去等于每 30ms 全量 stat 一次，机械盘太亏
vim.o.autoread = true
local autoread_group = vim.api.nvim_create_augroup("AutoReadExternalChanges", { clear = true })

local function refresh_buffers()
    -- 只要有任何未保存改动就整体跳过，免得 nvim 弹 "file changed" 打断你输入
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
            return
        end
    end
    vim.schedule(function()
        pcall(vim.cmd, "silent! checktime")
    end)
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermLeave" }, {
    group = autoread_group,
    callback = function()
        if vim.fn.getcmdwintype() ~= "" or vim.bo.buftype == "terminal" then
            return
        end
        refresh_buffers()
    end,
})
