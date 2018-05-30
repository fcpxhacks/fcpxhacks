--- === plugins.finalcutpro.viewer.showtimecode ===
---
--- Show Timecode.

--------------------------------------------------------------------------------
--
-- EXTENSIONS:
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- CommandPost Extensions:
--------------------------------------------------------------------------------
local dialog            = require("cp.dialog")
local fcp               = require("cp.apple.finalcutpro")
local prop              = require("cp.prop")

--------------------------------------------------------------------------------
--
-- CONSTANTS:
--
--------------------------------------------------------------------------------

-- PRIORITY -> number
-- Constant
-- The menubar position priority.
local PRIORITY = 20

-- DEFAULT_VALUE -> number
-- Constant
-- The default value.
local DEFAULT_VALUE = 0

-- PREFERENCES_KEY -> string
-- Constant
-- The Preferences Key for Displaying Timecode
local PREFERENCES_KEY = "FFPlayerDisplayedTimecode"

--------------------------------------------------------------------------------
--
-- THE MODULE:
--
--------------------------------------------------------------------------------
local mod = {}

--- plugins.finalcutpro.viewer.showtimecode.enabled <cp.prop: boolean>
--- Variable
--- Show Timecode Enabled?
mod.enabled = prop.new(
    function()
        --------------------------------------------------------------------------------
        -- Get Preference:
        --------------------------------------------------------------------------------
        return fcp:getPreference(PREFERENCES_KEY, DEFAULT_VALUE)
    end,
    function(value)
        --------------------------------------------------------------------------------
        -- Set Preference:
        --------------------------------------------------------------------------------
        fcp:setPreference(PREFERENCES_KEY, value)
    end
)

-- toggle(value) -> none
-- Function
-- Toggles the Show Timecode option.
--
-- Parameters:
--  * value - A number between 1 and 4. Defaults to 0.
--
-- Returns:
--  * None
local function toggle(value)
    if mod.enabled() == value then
        mod.enabled:set(0)
    else
        mod.enabled:set(value)
    end
end

--------------------------------------------------------------------------------
--
-- THE PLUGIN:
--
--------------------------------------------------------------------------------
local plugin = {
    id              = "finalcutpro.viewer.showtimecode",
    group           = "finalcutpro",
    dependencies    = {
        ["finalcutpro.menu.viewer.showtimecode"]        = "menu",
        ["finalcutpro.commands"]                        = "fcpxCmds",
    }
}

--------------------------------------------------------------------------------
-- INITIALISE PLUGIN:
--------------------------------------------------------------------------------
function plugin.init(deps)

    --------------------------------------------------------------------------------
    -- Setup Menus:
    --------------------------------------------------------------------------------
    if deps.menu then
        deps.menu:addItem(PRIORITY, function()
            return { title = i18n("showProjectTimecodeTop"),    fn = function() toggle(3) end, checked=mod.enabled() == 3 }
        end)

        deps.menu:addItem(PRIORITY + 1, function()
            return { title = i18n("showProjectTimecodeBottom"), fn = function() toggle(4) end, checked=mod.enabled() == 4 }
        end)

        deps.menu:addItem(PRIORITY + 2, function()
            return { title = "-" }
        end)

        deps.menu:addItem(PRIORITY + 3, function()
            return { title = i18n("showSourceTimecodeTop"), fn = function() toggle(1) end, checked=mod.enabled() == 1 }
        end)

        deps.menu:addItem(PRIORITY + 4, function()
            return { title = i18n("showSourceTimecodeBottom"),  fn = function() toggle(2) end, checked=mod.enabled() == 2 }
        end)
    end

    --------------------------------------------------------------------------------
    -- Setup Commands:
    --------------------------------------------------------------------------------
    if deps.fcpxCmds then
        deps.fcpxCmds:add("cpShowProjectTimecodeTop")
            :groupedBy("hacks")
            :whenActivated(function() toggle(3) end)

        deps.fcpxCmds:add("cpShowProjectTimecodeBottom")
            :groupedBy("hacks")
            :whenActivated(function() toggle(4) end)

        deps.fcpxCmds:add("cpShowSourceTimecodeTop")
            :groupedBy("hacks")
            :whenActivated(function() toggle(1) end)

        deps.fcpxCmds:add("cpShowSourceTimecodeBottom")
            :groupedBy("hacks")
            :whenActivated(function() toggle(2) end)
    end

    return mod
end

return plugin