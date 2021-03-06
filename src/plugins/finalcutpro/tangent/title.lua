--- === plugins.finalcutpro.tangent.title ===
---
--- Final Cut Pro Title Inspector for Tangent

local require = require

--local log                   = require("hs.logger").new("tangentTitle")

local fcp                   = require("cp.apple.finalcutpro")
local i18n                  = require("cp.i18n")

local plugin = {
    id = "finalcutpro.tangent.title",
    group = "finalcutpro",
    dependencies = {
        ["finalcutpro.tangent.common"]  = "common",
        ["finalcutpro.tangent.group"]   = "fcpGroup",
    }
}

function plugin.init(deps)
    --------------------------------------------------------------------------------
    -- Only load plugin if Final Cut Pro is supported:
    --------------------------------------------------------------------------------
    if not fcp:isSupported() then return end

    --------------------------------------------------------------------------------
    -- Setup:
    --------------------------------------------------------------------------------
    local id                            = 0x0F790000

    local common                        = deps.common
    local fcpGroup                      = deps.fcpGroup

    local doShowParameter               = common.doShowParameter

    --------------------------------------------------------------------------------
    -- GENERATOR INSPECTOR:
    --------------------------------------------------------------------------------
    local title                     = fcp.inspector.text
    local titleGroup                = fcpGroup:group(i18n("title") .. " " .. i18n("inspector"))

        --------------------------------------------------------------------------------
        -- Show Inspector:
        --------------------------------------------------------------------------------
        doShowParameter(titleGroup, title, id, i18n("show") .. " " .. i18n("inspector"))

end

return plugin
