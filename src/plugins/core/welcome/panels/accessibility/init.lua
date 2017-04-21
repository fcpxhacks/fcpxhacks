--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                           I N T R O   P A N E L                            --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--- === plugins.core.welcome.panels.accessibility  ===
---
--- Accessibility Panel Welcome Screen.

--------------------------------------------------------------------------------
--
-- EXTENSIONS:
--
--------------------------------------------------------------------------------
local log										= require("hs.logger").new("intro")

local timer										= require("hs.timer")

local config									= require("cp.config")
local generate									= require("cp.web.generate")

--------------------------------------------------------------------------------
--
-- THE MODULE:
--
--------------------------------------------------------------------------------
local mod = {}

--------------------------------------------------------------------------------
-- CONTROLLER CALLBACK:
--------------------------------------------------------------------------------
local function controllerCallback(message)

	-- log.df("Intro Panel Callback Result: %s", hs.inspect(message))

	local result = message["body"][1]
	if result == "accessibilityQuit" then
		config.application():kill()
	elseif result == "enableAccessibility" then
		hs.accessibilityState(true)
		if accessibilityStateCheck then
			accessibilityStateCheck = nil
		end
		accessibilityStateCheck = timer.doEvery(0.1, function()
			if hs.accessibilityState() then
				mod.manager.nextPanel(mod._priority)
				timer.doAfter(0.1, function() mod.manager.webview:hswindow():focus() end)
				accessibilityStateCheck:stop()
			end
		end)
	end

end

--------------------------------------------------------------------------------
-- GENERATE CONTENT:
--------------------------------------------------------------------------------
local function generateContent()

	generate.setWebviewLabel(mod.webviewLabel)

	local env = {
		generate 	= generate,
		iconPath	= mod.iconPath,
	}

	local result, err = mod.renderPanel(env)
	if err then
		log.ef("Error while generating Accessibility Welcome Panel: %", err)
		return err
	else
		return result, mod.panelBaseURL
	end
end

--------------------------------------------------------------------------------
-- PANEL ENABLED:
--------------------------------------------------------------------------------
local function panelEnabled()
	return not hs.accessibilityState(false)
end

--------------------------------------------------------------------------------
-- INITIALISE MODULE:
--------------------------------------------------------------------------------
function mod.init(deps, env)

	mod.webviewLabel = deps.manager.getLabel()

	mod._id 			= "accessibility"
	mod._priority		= 30
	mod._contentFn		= generateContent
	mod._callbackFn 	= controllerCallback
	mod._enabledFn		= panelEnabled

	mod.manager = deps.manager

	mod.manager.addPanel(mod._id, mod._priority, mod._contentFn, mod._callbackFn, mod._enabledFn)

	mod.renderPanel = env:compileTemplate("html/panel.html")
	mod.iconPath = env:pathToAbsolute("html/accessibility_icon.png")

	return mod

end

--------------------------------------------------------------------------------
--
-- THE PLUGIN:
--
--------------------------------------------------------------------------------
local plugin = {
	id				= "core.welcome.panels.accessibility",
	group			= "core",
	dependencies	= {
		["core.welcome.manager"]	= "manager",
	}
}

--------------------------------------------------------------------------------
-- INITIALISE PLUGIN:
--------------------------------------------------------------------------------
function plugin.init(deps, env)
	return mod.init(deps, env)
end

return plugin