-- TinyBags core
TinyBags = LibStub("AceAddon-3.0"):NewAddon("TinyBags", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")

-- Addon lifecycle
function TinyBags:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("TinyBagsDB")
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
end

function TinyBags:CloseBag(bagNum)
    self:Print("CloseBag called with `bagNum`: " .. bagNum)
end

function TinyBags:ToggleBag(bagNum)
    self:Print("ToggleBag called with `bagNum`: " .. bagNum)
end

function TinyBags:ToggleBackpack()
    self:Print("ToggleBackpack called.")
end

function TinyBags:ToggleAllBags()
    self:Print("ToggleAllBags called.")
end

-- Event handlers
function TinyBags:HandleOpenBags(eventName, ...)
    self:Print(eventName .. "fired, should open bags.")
end

function TinyBags:HandleCloseBags(eventName, ...)
    self:Print(eventName .. "fired, should close bags.")
end