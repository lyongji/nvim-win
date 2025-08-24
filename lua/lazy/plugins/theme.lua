-- 在插件配置中添加
return{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "moon", -- 你想要的风格
      transparent = false, -- 是否透明背景
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    })
    vim.cmd.colorscheme("tokyonight-moon")
  end,
}
