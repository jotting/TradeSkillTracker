require 'TSEntry'
TSTracker = {skillPath=nil}

function TSTracker:updateSkillPath()
	local index = self.skillPath.current
	local entry = self.skillPath[index]

--	local entry = {
--		requiredSkill = nil,
--		number = nil,
--		reagent = nil,
--		skillLevel = nil,
--		craftable = nil
--	}
	local gotoNext = false
	if entry.requiredSkill ~= nil and entry.requiredSkill == Player.skill then
		gotoNext = true
	elseif entry.reagent ~= nil and Player.items[entry.reagent] ~= nil
		and entry.count <= Player.items[entry.reagent].count then
		gotoNext = true
	elseif entry.craftable ~= nil and entry.skillLevel <= Player.skillLevel then
		gotoNext = true
	end

	if gotoNext then
		self.skillPath.current = self.skillPath.current + 1
		TSTracker:updateSkillPath()
	else
		TSTracker:updateWindow()
	end
end

function TSTracker:updateWindow()
	print("-----")
	local index = self.skillPath.current
	local entry = self.skillPath[index]
	for k,v in pairs(entry) do print(k, v) end
end

function TSTracker:onTrained(skillName)
	if self.skillPath == nil then return end

	local i = self.skillPath.current
	local requiredSkill = self.skillPath[i].requiredSkill
	if requiredSkill ~= nil and requiredSkill == skillName then
		TSTracker:updateSkillPath()
	end
end

function TSTracker:onSkillUp(skill, currentLevel)
	if self.skillPath == nil or self.skillPath.skill ~= skill then return end

	local i = self.skillPath.current
	local skillLevel = self.skillPath[i].skillLevel
	if skillLevel ~= nil and skillLevel <= currentLevel then
		TSTracker:updateSkillPath()
	end
end

function TSTracker:onAcquired(acquiredItem)
	if self.skillPath == nil then return end

	local i = self.skillPath.current
	local entry = self.skillPath[i]
	if entry.reagent ~= nil and entry.reagent == acquiredItem
		and entry.count ~= nil and Player.items[acquiredItem] ~= nil then
		local itemCount = Player.items[acquiredItem].count
		if entry.count <= itemCount then
			TSTracker:updateSkillPath()
		else
			print(entry.count.." / "..itemCount.." - "..entry.reagent)
		end
	end
end

function TSTracker:processFile(filename)
	local skillFile = assert(io.open(filename, "r"), "Unable to open file")
	local entries = {current = 1, skill=filename}
	-- Process the file
	for line in skillFile:lines() do
		local entry = self:processLine(line)
		if entry ~= nil then
			table.insert(entries, entry)
		end
	end
	skillFile:close()

	self.skillPath = entries
end

function TSTracker:processLine(line)
	local entry = TSEntry.create()

	-- @Require
	local i,j,skill = string.find(line, "^@Require (.*)")
	if i ~= nil then
		return entry:setRequiredSkill(skill)
	end

	-- @Reagent
	local i,j,number,reagent = string.find(line, "^@Reagent %(?(%d*)%)? ?(.*)")
	if i ~= nil then
		if number == nil or number == "" then number = "1" end
		return entry:setCount(tonumber(number)):setReagent(reagent)
	end

	-- Craftable
	local i,j,number,items = string.find(line, "^(%d+) (.*)")
	if i ~= nil then
		return entry:setSkillLevel(number):setCraftable(items)
	end
end

