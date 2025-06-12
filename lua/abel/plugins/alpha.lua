if true then
	return {}
else
	return {
		"goolord/alpha-nvim",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			require("alpha").setup(require("abel.utils.startupscreen-config").config)
		end,
	}
end
