-- ===
-- === 键盘映射函数
-- ===

-- 通用键盘映射函数
-- @param mode 模式: n(正常), i(插入), v(可视), x(选择), t(终端)等
-- @param lhs 左手边: 按下的键
-- @param rhs 右手边: 映射到的命令或函数

local function mapkey(mode, lhs, rhs)
	vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true })
end

-- 映射到命令的函数
-- @param key 按下的键
-- @param cmd 要执行的Vim命令
local function mapcmd(key, cmd)
	vim.api.nvim_set_keymap("n", key, ":" .. cmd .. "<cr>", { noremap = true })
end

-- 映射到Lua代码的函数  
-- @param key 按下的键
-- @param txt 要执行的Lua代码
local function maplua(key, txt)
	vim.api.nvim_set_keymap("n", key, ":lua " .. txt .. "<cr>", { noremap = true })
end

-- ===
-- === 基本键盘映射配置
-- ===

vim.g.mapleader = " " --导航健

mapkey("n", "<leader>w", ":w<cr>")          -- 保存文件
mapkey("n", "<leader>q", ":q<cr>")          -- 退出
mapkey("n", "<C-s>", ":w<cr>")              -- Ctrl+s 保存
mapkey("i", "jk", "<Esc>")                  -- jk 退出插入模式

--缓冲区标签--
mapcmd("tt", "tabnew")                      -- 新建标签页
mapcmd("tc", "tabclose")                    -- 关闭标签页
mapcmd('tq', 'bd') -- 关闭标签，貌似是neovim自带的，完整命令bdelete
-- 在标签之间移动
mapcmd('th', 'BufferLineCyclePrev')
mapcmd('tl', 'BufferLineCycleNext')
-- 移动标签的位置
mapcmd('tmh', 'BufferLineMovePrev')
mapcmd('tml', 'BufferLineMoveNext')

-- 单行或多行移动
mapkey("v", "J", ":m '>+1<CR>gv=gv")
mapkey("v", "K", ":m '<-2<CR>gv=gv") 

-- 窗口
mapkey("n", "<leader>sh", "<C-w>v") -- 水平新增窗口 横hěn hf 自然码
mapkey("n", "<leader>su", "<C-w>s") -- 垂直新增窗口 竖shù uu

-- === MiniFiles 文件浏览器快捷键
-- 打开当前文件所在目录
maplua("<leader>e", "require('mini.files').open(vim.api.nvim_buf_get_name(0), true)")
-- 打开当前工作目录  
maplua("<leader>E", "require('mini.files').open(vim.uv.cwd(), true)")
-- 快速打开文件浏览器
maplua("<leader>fe", "require('mini.files').open()")
-- MiniFiles 内部快捷键：
-- g. - 切换显示/隐藏文件
-- gc - 设置当前工作目录
-- a - 创建文件/目录
-- d - 删除文件/目录
-- r - 重命名文件/目录
-- q 或 <Esc> - 关闭文件浏览器



