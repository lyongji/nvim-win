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

local plugins = {
	"folke/tokyonight.nvim", -- 主题
	"nvim-lualine/lualine.nvim",  -- 状态栏
	{ 'echasnovski/mini.icons', version = false }, -- mini 图标
	{ 'echasnovski/mini.files', version = false }, -- mini 文件浏览
	"christoomey/vim-tmux-navigator", -- 用ctl-hjkl来定位窗口
	{
		"nvim-treesitter/nvim-treesitter", -- 语法高亮  
		build = ':TSUpdate', -- 确保在安装后更新  
		config = function()
			require 'nvim-treesitter.install'.compilers = { "clang" ,"clang++" }
		end,
	},
	-- 配合treesitter，不同括号颜色区分 已弃用
--	{ "p00f/nvim-ts-rainbow", dependencies = { "nvim-treesitter/nvim-treesitter" }},
}
local opts = {} -- 注意要定义这个变量

require("lazy").setup(plugins, opts)
