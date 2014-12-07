-- TinyBags core
TinyBags = LibStub("AceAddon-3.0"):NewAddon("TinyBags", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")

-- Addon lifecycle
function TinyBags:OnInitialize()
    self.db=LibStub("AceDB-3.0"):New("TinyBagsDB")
	
	-- Initialize main frame
	local MainFrame = self.ContainerFrame.Extend({
		isShown = false, -- Flag display state
		
		Toggle = function(self)
			if not self.isShown then
				self:Show()
			else
				self:Hide()
			end
		end,
		
		OnShow = function(self, eventName, ...)
			TinyBags:Print("OnShow called")
			self.isShown = true
		end,
		
		OnHide = function(self, eventName, ...)
			TinyBags:Print("OnHide called")
			self.isShown = false
		end
	})
	
	self.MainFrame = MainFrame.Spawn("TinyBagsMainFrame")
	
	-- TODO: This would look nicer with custom textures
	self.MainFrame:SetBackdrop({bgFile="Interface/Tooltips/UI-Tooltip-Background"})
	self.MainFrame:SetBackdropColor(0, 0, 0, 0.5)
	-- TODO: Is it okay to do this?
	self.MainFrame:SetAllPoints(UIParent)
	
	-- Hidden by default
	self.MainFrame:Hide()
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

local function GetContainerFamily(bag)
	if bag == KEYRING_CONTAINER then
		return 256
	end
	
	local freeslots, family = GetContainerNumFreeSlots(bag)
	
	return family
end

-- Bag iterators
local BAGS = {}

-- Carried bags
for i = 1, NUM_BAG_SLOTS do
    BAGS[i] = i
end
BAGS[BACKPACK_CONTAINER]=BACKPACK_CONTAINER

function iterator(tab, cur)
	cur = next(tab, cur)
	
	while cur do
		if GetContainerFamily(cur) then
			return cur
		end
		
		cur = next(tab, cur)
	end
end

function TinyBags:IterateBags()
    return iterator, BAGS
end

function TinyBags:IterateSlots()
	local bag, slot, currentbagsize = nil, 0, 0
	
	return function()
		while slot >= currentbagsize do
			bag = iterator(BAGS, bag)
			TinyBags:Print(bag)
			if not bag then return nil end
			
			currentbagsize = GetContainerNumSlots(bag) or 0
		end
		
		slot = slot + 1
		return bag, slot, GetContainerItemLink(bag, slot)
	end
end