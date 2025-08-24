-- 自动执行

-- 禁用xmake.lua 的格式化功能
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    -- 获取当前缓冲区文件名（不含路径）
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
    -- 仅当文件名为 xmake.lua 时禁用格式化
    if filename == "xmake.lua" then
      vim.b.autoformat = false
    end
  end,
})
