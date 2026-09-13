local M = {}
local local_setup = function()
    require("core.local").setup()
end

M.setup = function()
    pcall(local_setup)

    local themes = require("core.themes")

    if os.getenv("GLOBAL_THEME") == "light" then
        themes.setting(themes.configs.material_light)
    else
        themes.setting(themes.configs.material_palenight)
    end

    -- 自动挑一个装了 pynvim 的 python：原来写死 /usr/bin/python3.8，换台机器就废。
    -- 本机有 3.8 就直接用（零额外开销），没有时才去探测别的 python
    local function pick_python_host()
        if vim.fn.executable("/usr/bin/python3.8") == 1 then
            return "/usr/bin/python3.8"
        end
        for _, cand in ipairs({ "/usr/bin/python3", "/usr/local/bin/python3", vim.fn.exepath("python3") }) do
            if cand ~= "" and vim.fn.executable(cand) == 1 then
                vim.fn.system({ cand, "-c", "import pynvim" })
                if vim.v.shell_error == 0 then
                    return cand
                end
            end
        end
        return "python3"
    end

    local user_setting = {
        python3_host_prog = pick_python_host(),
        snips_author = "Sun Fu",
        snips_email = "cstsunfu@gmail.com",
        snips_github = "https://github.com/cstsunfu",
        snips_wechat = "cstsunfu",
    }

    for key, value in pairs(user_setting) do
        vim.g[key] = value
    end

    if vim.g.my_dlk_tools then -- this is just used for my own deep learning python packages dlk, so this will not effect you
        require("util.dlk_util")
    end
end

M.after = function()
    local local_after = function()
        require("core.local").after()
    end
    pcall(local_after)
end

return M
