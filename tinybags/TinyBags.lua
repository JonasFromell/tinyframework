-- TinyBags core
TinyBags = LibStub("AceAddon-3.0"):NewAddon("TinyBags", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")

-- Addon lifecycle
function TinyBags:OnInitialize()
    self.db=LibStub("AceDB-3.0"):New("TinyBagsDB")

    -- Initialize main frame
    self.MainFrame = self:Spawn("TinyBagsContainerFrame", function (frame)
        frame:RegisterEvent("BAG_UPDATE") -- Fires when the contents of the bag is updated

        function frame:BAG_UPDATE(...)
            TinyBags:Print("BAG_UPDATE fired with arguments: " .. ...)
        end

        -- Display functions
        frame:SetScript("OnShow", function ()
            self.isShown = true
        end)

        frame:SetScript("OnHide", function ()
            self.isShown = false
        end)

        function frame:Toggle()
            if self.isShown then
                self:Hide()
            else
                self:Show()
            end
        end
    end)
end

function TinyBags:OnEnable()
    -- Stop execution of default behaviours
    self:RawHook("ToggleBag", true)
    self:RawHook("ToggleBackpack", true)
    self:RawHook("ToggleAllBags", true)
    self:RawHook("OpenBag", true)
    self:RawHook("CloseBag", true)
    -- Register custom event handlers
    self:RegisterEvent("MAIL_SHOW", "HandleOpenBags")
    self:RegisterEvent("MAIL_CLOSED", "HandleOpenBags")
    self:RegisterEvent("TRADE_SHOW", "HandleCloseBags")
    self:RegisterEvent("TRADE_CLOSED", "HandleCloseBags")
    self:RegisterEvent("MERCHANT_SHOW", "HandleOpenBags")
    self:RegisterEvent("MERCHANT_CLOSED", "HandleCloseBags")
    self:RegisterEvent("BANKFRAME_OPENED", "HandleOpenBags")
    self:RegisterEvent("BANKFRAME_CLOSED", "HandleCloseBags")
    self:RegisterEvent("AUCTION_HOUSE_SHOW", "HandleOpenBags")
    self:RegisterEvent("AUCTION_HOUSE_CLOSED", "HandleCloseBags")
    self:RegisterEvent("GUILDBANKFRAME_OPENED", "HandleOpenBags")
    self:RegisterEvent("GUILDBANKFRAME_CLOSED", "HandleCloseBags")
end

function TinyBags:OnDisable()
    -- Deregistering events (handled automatically)
end

-- Hook handlers
function TinyBags:OpenBag(bagNum)
    self:Print("OpenBag called with `bagNum`: " .. bagNum)
    self.MainFrame:Show()
end

function TinyBags:CloseBag(bagNum)
    self:Print("CloseBag called with `bagNum`: " .. bagNum)
    self.MainFrame:Hide()
end

function TinyBags:ToggleBag(bagNum)
    self:Print("ToggleBag called with `bagNum`: " .. bagNum)
    self.MainFrame:Toggle();
end

function TinyBags:ToggleBackpack()
    self:Print("ToggleBackpack called.")
    self.MainFrame:Toggle();
end

function TinyBags:ToggleAllBags()
    self:Print("ToggleAllBags called.")
    self.MainFrame:Toggle();
end

-- Event handlers
function TinyBags:HandleOpenBags(eventName, ...)
    self:Print(eventName .. "fired, should open bags.")
    self:OpenBag(0) -- Opens all bags
end

function TinyBags:HandleCloseBags(eventName, ...)
    self:Print(eventName .. "fired, should close bags.")
    self:CloseBag(0) -- Closes all bags
end

-- Utility functions
function TinyBags:Spawn(name, factory)
    local frame = CreateFrame('Frame', name)

    -- Handle any registered events
    frame:SetScript('OnEvent', function(self, event, ...)
        return self[event](self, event, ...)
    end)

    -- Run the `factory` method, passing the created `frame`
    factory(frame)

    -- Return the created frame
    return frame
end

local BAGS = {}

-- Carried bags
for i = 1, NUM_BAG_SLOTS do
    BAGS[i] = i
end
BAGS[BACKPACK_CONTAINER]=BACKPACK_CONTAINER

function TinyBags:IterateBags()
    return function(tab, current)
        current = next(tab, current)
        while current do
            local free, family = GetContainerNumFreeSlots(current)
            if family == 0 then
                return current
            end
            current = next(tab, current)
        end
    end
end