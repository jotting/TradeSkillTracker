require 'tradeSkillTracker'
require 'stringConstants'
EventProcessor = {}

function EventProcessor:CHAT_MSG_SKILL(message)
	--"You have gained the %s skill."; -- %s is the skill name
	local beginMatch, endMatch, skill = string.find(message, TST_GAIN_A_SKILL)
	if (beginMatch) then
		TSTracker:onTrained(skill)
		return
	end

    --"Your skill in %s has increased to %d."; -- %s is the skill name, %d is the new rank
	local beginMatch, endMatch, skill, rank = string.find(message, TST_GAIN_SKILL_RANK)
	if (beginMatch) then
		TSTracker:onSkillUp(skill, rank)
		return
	end
end

function EventProcessor:CHAT_MSG_LOOT(message)
	-- You receive loot: [Heavy Leather]
	local _, _, itemLink = string.find(message, TST_RECEIVE_LOOT)
	if not itemLink then
		-- You receive item: [Warlords Deck]
		_,_,itemLink = string.find(message, TST_RECEIVE_ITEM)
		if not itemLink then
			-- You create: [Copper Bar]
			_,_,itemLink = string.find(message, TST_CREATE_ITEM)
			if not itemLink then
				-- You won [Meaty Bat Wing]
				_,_,itemLink = string.find(message, TST_WON_ITEM)
				if not itemLink then
					return end
			end
		end
	end

	local _,_,itemName = string.find(itemLink, '|h%[(.+)%]|h')
	TSTracker:onAcquired(itemName)
end
