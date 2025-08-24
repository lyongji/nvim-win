return { 
    "nvim-lualine/lualine.nvim",  -- 状态栏插件
    event = "VeryLazy",           -- 延迟加载
    opts = {                      -- 基本配置
        options = {
            theme = "tokyonight"  -- 使用tokyonight主题
        },
  sections = {
    lualine_y = {
      {
        function()
          if not vim.g.loaded_xmake then
            return ""
          end
          local Info = require("xmake.info")
          if Info.mode.current == "" then
            return ""
          end
          if Info.target.current == "" then
            return "Xmake: 未选择目标 "
          end
          return ("%s(%s)"):format(Info.target.current, Info.mode.current)
        end,
        cond = function()
          return vim.o.columns > 100
        end,
      },
    },
  },
		},
	}
