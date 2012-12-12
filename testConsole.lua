require 'test'
require 'tradeSkillTracker'
require 'player'
require 'eventProcessor'

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
			TestUtils:trained(argument, argument2)
		elseif command == "skill" then
			TestUtils:skillUp(argument, argument2)
		elseif command == "item" then
			TestUtils:item(argument, argument2, "receive item")
		elseif command == "loot" then
			TestUtils:item(argument, argument2, "receive loot")
		elseif command == "created" then
			TestUtils:item(argument, argument2, "create")
		elseif command == "won" then
			TestUtils:item(argument, argument2, "won")
		elseif command == "ls" then
			TSTracker:updateWindow()
		elseif command == "player" then
			for k,v in pairs(Player) do
				if k == "items" then
					print("items:")
					for k2, v2 in pairs(v) do
						print('\t'..k2,v2.count)
					end
				elseif string.find(k, "^skill") then
					print(k)
					for k2, v2 in pairs(v) do
						print('\t'..k2,v2)
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
			print("  loot [number] [item]")
			print("  created [number] [item]")
			print("  won [number] [item]")
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

-- Run the program
main()
