function main()
	EventFrame.skillPath = processFile("tailoring")
	startConsole()
end

EventFrame = {skillPath=nil}
Player = {skill=nil, skillLevel=1, items={}}

function EventFrame:updateSkillPath()
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
		and entry.number <= Player.items[entry.reagent].count then
		gotoNext = true
	elseif entry.craftable ~= nil and entry.skillLevel <= Player.skillLevel then
		gotoNext = true
	end

	if gotoNext then
		self.skillPath.current = self.skillPath.current + 1
		EventFrame:updateSkillPath()
	else
		EventFrame:updateWindow()
	end
end

function EventFrame:updateWindow()
	print("-----")
	local index = self.skillPath.current
	local entry = self.skillPath[index]
	for k,v in pairs(entry) do print(k, v) end
end

function EventFrame:onTrained(skillName)
	if self.skillPath == nil then return end

	local i = self.skillPath.current
	local requiredSkill = self.skillPath[i].requiredSkill
	if requiredSkill ~= nil and requiredSkill == skillName then
		EventFrame:updateSkillPath()
	end
end

function EventFrame:onSkillUp(skill)
	if self.skillPath == nil or self.skillPath.skill ~= Player.skill then return end

	local i = self.skillPath.current
	local skillLevel = self.skillPath[i].skillLevel
	if skillLevel ~= nil and skillLevel <= Player.skillLevel then
		EventFrame:updateSkillPath()
	end
end

function EventFrame:onAcquired(acquiredItem)
	if self.skillPath == nil then return end

	local i = self.skillPath.current
	local entry = self.skillPath[i]
	if entry.reagent ~= nil and entry.reagent == acquiredItem
		and entry.number ~= nil and Player.items[acquiredItem] ~= nil then
		local itemCount = Player.items[acquiredItem].count
		if entry.number <= itemCount then
			EventFrame:updateSkillPath()
		else
			print(entry.number.." / "..itemCount.." - "..entry.reagent)
		end
	end
end

function processFile(filename)
	local skillFile = assert(io.open(filename, "r"), "Unable to open file")
	local entries = {current = 1, skill=filename}
	-- Process the file
	for line in skillFile:lines() do
		local entry = processLine(line)
		if entry ~= nil then
			table.insert(entries, entry)
		end
	end
	skillFile:close()

	return entries
end

function processLine(line)
	local entry = {
		requiredSkill = nil,
		number = nil,
		reagent = nil,
		skillLevel = nil,
		craftable = nil
	}

	-- @Require
	local i,j,skill = string.find(line, "^@Require (.*)")
	if i ~= nil then
		entry.requiredSkill = skill
		return entry
	end

	-- @Reagent
	local i,j,number,reagent = string.find(line, "^@Reagent %(?(%d*)%)? ?(.*)")
	if i ~= nil then
		if number == nil or number == "" then number = "1" end
		entry.number = tonumber(number)
		entry.reagent = reagent
		return entry
	end

	-- Craftable
	local i,j,number,items = string.find(line, "^(%d+) (.*)")
	if i ~= nil then
		entry.skillLevel = number
		entry.craftable = items

		return entry
	end
end

function startConsole()
	EventFrame:updateSkillPath()
	io.flush()
	local input = ""
	repeat
		local i,j,command,argument,argument2 = string.find(input, "^(%a*) ?(%w*) ?(%w*)")
		if i == nil then
			input = ""
		end

		if string.lower(command) == "train" then
			trained(nil)
		elseif string.lower(input) == "skill" then
			skillUp(argument)
		elseif string.lower(input) == "item" then
			if argument2 == nil then argument2 = 1 end
			itemAcquired(argument, argument2)
		elseif string.lower(input) == "fish" then
			fishingUp()
		end

		io.write("> ")
		io.flush()
		input = io.read()
	until isStop(input)
end

function isStop(input)
	input = string.lower(input)
	if input == "end" or
		input == "exit" or
		input == "stop" then
		return true
	end

	return false
end

function trained(thisSkill)
	if thisSkill == nil then 
		thisSkill = EventFrame.skillPath[EventFrame.skillPath.current].requiredSkill
	end
	if thisSkill == nil then return end
	Player.skill = thisSkill
	print("trained: "..thisSkill)

	EventFrame:onTrained(thisSkill)
end

function skillUp(amount)
	if amount == nil then return end
	Player.skillLevel = Player.skillLevel + amount
	print(Player.skill.." +"..tostring(amount))

	EventFrame:onSkillUp(Player.skill)
end

function fishingUp()
	print("Fishing +"..tostring(amount))

	EventFrame:onSkillUp("Fishing")
end

function itemAcquired(item, amount)
	if item == nil then return end
	if Player.items[item] == nil then
		Player.items[item] = {count = 0}
	end
	Player.items[item].count = Player.items[item].count + amount
	print(amount.." "..item.."(s) acquired.")

	EventFrame:onAcquired(item)
end


main()
