return {
	ensure_installed = function(tools)
		require("mason").setup()
		local mr = require("mason-registry")

		local function install(tool)
			if not mr.has_package(tool) then
				print("Package " .. tool .. " is not available in Mason.")
				return
			end
			local p = mr.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end

		for _, lang in pairs(tools) do
			for _, tool in ipairs(lang) do
				install(tool)
			end
		end
	end,
}
