return{
  -- 插件：mini.files - 轻量级文件浏览器
  "echasnovski/mini.files",
  
  -- 基本配置选项
  opts = {
    windows = {
      preview = true,        -- 启用文件预览
      width_focus = 30,      -- 聚焦时窗口宽度
      width_preview = 30,    -- 预览窗口宽度
    },
    options = {
      -- 是否用作默认文件浏览器
      -- 在LazyVim中默认禁用，因为使用neo-tree作为默认文件管理器
      use_as_default_explorer = true,
    },
  },
  -- 配置函数
  config = function(_, opts)
    -- 初始化mini.files
    require("mini.files").setup(opts)

    -- 显示隐藏文件相关变量和函数
    local show_dotfiles = true  -- 是否显示点文件（隐藏文件）
    -- 过滤器函数：显示所有文件
    local filter_show = function(fs_entry)
      return true
    end
    -- 过滤器函数：隐藏点文件
    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, ".")
    end

    -- 切换显示/隐藏点文件
    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      require("mini.files").refresh({ content = { filter = new_filter } })
    end

    -- 创建分割窗口映射函数
    local map_split = function(buf_id, lhs, direction, close_on_file)
      local rhs = function()
        local new_target_window
        -- 获取当前目标窗口
        local cur_target_window = require("mini.files").get_explorer_state().target_window
        if cur_target_window ~= nil then
          -- 在当前目标窗口中创建分割
          vim.api.nvim_win_call(cur_target_window, function()
            vim.cmd("belowright " .. direction .. " split")
            new_target_window = vim.api.nvim_get_current_win()
          end)

          -- 设置新的目标窗口并进入文件
          require("mini.files").set_target_window(new_target_window)
          require("mini.files").go_in({ close_on_file = close_on_file })
        end
      end

      -- 描述文本
      local desc = "在" .. direction .. "分割中打开"
      if close_on_file then
        desc = desc .. "并关闭文件浏览器"
      end
      -- 设置键盘映射
      vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
    end

    -- 设置当前工作目录到选中目录
    local files_set_cwd = function()
      local cur_entry_path = MiniFiles.get_fs_entry().path
      local cur_directory = vim.fs.dirname(cur_entry_path)
      if cur_directory ~= nil then
        vim.fn.chdir(cur_directory)  -- 更改工作目录
      end
    end

    -- 自动命令：当MiniFiles缓冲区创建时设置映射
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id

        -- 切换隐藏文件显示
        vim.keymap.set(
          "n",
          opts.mappings and opts.mappings.toggle_hidden or "g.",
          toggle_dotfiles,
          { buffer = buf_id, desc = "切换隐藏文件显示" }
        )

        -- 设置工作目录
        vim.keymap.set(
          "n",
          opts.mappings and opts.mappings.change_cwd or "gc",
          files_set_cwd,
          { buffer = args.data.buf_id, desc = "设置当前工作目录" }
        )

        -- 设置各种分割窗口映射
        map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or "fh", "horizontal", false)
        map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or "fu", "vertical", false)
        map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal_plus or "FH", "horizontal", true)
        map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or "FU", "vertical", true)
      end,
    })

    -- 自动命令：文件重命名时触发Snacks的重命名处理
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "MiniFilesActionRename",
    --   callback = function(event)
    --     Snacks.rename.on_rename_file(event.data.from, event.data.to)
    --   end,
    -- })
  end,
}
