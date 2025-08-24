-- ===
-- === treesitter,语法高亮
-- ===

return {
  "nvim-treesitter/nvim-treesitter", 
  version = false, -- 不使用固定版本（因为最新版本太旧且在Windows上不工作）
  build = ":TSUpdate", -- 安装命令：更新Treesitter解析器
  event = {"BufReadPost", "BufNewFile", "VeryLazy" }, -- 延迟加载事件
  lazy = vim.fn.argc(-1) == 0, -- 从命令行打开文件时提前加载
  
  -- 初始化函数：提前加载必要的组件
  init = function(plugin)
    -- 性能优化：提前将treesitter查询添加到运行时路径
    -- 这是因为许多插件不再require("nvim-treesitter")，导致加载时机过晚
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates") -- 加载查询谓词
  end,
  
  -- 支持的命令
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  
  -- 键盘映射
  keys = {
    { "<c-space>", desc = "增量选择" }, -- 开始或扩展选择
    { "<bs>", desc = "减量选择", mode = "x" }, -- 缩小选择（可视模式）
  },
  
  opts_extend = { "ensure_installed" }, -- 可扩展的配置选项
  
  opts = {  
    -- 要安装高亮的语言直接加入括号即可，把sync_install设置为true下次进入vim自动安装，
    -- 或者手动执行:TSInstall <想要安装的语言>
    -- 语言列表查看https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
    ensure_installed = {
      "json",
      "c",
      "cpp", 
      "python",
      "lua",        -- Lua语言
      "luadoc",     -- LuaDoc注释
      "luap",       -- Lua模式匹配
      "markdown",   -- Markdown
      "markdown_inline", -- 行内Markdown  
    },
    -- 设置为true后位于ensure_installed里面的语言会自动安装
    sync_install = true,
    -- 这里填写不想要自动安装的语言
    ignore_install = {},
    highlight = {
      -- 默认开启高亮
      enable = true,
      -- 想要禁用高亮的语言列表
      -- disable = {
      -- },
      -- 使用function以提高灵活性，禁用大型文件的高亮
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      -- 如果您依靠启用'语法'（例如，缩进），则将其设置为"True"。
      -- 使用此选项可能会放慢编辑器，您可能会看到一些重复的高亮。
      -- 除了设置为true，它也可以设置成语言列表
      additional_vim_regex_highlighting = false,
    },
    -- 增量选择功能
    incremental_selection = {
      enable = true, -- 启用增量选择
      keymaps = {
        init_selection = "<C-space>",      -- 开始选择
        node_incremental = "<C-space>",    -- 扩展选择到下一个节点
        scope_incremental = false,         -- 禁用范围增量选择
        node_decremental = "<bs>",         -- 缩小选择到上一个节点
      },
    },
    -- 文本对象操作
    textobjects = {
      move = {
        enable = true, -- 启用文本对象移动
        -- 移动到下一个开始位置
        goto_next_start = { 
          ["]f"] = "@function.outer", -- 下一个函数开始
          ["]c"] = "@class.outer",    -- 下一个类开始
          ["]a"] = "@parameter.inner" -- 下一个参数开始
        },
        -- 移动到下一个结束位置
        goto_next_end = { 
          ["]F"] = "@function.outer", -- 下一个函数结束
          ["]C"] = "@class.outer",    -- 下一个类结束
          ["]A"] = "@parameter.inner" -- 下一个参数结束
        },
        -- 移动到上一个开始位置
        goto_previous_start = { 
          ["[f"] = "@function.outer", -- 上一个函数开始
          ["[c"] = "@class.outer",    -- 上一个类开始
          ["[a"] = "@parameter.inner" -- 上一个参数开始
        },
        -- 移动到上一个结束位置
        goto_previous_end = { 
          ["[F"] = "@function.outer", -- 上一个函数结束
          ["[C"] = "@class.outer",    -- 上一个类结束
          ["[A"] = "@parameter.inner" -- 上一个参数结束
        },
      },
    },
  },
  config = function(_, opts)
    -- 在配置前设置编译器
    require('nvim-treesitter.install').compilers = { "clang", "clang++" } 
	require("nvim-treesitter.configs").setup(opts)
  end,
}
