require 'player'
require 'eventProcessor'

TestUtils = {}

function TestUtils:trained(training, skill)
	if training == nil or skill == nil then return end
	Player:trainSkill(skill)

	if Player.skill1.name == skill then
		Player.skill1.training = training
	elseif Player.skill2.name == skill then
		Player.skill2.training = training
	end

	local message = "You have gained the "..training.." "..skill.." skill."
	print(message)

	EventProcessor:CHAT_MSG_SKILL(message)
end

function TestUtils:skillUp(amount, skill)
	if amount == nil or amount == "" then amount = 1 end
	if skill == nil or skill == "" then 
		if Player.skill1 == nil then return
		else skill = Player.skill1.name end
	end

	local rank = 0
	if skill == Player.skill1.name then
		Player.skill1.level = Player.skill1.level + amount
		rank = Player.skill1.level
	elseif Player.skill2 ~= nil and skill == Player.skill2.name then
		Player.skill2.level = Player.skill2.level + amount
		rank = Player.skill2.level
	end

	local message = "Your skill in "..skill.." has increased to "..rank.."."
	print(message)

	EventProcessor:CHAT_MSG_SKILL(message)
end

function TestUtils:item(amount, item, from)
	if item == nil or item == "" or amount == nil or amount == "" then return end
	amount = tonumber(amount)
	if amount == 0 then
		Player.items[item] = nil
	else
		if Player.items[item] == nil then
			Player.items[item] = {count = 0}
			local _,_,string_id = string.find(tostring(Player.items[item]), ": (.*)$")
			local id = tonumber(string_id, 16)
			Player.items[item].id = id
		end

		Player.items[item].count = amount
	end

	local id = Player.items[item].id

	local message = "You "..from..": |Hitem:"..id..":0:0|h["..item.."]|h."
	print(message)
	EventProcessor:CHAT_MSG_LOOT(message)
end
