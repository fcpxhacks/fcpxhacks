--- === cp.ui.Group ===
---
--- UI Group.

--------------------------------------------------------------------------------
--
-- EXTENSIONS:
--
--------------------------------------------------------------------------------
local require = require

--------------------------------------------------------------------------------
-- CommandPost Extensions:
--------------------------------------------------------------------------------
local Element           = require("cp.ui.Element")

--------------------------------------------------------------------------------
--
-- THE MODULE:
--
--------------------------------------------------------------------------------
local Group = Element:subtype()

--- cp.ui.Group.matches(element) -> boolean
--- Function
--- Checks to see if an element matches what we think it should be.
---
--- Parameters:
---  * element - An `axuielementObject` to check.
---
--- Returns:
---  * `true` if matches otherwise `false`
function Group.matches(element)
    return Element.matches(element) and element:attributeValue("AXRole") == "AXGroup"
end

--- cp.ui.Group.new(parent, uiFinder) -> Alert
--- Constructor
--- Creates a new `Group` instance.
---
--- Parameters:
---  * parent - The parent object.
---  * uiFinder - A function which will return the `hs._asm.axuielement` when available.
---
--- Returns:
---  * A new `Group` object.
function Group.new(parent, uiFinder)
    local o = Element.new(parent, uiFinder, Group)
    return o
end

return Group
