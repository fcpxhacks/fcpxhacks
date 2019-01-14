--- === cp.apple.finalcutpro.timeline.Appearance ===
---
--- Timeline Appearance Module.

--------------------------------------------------------------------------------
--
-- EXTENSIONS:
--
--------------------------------------------------------------------------------
local require = require

--------------------------------------------------------------------------------
-- CommandPost Extensions:
--------------------------------------------------------------------------------
local just								= require("cp.just")
local prop								= require("cp.prop")
local axutils							= require("cp.ui.axutils")

local CheckBox					        = require("cp.ui.CheckBox")
local Slider							= require("cp.ui.Slider")

--------------------------------------------------------------------------------
-- Local Lua Functions:
--------------------------------------------------------------------------------
local cache                             = axutils.cache
local childFromRight                    = axutils.childFromRight
local childFromTop                      = axutils.childFromTop
local childMatching                     = axutils.childMatching

--------------------------------------------------------------------------------
--
-- THE MODULE:
--
--------------------------------------------------------------------------------
local Appearance = {}

--- cp.apple.finalcutpro.timeline.Appearance.matches(element) -> boolean
--- Function
--- Checks to see if an element matches what we think it should be.
---
--- Parameters:
---  * element - An `axuielementObject` to check.
---
--- Returns:
---  * `true` if matches otherwise `false`
function Appearance.matches(element)
    return element and element:attributeValue("AXRole") == "AXPopover"
end

--- cp.apple.finalcutpro.timeline.Appearance.new(app) -> Appearance
--- Constructor
--- Creates a new `Appearance` instance.
---
--- Parameters:
---  * parent - The parent object.
---
--- Returns:
---  * A new `Appearance` object.
function Appearance.new(parent)
    local o = prop.extend({_parent = parent}, Appearance)
    return o
end

--- cp.apple.finalcutpro.timeline.Appearance:parent() -> parent
--- Method
--- Returns the parent object.
---
--- Parameters:
---  * None
---
--- Returns:
---  * parent
function Appearance:parent()
    return self._parent
end

--- cp.apple.finalcutpro.timeline.Appearance:app() -> App
--- Method
--- Returns the app instance representing Final Cut Pro.
---
--- Parameters:
---  * None
---
--- Returns:
---  * App
function Appearance:app()
    return self:parent():app()
end

-----------------------------------------------------------------------
--
-- APPEARANCE POPOVER UI:
--
-----------------------------------------------------------------------

--- cp.apple.finalcutpro.timeline.Appearance:toggleUI() -> axuielementObject
--- Method
--- Gets the Toggle UI.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A `axuielementObject` object.
function Appearance:toggleUI()
    return cache(self, "_toggleUI", function()
        return childFromRight(self:parent():UI(), 1, function(element)
            return element:attributeValue("AXRole") == "AXCheckBox"
        end)
    end)
end

--- cp.apple.finalcutpro.timeline.Appearance:toggle() -> CheckBox
--- Method
--- Gets the Timeline Appearance CheckBox.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A `axuielementObject` object.
function Appearance:toggle()
    if not self._toggle then
        self._toggle = CheckBox(self:parent(), function()
            return self:toggleUI()
        end)
    end
    return self._toggle
end

--- cp.apple.finalcutpro.timeline.Appearance:UI() -> axuielementObject
--- Method
--- Gets the Timeline Appearance UI.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A `axuielementObject` object.
function Appearance:UI()
    return cache(self, "_ui", function()
        return childMatching(self:toggleUI(), Appearance.matches)
    end,
    Appearance.matches)
end

--- cp.apple.finalcutpro.timeline.Appearance.isShowing <cp.prop: boolean>
--- Variable
--- Is the Timeline Appearance popup showing?
Appearance.isShowing = prop.new(function(self)
    return self:UI() ~= nil
end):bind(Appearance)

--- cp.apple.finalcutpro.timeline.Appearance:UI() -> Appearance
--- Method
--- Show the Timeline Appearance popup.
---
--- Parameters:
---  * None
---
--- Returns:
---  * The `Appearance` object.
function Appearance:show()
    if not self:isShowing() then
        self:toggle():checked(true)
    end
    return self
end

--- cp.apple.finalcutpro.timeline.Appearance:UI() -> Appearance
--- Method
--- Hide the Timeline Appearance popup.
---
--- Parameters:
---  * None
---
--- Returns:
---  * The `Appearance` object.
function Appearance:hide()
    local ui = self:UI()
    if ui then
        ui:doCancel()
    end
    just.doWhile(function() return self:isShowing() end)
    return self
end

-----------------------------------------------------------------------
--
-- THE BUTTONS:
--
-----------------------------------------------------------------------

--- cp.apple.finalcutpro.timeline.Appearance:clipHeight() -> Slider
--- Method
--- Get the Clip Height Slider.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A `Slider` object.
function Appearance:clipHeight()
    if not self._clipHeight then
        self._clipHeight = Slider(self, function()
            return childMatching(self:UI(), function(e)
                return e:attributeValue("AXRole") == "AXSlider" and e:attributeValue("AXMaxValue") == 210
            end)
        end)
    end
    return self._clipHeight
end

--- cp.apple.finalcutpro.timeline.Appearance:zoomAmount() -> Slider
--- Method
--- Get the Zoom Slider.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A `Slider` object.
function Appearance:zoomAmount()
    if not self._zoomAmount then
        self._zoomAmount = Slider(self, function()
            return childFromTop(self:UI(), 1, function(element)
                return element:attributeValue("AXRole") == "AXSlider"
            end)
        end)
    end
    return self._zoomAmount
end

return Appearance