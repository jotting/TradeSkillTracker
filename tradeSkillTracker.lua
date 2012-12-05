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
	local i,j,number,items = string.find(line, "^%(?(%d+)%)? (.*)")
	if i ~= nil then
		local isCount = string.find(line, "^%(%d+%)")
		if isCount ~= nil then
			entry.number = tonumber(number)
		else
			entry.skillLevel = number
		end

		entry.craftable = items

		return entry
	end
end

function processFile(filename)
	local skillFile = assert(io.open(filename, "r"), "Unable to open file")
	local entries = {}
	-- Process the file
	for line in skillFile:lines() do
		local entry = processLine(line)
		if entry ~= nil then
			table.insert(entries, entry)
		end
	end
	skillFile:close()

	return lines
end

function isStop(input)
	input = string.lower(input)
	if input == "end" or
		input == "stop" then
		return true
	end

	return false
end

function trained(thisSkill)
	print("trained: "..tostring(thisSkill))
end

function itemCreated(currentItem)
	print("item created: "..tostring(currentItem))
end

function skillUp(thisSkill, amount)
	print("skill up: "..tostring(thisSkill).." +"..tostring(amount))
end

function itemAcquired(reagent1, reagent2)
	print("item acquired: "..tostring(reagent1).." | "..tostring(reagent2))
end

function startConsole()
	io.flush()
	local input = io.read()
	while not isStop(input) do
		if string.lower(input) == "trained" then
			trained(true)
		elseif string.lower(input) == "trained bad" then
			trained(false)
		elseif string.lower(input) == "item" then
			itemCreated(true)
		elseif string.lower(input) == "item bad" then
			itemCreated(false)
		elseif string.lower(input) == "skill" then
			skillUp(true, 1)
		elseif string.lower(input) == "skill 3" then
			skillUp(true, 3)
		elseif string.lower(input) == "skill bad" then
			skillUp(false, 1)
		elseif string.lower(input) == "reagent" then
			itemAcquired(true, false)
		elseif string.lower(input) == "reagent second" then
			itemAcquired(false, true)
		elseif string.lower(input) == "reagent bad" then
			itemAcquired(false, false)
		end

		io.flush()
		input = io.read()
	end
end

skillPath = processFile("tailoring")
startConsole()
