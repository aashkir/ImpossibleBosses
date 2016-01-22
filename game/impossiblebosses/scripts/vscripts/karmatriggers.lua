function tpplayer( trigger )
local hero = trigger.activator
local player = hero:GetPlayerID()
local randPoint = 
      {
      "npc_dota_tp1",
      "npc_dota_tp2",
      "npc_dota_tp3",
      "npc_dota_tp4",
      }

local r = randPoint[RandomInt(1,#randPoint)]

local point = Entities:FindByName( nil, r):GetAbsOrigin()
hero:SetAbsOrigin(point)
FindClearSpaceForUnit(hero, point, false)
hero:Stop()
SendToConsole("dota_camera_center")
end

function speedbuff( trigger )
local hero = trigger.activator
local player = hero:GetPlayerID()
local karmacount = hero:GetModifierStackCount("tome_karma_modifier", hero)
if karmacount  >= 1 then
	hero:AddItemByName("item_speed") 
	hero:SetModifierStackCount("tome_karma_modifier", hero, (hero:GetModifierStackCount("tome_karma_modifier", hero) - 1))
	hero:CalculateStatBonus()
	Notifications:Top(player, {text="Upgraded Movement Speed!", duration=3, style={color="green"}, continue=true})
else
	print("Nil")
	Notifications:Top(player, {text="Not enough Karma points!", duration=3, style={color="red"}, continue=true})
	end
end

function healthbuff( trigger )
local hero = trigger.activator
local player = hero:GetPlayerID()
local karmacount = hero:GetModifierStackCount("tome_karma_modifier", hero)
if karmacount  >= 1 then
	hero:AddItemByName("item_health") 
	hero:SetModifierStackCount("tome_karma_modifier", hero, (hero:GetModifierStackCount("tome_karma_modifier", hero) - 1))
	hero:CalculateStatBonus()
	Notifications:Top(player, {text="Upgraded Health!", duration=3, style={color="green"}, continue=true})
else
	print("Nil")
	Notifications:Top(player, {text="Not enough Karma points!", duration=3, style={color="red"}, continue=true})
	end
end

function manabuff( trigger )
local hero = trigger.activator
local player = hero:GetPlayerID()
local karmacount = hero:GetModifierStackCount("tome_karma_modifier", hero)
if karmacount  >= 1 then
	hero:AddItemByName("item_mana") 
	hero:SetModifierStackCount("tome_karma_modifier", hero, (hero:GetModifierStackCount("tome_karma_modifier", hero) - 1 ))
	Notifications:Top(player, {text="Upgraded Mana!", duration=3, style={color="green"}, continue=true})
	hero:CalculateStatBonus()
else
	print("Nil")
	Notifications:Top(player, {text="Not enough Karma points!", duration=3, style={color="red"}, continue=true})
	end
end

function attackbuff( trigger )
local hero = trigger.activator
local player = hero:GetPlayerID()
local karmacount = hero:GetModifierStackCount("tome_karma_modifier", hero)
if karmacount  >= 1 then
	hero:AddItemByName("item_attack") 
	hero:SetModifierStackCount("tome_karma_modifier", hero, (hero:GetModifierStackCount("tome_karma_modifier", hero) - 1 ))
	Notifications:Top(player, {text="Upgraded Outgoing Damage!", duration=3, style={color="green"}, continue=true})
	hero:CalculateStatBonus()
else
	print("Nil")
	Notifications:Top(player, {text="Not enough Karma points!", duration=3, style={color="red"}, continue=true})
	end
end

