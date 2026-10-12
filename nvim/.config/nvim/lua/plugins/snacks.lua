return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["th"] = { "toggle_hidden", mode = { "n" } },
          },
        },
        list = {
          keys = {
            ["th"] = "toggle_hidden",
          },
        },
      },
      sources = {
        files = {
          hidden = true,
          ignored = true,
          exclude = { "**/node_modules/**" },
        },
        explorer = {
          hidden = true,
          ignored = true,
          git_untracked = true,
        },
      },
    },
  },
}
