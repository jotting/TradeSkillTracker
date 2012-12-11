require 'tradeSkillTracker'
require 'Player'
local player = Player.create()

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
			for k,v in pairs(player) do
				if k == "items" then
					print("items:")
					for k2, v2 in pairs(v) do
						print(k2,v2.count)
					end
				else
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
	player:trainSkill(skill)

	if player.skill1.name == skill then
		player.skill1.training = training
	elseif player.skill2.name == skill then
		player.skill2.training = training
	end
	print("trained: "..training.." "..skill)

	--TSTracker:onTrained(skill)
end

function skillUp(amount, skill)
	if amount == nil or amount == "" then amount = 1 end
	if skill == nil or skill == "" then 
		if player.skill1 == nil then return
		else skill = player.skill1.name end
	end

	if skill == player.skill1.name then
		player.skill1.level = player.skill1.level + amount
	elseif player.skill2 ~= nil and skill == player.skill2.name then
		player.skill2.level = player.skill2.level + amount
	end
	print(skill.." +"..tostring(amount))

	--TSTracker:onSkillUp(player.skill)
end

function item(amount, item)
	if item == nil or item == "" or amount == nil or amount == "" then return end
	amount = tonumber(amount)
	if amount == 0 then
		player.items[item] = nil
	else
		if player.items[item] == nil then
			player.items[item] = {count = 0}
		end

		player.items[item].count = amount
	end
	print(amount.." "..item.."(s) now owned.")

	--TSTracker:onAcquired(item)
end

-- Run the program
main()
