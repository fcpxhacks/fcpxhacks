--- === plugins.finalcutpro.advanced.showtimelineinviewers ===
---
--- Show Timeline In Player.

local require   = require

local fcp       = require "cp.apple.finalcutpro"
local i18n      = require "cp.i18n"

local semver    = require "semver"

local mod = {}

--- plugins.finalcutpro.advanced.showtimelineinviewers.enabled <cp.prop: boolean; live>
--- Constant
--- Show Timeline in Player Enabled?
mod.enabled = fcp.preferences:prop("FFPlayerDisplayedTimeline", 0):mutate(
    function(original) return original() == 1 end,
    function(newValue, original) original(newValue and 1 or 0) end
)

local plugin = {
    id              = "finalcutpro.advanced.showtimelineinviewers",
    group           = "finalcutpro",
    dependencies    = {
        ["finalcutpro.commands"]        = "fcpxCmds",
        ["finalcutpro.preferences.manager"] = "prefs",
    }
}

function plugin.init(deps)
    --------------------------------------------------------------------------------
    -- Only load plugin if FCPX is supported:
    --------------------------------------------------------------------------------
    if not fcp:isSupported() then return end

    --------------------------------------------------------------------------------
    -- Sadly, this feature stopped working in 10.4.9:
    --------------------------------------------------------------------------------
    if fcp.version() <= semver("10.4.8") then
        --------------------------------------------------------------------------------
        -- Setup Menubar Preferences Panel:
        --------------------------------------------------------------------------------
        local panel = deps.prefs.panel
        if panel then
            panel
                :addCheckbox(2204.2,
                {
                    label = i18n("showTimelineInViewers"),
                    onchange = function(_, params) mod.enabled(params.checked) end,
                    checked = function() return mod.enabled() end,
                })
        end

        --------------------------------------------------------------------------------
        -- Setup Commands:
        --------------------------------------------------------------------------------
        deps.fcpxCmds
            :add("cpShowTimelineInViewers")
            :whenActivated(function() mod.enabled:toggle() end)
    end
    return mod
end

return plugin
