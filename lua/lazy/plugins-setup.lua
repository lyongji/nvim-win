local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- 启动Lazy插件管理快捷键
vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { noremap = true })

require("lazy").setup({

	require("lazy.plugins.xmake"), -- xmake 
	require("lazy.plugins.blinkcmp"), -- 补全功能 
	require("lazy.plugins.lualine"), -- 底部状态栏
	require("lazy.plugins.bufferline"), -- 文件缓冲状态栏 
	require("lazy.plugins.mini-files"),-- mini 文件浏览
	require("lazy.plugins.mini-icons"),  -- mini 图标
	require("lazy.plugins.treesitter"), -- 语法高亮
	require("lazy.plugins.rainbowbracket"),	-- 配合treesitter，不同括号颜色区分 
	require("lazy.plugins.lsp"), -- 语法高亮
	require("lazy.plugins.theme"), -- 配色主题



})
