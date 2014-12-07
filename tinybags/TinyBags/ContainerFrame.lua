TinyBags = LibStub("AceAddon-3.0"):GetAddon("TinyBags")

-- Container registry
CONTAINERS = {}

-- Container pool for reuse
CONTAINER_POOL = {}

-- TinyBags container frame
local ContainerFrame = CreateFrame("Button")
ContainerFrame.__index = ContainerFrame
ContainerFrame.class = "ContainerFrame"

function ContainerFrame.Spawn(name)
	local container = tremove(CONTAINER_POOL)
	
	if not container then
		container = setmetatable(CreateFrame("Button"), ContainerFrame)
		
		-- Handle events automatically
		container:SetScript("OnEvent", function(self, eventName, ...)
			return self[eventName](self, eventName, ...)
		end)
	end
	
	-- Store the `name` as a property for future reference
	container.name = name
	
	-- Store the container in the registry
	CONTAINERS[name] = container
	
	return container
end

function ContainerFrame.Get(name)
	local container = CONTAINERS[name]
	
	if not container then
		return nil
	end
	
	return container
end

function ContainerFrame:Remove()
	local container = CONTAINERS[self.name]
	
	if not container then
		return
	end
	
	-- Hide container first
	self:Hide()
	
	-- Remove the `name` property
	self.name = nil
	
	-- Insert into container pool
	tinsert(CONTAINER_POOL, self)
	
	-- Remove from registry
	tremove(CONTAINERS, self.name)
end

function ContainerFrame.Extend(factory)
	local meta = {__index = setmetatable(factory, {__index = self})}
	
	return setmetatable({}, meta)
end

-- Append to root namespace
TinyBags.ContainerFrame = ContainerFrame