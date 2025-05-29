return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {
    modes = {
      symbols = { -- Configure symbols mode
        win = {
          type = "split", -- split window
          relative = "win", -- relative to current window
          position = "right", -- right side
          size = 0.45, -- 30% of the window
        },
      },
    },
  },
}
