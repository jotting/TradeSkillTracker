Player = {}
Player.__index = Player

function Player.create()
	local player = {}
	setmetatable(player, Player)
	player.skill1 = nil
	player.skill2 = nil
	player.fishing = nil
	player.items = {}

	return player
end

function Player:trainSkill(skill)
	print("Train skill")
	if self.skill1 == nil then
		self.skill1 = Skill.create(skill)
	elseif self.skill2 == nil then
		self.skill2 = Skill.create(skill)
	elseif self.fishing == nil then
		self.fishing = Skill.create("Fishing")
	end
end

function Player:GetItemInfo(id)
	--Get item info by name or id
	--Returns name, link, etc
end

function Player:GetItemCount(itemId, includeBank)
	--Get item info by id, name, or link
	
	--Return count
end

Skill = {}
Skill.__index = Skill

function Skill.create(name)
	local skill = {}
	setmetatable(skill, Skill)
	skill.name = name
	skill.training = "Apprentice"
	skill.level = 1

	return skill
end
