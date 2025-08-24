return {
  {
    "Mythos-404/xmake.nvim",
    version = "^3",
    lazy = true,
    event = "BufReadPost",
    config = true,
    opts = {
      lsp = { language = "zh-cn" },
    },
  },
}
