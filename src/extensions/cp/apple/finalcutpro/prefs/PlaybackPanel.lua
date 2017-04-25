--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                   F I N A L    C U T    P R O    A P I                     --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--- === cp.apple.finalcutpro.prefs.PlaybackPanel ===
---
--- Playback Panel Module.

--------------------------------------------------------------------------------
--
-- EXTENSIONS:
--
--------------------------------------------------------------------------------
local log								= require("hs.logger").new("playbackPanel")
local inspect							= require("hs.inspect")

local axutils							= require("cp.apple.finalcutpro.axutils")
local just								= require("cp.just")
local CheckBox							= require("cp.apple.finalcutpro.ui.CheckBox")

local id								= require("cp.apple.finalcutpro.ids") "PlaybackPanel"

--------------------------------------------------------------------------------
--
-- THE MODULE:
--
--------------------------------------------------------------------------------
local PlaybackPanel = {}

-- TODO: Add documentation
function PlaybackPanel:new(preferencesDialog)
	o = {_parent = preferencesDialog}
	setmetatable(o, self)
	self.__index = self
	return o
end

-- TODO: Add documentation
function PlaybackPanel:parent()
	return self._parent
end

-- TODO: Add documentation
function PlaybackPanel:UI()
	return axutils.cache(self, "_ui", function()
		local toolbarUI = self:parent():toolbarUI()
		return toolbarUI and toolbarUI[id "ID"]
	end)
end

-- TODO: Add documentation
function PlaybackPanel:isShowing()
	if self:parent():isShowing() then
		local toolbar = self:parent():toolbarUI()
		if toolbar then
			local selected = toolbar:selectedChildren()
			return #selected == 1 and selected[1] == toolbar[id "ID"]
		end
	end
	return false
end

-- TODO: Add documentation
function PlaybackPanel:show()
	local parent = self:parent()
	-- show the parent.
	if parent:show() then
		-- get the toolbar UI
		local panel = just.doUntil(function() return self:UI() end)
		if panel then
			panel:doPress()
			return true
		end
	end
	return false
end

function PlaybackPanel:hide()
	return self:parent():hide()
end

function PlaybackPanel:createMulticamOptimizedMedia()
	if not self._createOptimizedMedia then
		self._createOptimizedMedia = CheckBox:new(self, function()
			return axutils.childWithID(self:parent():groupUI(), id "CreateMulticamOptimizedMedia")
		end)
	end
	return self._createOptimizedMedia
end

function PlaybackPanel:backgroundRender()
	if not self._backgroundRender then
		self._backgroundRender = CheckBox:new(self, function()
			return axutils.childWithID(self:parent():groupUI(), id "BackgroundRender")
		end)
	end
	return self._backgroundRender
end

return PlaybackPanel