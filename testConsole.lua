require 'tradeSkillTracker'
require 'Player'

function main()
	TSTracker:processFile("tailoring")
	startConsole()
end

function startConsole()
	TSTracker:updateSkillPath()
	io.flush()
	local input = ""
	repeat
		local i,j,command,argument,argument2 = string.find(input, "^(%a*) ?(%w*) ?(.*)")
		if i == nil then
			command = ""
		end
		command = string.lower(command)

		if command == "train" then
			trained(argument, argument2)
		elseif command == "skill" then
			skillUp(argument, argument2)
		elseif command == "item" then
			item(argument, argument2)
		elseif command == "ls" then
			TSTracker:updateWindow()
		elseif command == "player" then
			for k,v in pairs(Player) do
				if k == "items" then
					print("items:")
					for k2, v2 in pairs(v) do
						print(k2,v2.count)
					end
				elseif not type(v) == "function" then
					print(k,v)
				end
			end
		elseif command == "help" then
			print("----")
			print("  train <training level> <skill>")
			print("  skill [number] [skill]")
			print("  item [number] [item]")
			print("  ls")
			print("----")
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

function trained(training, skill)
	if training == nil or skill == nil then return end
	Player:trainSkill(skill)

	if Player.skill1.name == skill then
		Player.skill1.training = training
	elseif Player.skill2.name == skill then
		Player.skill2.training = training
	end
	print("trained: "..training.." "..skill)

	TSTracker:onTrained(skill)
end

function skillUp(amount, skill)
	if amount == nil or amount == "" then amount = 1 end
	if skill == nil or skill == "" then 
		if Player.skill1 == nil then return
		else skill = Player.skill1.name end
	end

	if skill == Player.skill1.name then
		Player.skill1.level = Player.skill1.level + amount
	elseif Player.skill2 ~= nil and skill == Player.skill2.name then
		Player.skill2.level = Player.skill2.level + amount
	end
	print(skill.." +"..tostring(amount))

	TSTracker:onSkillUp(skill, currentLevel)
end

function item(amount, item)
	if item == nil or item == "" or amount == nil or amount == "" then return end
	amount = tonumber(amount)
	if amount == 0 then
		Player.items[item] = nil
	else
		if Player.items[item] == nil then
			Player.items[item] = {count = 0}
		end

		Player.items[item].count = amount
	end
	print(amount.." "..item.."(s) now owned.")

	TSTracker:onAcquired(item)
end

-- Run the program
main()
