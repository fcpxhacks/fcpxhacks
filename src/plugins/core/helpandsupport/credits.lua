--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                             C R E D I T S                                  --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--- === plugins.core.helpandsupport.credits ===
---
--- Credits Menu Item.

--------------------------------------------------------------------------------
--
-- EXTENSIONS:
--
--------------------------------------------------------------------------------
local config			= require("cp.config")

--------------------------------------------------------------------------------
--
-- CONSTANTS:
--
--------------------------------------------------------------------------------
local PRIORITY 			= 3

--------------------------------------------------------------------------------
--
-- THE MODULE:
--
--------------------------------------------------------------------------------
local mod = {}

--- plugins.core.helpandsupport.credits.openCredits() -> nil
--- Function
--- Opens CommandPost Credits Window
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function mod.show()
	hs.openAbout()
end

--------------------------------------------------------------------------------
--
-- THE PLUGIN:
--
--------------------------------------------------------------------------------
local plugin = {
	id				= "core.helpandsupport.credits",
	group			= "core",
	dependencies	= {
		["core.menu.helpandsupport"]	= "helpandsupport",
		["core.commands.global"] 		= "global",
	}
}

--------------------------------------------------------------------------------
-- INITIALISE PLUGIN:
--------------------------------------------------------------------------------
function plugin.init(deps)

	--------------------------------------------------------------------------------
	-- Commands:
	--------------------------------------------------------------------------------
	local global = deps.global
	global:add("cpCredits")
		:whenActivated(mod.show)
		:groupedBy("helpandsupport")

	deps.helpandsupport:addItem(PRIORITY, function()
		return { title = i18n("credits"),	fn = mod.show }
	end)
	return mod

end

return plugin