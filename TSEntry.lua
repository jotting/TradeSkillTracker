--	local entry = {
--		requiredSkill = nil,
--		number = nil,
--		reagent = nil,
--		skillLevel = nil,
--		craftable = nil
--	}
TSEntry = {}
TSEntry.__index = TSEntry

function TSEntry.create()
	local entry = {}
	setmetatable(entry, TSEntry)
	entry.requiredSkill = nil
	entry.count = nil
	entry.reagent = nil
	entry.skillLevel = nil
	entry.craftable = nil

	return entry
end

function TSEntry:setRequiredSkill(skill)
	self.requiredSkill = skill
	return self
end

function TSEntry:setCount(count)
	self.count = count
	return self
end

function TSEntry:setReagent(reagent)
	self.reagent = reagent
	return self
end

function TSEntry:setSkillLevel(level)
	self.skillLevel = level
	return self
end

function TSEntry:setCraftable(item)
	self.craftable = item
	return self
end
