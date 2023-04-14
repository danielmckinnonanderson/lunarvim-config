-- ********
-- #GENERAL
-- ********
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = false
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
vim.opt.relativenumber = true


-- ******
-- #THEME
-- ******
lvim.colorscheme = "seoulbones"

-- tweak colors for specific schemes that I don't feel like forking
if lvim.colorscheme == "seoulbones" then
  vim.api.nvim_command([[
    augroup ChangeBackgroundColour
      autocmd colorscheme * :hi normal guibg=#232324
    augroup END
  ]])
end


-- ********************* 
-- #OS-SPECIFIC-SETTINGS
-- ********************* 

-- Windows
local function win_setup()

  -- Function to use win32yank for clipboard stuff
  local function win_use_winyank_clipboard()
    vim.g.clipboard = {
      copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
      },
      paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
      },
    }
  end

  -- Function to set Windows Powershell as default 
  local function win_default_to_powershell()
    vim.opt.shell = "pwsh.exe -NoLogo"
    vim.opt.shellcmdflag =
      "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    vim.cmd [[
        let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        set shellquote= shellxquote=
      ]]
    lvim.builtin.terminal.shell = "pwsh.exe -NoLogo"
  end

  -- Function to address nvim-tree performance issues on Windows, see kyazdani42/nvim-tree.lua#549
  local function win_improve_nvimtree_performance()
    lvim.builtin.nvimtree.setup.diagnostics.enable = nil
    lvim.builtin.nvimtree.setup.filters.custom = nil
    lvim.builtin.nvimtree.setup.git.enable = nil
    lvim.builtin.nvimtree.setup.update_cwd = nil
    lvim.builtin.nvimtree.setup.update_focused_file.update_cwd = nil
    lvim.builtin.nvimtree.setup.view.side = "left"
    lvim.builtin.nvimtree.setup.renderer.highlight_git = nil
    lvim.builtin.nvimtree.setup.renderer.icons.show.git = nil
  end

  win_default_to_powershell()
  win_use_winyank_clipboard()
  win_improve_nvimtree_performance()
end

-- Nvim tree standard setup for use with Mac & Linux
local function unix_nvim_tree_setup()
  lvim.builtin.nvimtree.setup.view.side = "left"
  lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
end

-- Linux
local function linux_setup()
  -- Fix weird visual bug causing buffer title to appear in line constantly
  vim.opt.title = false

  -- Only use transparent background plugin on Linux
  require("transparent").setup({
    enable = true,
    extra_groups = {},
    exclude = {},
  })

  unix_nvim_tree_setup()
end

local function mac_setup()
  unix_nvim_tree_setup()
end

local sysname = vim.loop.os_uname().sysname

if sysname == "Windows_NT" then
  win_setup()
elseif sysname == "Darwin" then
  mac_setup()
elseif sysname == "Linux" then
  linux_setup()
end

-- ***********
-- #TREESITTER
-- ***********
lvim.builtin.treesitter.ensure_installed = {
  "c",
  "lua",
}

lvim.builtin.treesitter.highlight.enable = true


-- *************
-- #LSP-SETTINGS
-- *************

-- TODO - Custom func that determines the tab size per-language? Or perhaps a default with 
--        a few targeted overrides?


-- ******** 
-- #PLUGINS
-- ******** 
lvim.plugins = {
  -- Background opacity
  "xiyaowong/nvim-transparent",
  -- Themes
  "ellisonleao/gruvbox.nvim",
  {
    "mcchrish/zenbones.nvim",
    requires = "rktjmp/lush.nvim"
  },
  {
    "danielmckinnonanderson/badwolf-nvim",
    requires = "rktjmp/lush.nvim"
  },
}

