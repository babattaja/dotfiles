-- auto-compile when lua files in `~/.config/nvim/*` change
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  callback = function()
    local cfg_path = vim.fn.resolve(vim.fn.stdpath("config"))
    vim.defer_fn(function()
      if vim.fn.expand("%:p"):match(cfg_path) then
        vim.cmd("silent! PackerCompile")
      end
    end, 0)
  end,
})

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')
  use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
	transparent_background =
	true,
      })
      vim.cmd.colorscheme "catppuccin"
    end
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
      })
    end,
  })

  if packer_bootstrap then
    require('packer').sync()
  end
end)
