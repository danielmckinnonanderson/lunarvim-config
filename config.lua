-- General
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.leader = "space"

-- Appearance
lvim.colorscheme = "zenburned"
lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.options.theme = "gruvbox"
lvim.builtin.lualine.sections.lualine_x = { "encoding", "filetype" }

-- Parsers
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "lua",
  "python",
  "typescript",
  "rust",
  "yaml",
  "java"
}

-- Remaps / keybinds
-- TODO - Create a keybind for LSP-reliant find & replace

-- Github Co-Pilot remaps
vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Normal mode move up/down visual lines (in multi-line wrapped text)
vim.api.nvim_set_keymap("n", "<C-j>", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "gk", { noremap = true, silent = true })

-- Normal mode can wrap virtual error test in floating window
vim.api.nvim_set_keymap("n", "g?", ":lua vim.diagnostic.open_float(nil, { scope = 'line' })<CR>", { noremap = true, silent = true })

-- Normal mode jump to previous / next error lines
vim.api.nvim_set_keymap("n", "geb", ":lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gen", ":lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })

-- File-dependent hooks
-- Set 4-space indent for C/C++ files
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = {'*.c', '*.cpp', '*.h', '*.hpp'},
  command = 'setlocal shiftwidth=4 tabstop=4'
})
-- Prevent weird "offset encoding" bug w/ clang by silencing it (Linux only)
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("warning: multiple different client offset_encodings") then
    return
  end
  notify(msg, ...)
end

-- Set wrap for markdown & text files
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = {'*.md', '*.txt', '*.mdx'},
  command = 'setlocal wrap'
})

-- Configure visual marks plugin
require"marks".setup {}

-- Plugins
lvim.plugins = {
  -- Color themes 
  "projekt0n/github-nvim-theme",
  "sjl/badwolf",
  {
    "mcchrish/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim"
  },
  "jnurmine/Zenburn",

  -- Transparent editor background
  "xiyaowong/transparent.nvim",

  -- Visualize marks in margins
  "chentoast/marks.nvim",

  -- Github Co-Pilot
  "github/copilot.vim"
}
