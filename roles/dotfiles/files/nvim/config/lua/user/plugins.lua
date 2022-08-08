local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' --  let packer manage itself
    
    -- Speed up loading Lua modules in Neovim to improve startup time.
    use {
		'lewis6991/impatient.nvim',
		config = function()
			require("impatient").enable_profile()
		end,
	}

    -- ui
    use {
        'folke/tokyonight.nvim',
        config = function()
			require("user.colorscheme")
		end,
    }

	use {
		'kyazdani42/nvim-web-devicons',
		config = function()
			require("nvim-web-devicons").setup({
				default = true,
			})
		end,
	}

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require("user.lualine")
		end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)