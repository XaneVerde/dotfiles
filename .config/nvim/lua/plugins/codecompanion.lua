return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim", -- Optional: improves UI selection menus
    },
    opts = {
      strategies = {
        chat = {
          adapter = "ollama",
        },
        inline = {
          adapter = "ollama",
        },
      },
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              -- Direct link to your external Ollama network instance
              url = "http://75.166.38.86:11434",
            },
            schema = {
              model = {
                default = "hf.co/Qwen/Qwen2.5-Coder-3B-Instruct-GGUF:latest",
              },
              num_ctx = {
                -- Hardcaps context window to save your server's 8GB RAM from hitting swap
                default = 8192,
              },
            },
          })
        end,
      },
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    },
  },
}
