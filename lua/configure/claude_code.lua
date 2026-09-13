-- Claude Code IDE 集成（coder/claudecode.nvim）
-- 用 Anthropic 官方的 IDE 协议（WebSocket）：选中代码直接发给 Claude、Claude 的改动以原生 diff 呈现、可接受/拒绝
-- 依赖：folke/snacks.nvim（终端）、Claude Code CLI（本机 ~/.config/nvm/versions/node/v20.19.0/bin/claude，v2.1.150）
local plugin = {}

local claude_exe = vim.fn.exepath("claude")
if claude_exe == "" then
    claude_exe = "claude"
end

plugin.core = {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },

    -- 这些命令按需加载插件（不然 fressh 启动时会没有 :ClaudeCode）
    cmd = {
        "ClaudeCode",
        "ClaudeCodeFocus",
        "ClaudeCodeSelectModel",
        "ClaudeCodeAdd",
        "ClaudeCodeSend",
        "ClaudeCodeTreeAdd",
        "ClaudeCodeStatus",
        "ClaudeCodeStart",
        "ClaudeCodeStop",
        "ClaudeCodeOpen",
        "ClaudeCodeClose",
        "ClaudeCodeDiffAccept",
        "ClaudeCodeDiffDeny",
        "ClaudeCodeCloseAllDiffs",
    },

    opts = {
        auto_start = true, -- 随插件启动 WebSocket 服务，Claude CLI 会自动连上
        log_level = "warn", -- 这台机器少写点日志
        terminal_cmd = claude_exe,
        focus_after_send = true, -- 发送选中代码后自动跳到 Claude 终端
        track_selection = true, -- 实时同步你在哪个文件、选了哪几行
        git_repo_cwd = true, -- 工作目录用 git 根目录

        terminal = {
            provider = "auto", -- 有 snacks 用 snacks，否则用内置终端
            split_side = "right",
            split_width_percentage = 0.40, -- 小屏，别占太多
            auto_close = true, -- 退出 claude 自动关窗口
            auto_insert = true, -- 聚焦时直接进输入模式
            fix_streamed_paste = "auto", -- 规避 nvim <0.12.2 大段粘贴被截断
        },

        diff_opts = {
            layout = "vertical", -- Claude 提改动时左右分栏
            auto_resize_terminal = true,
        },
    },

    -- 显式 setup，避免 lazy 猜模块名
    config = function(_, opts)
        require("claudecode").setup(opts)
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    -- 统一放在 <leader>a 的 AI 命名空间，大写避让 ChatGPT（小写）与注释/颜色（<leader>c*）
    mappings.register({ mode = "n", key = { "<leader>", "a", "C" }, action = ":ClaudeCode<cr>", short_desc = "Claude Code 打开/关闭" })
    mappings.register({ mode = "n", key = { "<leader>", "a", "F" }, action = ":ClaudeCodeFocus<cr>", short_desc = "Claude Code 聚焦终端" })
    mappings.register({ mode = "n", key = { "<leader>", "a", "R" }, action = ":ClaudeCode --resume<cr>", short_desc = "Claude Code 挑历史会话" })
    mappings.register({ mode = "n", key = { "<leader>", "a", "M" }, action = ":ClaudeCodeSelectModel<cr>", short_desc = "Claude Code 选模型" })
    mappings.register({ mode = "n", key = { "<leader>", "a", "B" }, action = ":ClaudeCodeAdd %<cr>", short_desc = "Claude Code 加入当前文件" })
    mappings.register({ mode = "v", key = { "<leader>", "a", "S" }, action = ":ClaudeCodeSend<cr>", short_desc = "Claude Code 发送选中代码" })
    mappings.register({ mode = "n", key = { "<leader>", "a", "A" }, action = ":ClaudeCodeDiffAccept<cr>", short_desc = "Claude Code 接受改动" })
    mappings.register({ mode = "n", key = { "<leader>", "a", "D" }, action = ":ClaudeCodeDiffDeny<cr>", short_desc = "Claude Code 拒绝改动" })
end

return plugin
