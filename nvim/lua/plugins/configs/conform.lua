local util = require("conform.util")

local options = {
  formatters_by_ft = {
    css = { "prettier" },
    graphql = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    less = { "prettier" },
    markdown = { "prettier" },
    scss = { "prettier" },
    svelte = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    yaml = { "prettier" },
    go = { "gofumpt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },

  formatters = {
    prettier = {
      command = util.find_executable({
        "node_modules/.bin/prettier",
        "node_modules/prettier/bin/prettier.cjs",
        "node_modules/prettier/bin-prettier.js",
      }, "prettier"),
    },
  },
}

return options
