return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
    },
  },
  { "rcarriga/nvim-dap-ui",
  dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
},
}
