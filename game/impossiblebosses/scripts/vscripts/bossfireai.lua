if bossfireai == nil then
  bossfireai = class({})
end

FIRE_BOSS = nil

-- this is to reset the boss when all players die and game resets, currently disabled as all players dying results in a loss
function bossfireai:KillBoss()
if FIRE_BOSS ~= nil then
FIRE_BOSS:ForceKill(false)
FIRE_BOSS = nil
print("killed")
else
print("fire check")
end
end



function bossfireai:StartBossFire()
local spawnLocation = Entities:FindByName( nil, "npc_dota_fireplacer" )
local entVision = CreateUnitByName( "npc_firevision", spawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
entVision:AddNewModifier(entVision, nil, "modifier_invulnerable", nil)
entVision:AddNewModifier(entVision, nil, "modifier_invisible", nil)

self:TeleportPlayers()
end

-- boss' introduction
function bossfireai:BossIntro()
	local spawnLocation = Entities:FindByName( nil, "npc_dota_fireplacer" )
	local fireboss = CreateUnitByName( "npc_fireboss", spawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
		fireboss:SetMana(0)
		fireboss:AddNewModifier(fireboss, nil, "modifier_phased", nil)
		fireboss:AddNewModifier(fireboss, nil, "modifier_invulnerable", nil)
		fireboss:AddNewModifier(fireboss, nil, "modifier_silence", nil)
		fireboss:AddNewModifier(fireboss, nil, "modifier_disarmed", nil)
		fireboss:AddNewModifier(fireboss, nil, "modifier_rooted", nil)
		FIRE_BOSS = fireboss
		firebossid = fireboss:GetEntityIndex()
		CustomGameEventManager:Send_ServerToAllClients("display_health", {msg="Remaining", duration=10, mode=0, endfade=false, position=0, warning=firebossid, paused=false, sound=true} )
		self:RemoveModifiers()
	local ability = fireboss:FindAbilityByName("fireattack")
	if ability then
		-- this makes his autoattack dodgable
	ability:ToggleAutoCast() 
	print("upgradedability")
end
	fireboss:AddSpeechBubble(1, "You want to pick a fight with me... You're toast!!", 6, 0, 0) 
	FindClearSpaceForUnit(fireboss, spawnLocation:GetAbsOrigin(), true)
		fireboss:EmitSound("warlock_golem_wargol_laugh_12")
end

function bossfireai:RemoveModifiers()
	Timers:CreateTimer(5, function()
		FIRE_BOSS:RemoveModifierByName("modifier_phased")
		FIRE_BOSS:RemoveModifierByName("modifier_invulnerable")
		FIRE_BOSS:RemoveModifierByName("modifier_silence")
		FIRE_BOSS:RemoveModifierByName("modifier_disarmed")
		FIRE_BOSS:RemoveModifierByName("modifier_rooted")
		self:Think()
	end)
end

function bossfireai:TeleportPlayers()
local dummy = Entities:FindByName( nil, "npc_dota_dummy" )
dummyloc = dummy:GetAbsOrigin()
if dummyloc == nil then print("dum")
	else print("entityfound")
end

Timers:CreateTimer(0.03, function()
  for i = 0, HeroList:GetHeroCount()-1 do -- so we can teleport DC'ers aswell
    local player = PlayerResource:GetPlayer(i)
    
      local hero = HeroList:GetHero( i )
        
        	
        hero:SetAbsOrigin(dummyloc)
        FindClearSpaceForUnit(hero, dummyloc, true)

        if player ~= nil then 
        	PlayerResource:SetCameraTarget(i, dummy)
        end
  end

 Timers:CreateTimer(2, function()
        self:BossIntro()
      DebugPrint("Initiating boss")
    end)
end)

 Timers:CreateTimer(0.8, function()
 	for i=0, DOTA_MAX_PLAYERS-1  do
    local playerid = PlayerResource:GetPlayer(i)
    if playerid ~= nil then 
    	PlayerResource:SetCameraTarget(i, nil) -- Remove Camera Lock
    end
	end
  end)
end

-- the main loop of the boss. Each second boss can cast a spell if its off cooldown, or random number is given
function bossfireai:Think()

	

	local bosstime = 0

	Timers:CreateTimer(0.03, function()

		
		bosstime = bosstime + 1
		print("debug: bosstime " ..bosstime)
		

		if FIRE_BOSS ~= nil then
		if not FIRE_BOSS:IsAlive() then

			
			 ImpossibleBosses:TeleportHome()
			 GameRules:SendCustomMessage("BOSS COMPLETE TIME: "..COLOR_BLUE .." ".. bosstime, DOTA_TEAM_NOTEAM, 0)
			 FIRE_BOSS = nil

			--TODO: teleport heroes to base
			else
				self:Turbine()
				self:Flamestrike()

				if FIRE_BOSS:GetManaPercent() == 100 then
					self:Ultimate()
				end

				if FIRE_BOSS:GetHealthPercent() <= 20 then
					FIRE_BOSS:SetBaseManaRegen(40)
				end					
		end
		return 1
		end
	end)
end

function bossfireai:Turbine()
	if FIRE_BOSS ~= nil then
	local flameturbine = FIRE_BOSS:FindAbilityByName("flameturbine")
	local boss = FIRE_BOSS
	local randDelay = RandomInt(1,6)
	local randPoint = 
      {
      "npc_dota_dummy",
      "npc_dota_dummy1",
      "npc_dota_dummy2",
      "npc_dota_dummy3",
      }

	if flameturbine:IsCooldownReady() then
		Timers:CreateTimer(randDelay, function()
			boss:CastAbilityImmediately(flameturbine, -1)
			local r = randPoint[RandomInt(1,#randPoint)]
			local rpos = Entities:FindByName(nil, r)
			if FIRE_BOSS ~= nil then
			FIRE_BOSS:MoveToPosition(rpos:GetAbsOrigin())
		    end
			end)
		end
	end
end

function bossfireai:Erupt()
	if FIRE_BOSS ~= nil then
	-- Spawns volcanoes
local volc = Entities:FindByName(nil, "npc_volcano")
	if volc == nil then
		print("null")
else

local eruption1 = volc:FindAbilityByName("flameburst")
	if eruption1:IsCooldownReady() then
		if not FIRE_BOSS:IsAlive() then
		volc:ForceKill(true)
		print("Death!!!")
		else
			print("megoboom")
		volc:CastAbilityNoTarget(eruption1, -1)
		end
	end
end
end

end

function bossfireai:Ultimate()
	if FIRE_BOSS ~= nil then
	FIRE_BOSS.Ultimate = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, FIRE_BOSS)
	FIRE_BOSS:EmitSound("General.LevelUp")
	local flamestrike = FIRE_BOSS:FindAbilityByName("flamestrike")
	FIRE_BOSS:SetMana(0)
	FIRE_BOSS:AddSpeechBubble(1, "Let the flames consume you...", 3, 0, 0) 
	FIRE_BOSS:AddNewModifier(FIRE_BOSS, nil, "modifier_rooted", nil)
-- We are going to make giant spiral of flamestrikes for his ultimate
	local origin = FIRE_BOSS:GetAbsOrigin()
	local forwardV = FIRE_BOSS:GetForwardVector()
	local angNum = -180
	local distance = 300

	Timers:CreateTimer(0.03, function()
	--spiral timer
	local angle = QAngle(0, angNum, 0)
	local flameradius = origin + forwardV * distance
	local flameradius1  = RotatePosition(origin, angle, flameradius)
	FIRE_BOSS:CastAbilityOnPosition(flameradius1, flamestrike, -1)
	angNum = angNum + 8
	distance = distance + 8

	if distance <= 1200 then
		return 0.03
	else
		Timers:CreateTimer(2, function()
		FIRE_BOSS:RemoveModifierByName("modifier_rooted")
		end)
	end
	end)

end
end


function bossfireai:Flamestrike()
	if FIRE_BOSS ~= nil then
local flamestrike = FIRE_BOSS:FindAbilityByName("flamestrike")
local eruption = FIRE_BOSS:FindAbilityByName("eruption")
local flameburst = FIRE_BOSS:FindAbilityByName("flameburst")
local boss = FIRE_BOSS

local random = RandomInt(0, 25)
          local randomH = PlayerResource:GetPlayer(random)
          	if randomH ~= nil then
          		local heroR = randomH:GetAssignedHero()
          			if heroR:IsAlive() and heroR ~= nil then
          				boss:CastAbilityOnPosition(heroR:GetAbsOrigin(), flamestrike, -1)
          			end
          	end

local randomexplode = RandomInt(0, 30)

if randomexplode == 4 then
	--print("commencing massive fire")
	local origin = boss:GetAbsOrigin()
	local forwardV = boss:GetForwardVector()
	local distance = 300
	local ang = QAngle(0, -180, 0)
	local ang_0 = QAngle(0, -135, 0)
	local ang_1 = QAngle(0, -90, 0)
	local ang_2 = QAngle(0, -45, 0)
	local ang_3 = QAngle(0, 45, 0)
	local ang_4 = QAngle(0, 90, 0)
	local ang_5 = QAngle(0, 135, 0)
	local ang_6 = QAngle(0, 180, 0)

	local flameradius1 = origin + forwardV * distance
	local flameradius  = RotatePosition(origin, ang, flameradius1)
	local flameradius0 = RotatePosition(origin, ang_0, flameradius1)
	local flameradius2 = RotatePosition(origin, ang_1, flameradius1)
	local flameradius3 = RotatePosition(origin, ang_2, flameradius1)
	local flameradius4 = RotatePosition(origin, ang_3, flameradius1)
	local flameradius5 = RotatePosition(origin, ang_4, flameradius1)
	local flameradius6 = RotatePosition(origin, ang_5, flameradius1)
	local flameradius7 = RotatePosition(origin, ang_6, flameradius1)

		Timers:CreateTimer(0.03, function()
			boss:CastAbilityOnPosition(flameradius, flamestrike, -1)

				Timers:CreateTimer(0.06, function()
					boss:CastAbilityOnPosition(flameradius0, flamestrike, -1)

						Timers:CreateTimer(0.09, function()
							boss:CastAbilityOnPosition(flameradius1, flamestrike, -1)

								Timers:CreateTimer(0.12, function()
									boss:CastAbilityOnPosition(flameradius2, flamestrike, -1)

										Timers:CreateTimer(0.15, function()
											boss:CastAbilityOnPosition(flameradius3, flamestrike, -1)

												Timers:CreateTimer(0.18, function()
													boss:CastAbilityOnPosition(flameradius4, flamestrike, -1)

														Timers:CreateTimer(0.21, function()
															boss:CastAbilityOnPosition(flameradius5, flamestrike, -1)

																Timers:CreateTimer(0.24, function()
																	boss:CastAbilityOnPosition(flameradius6, flamestrike, -1)

																		Timers:CreateTimer(0.27, function()
																			boss:CastAbilityOnPosition(flameradius7, flamestrike, -1)
																		end)
																end)
														end)
												end)
										end)
								end)
						end)
				end)
		end)	
end

if randomexplode == 29 then
		print("Building Volcano")
		local randPoint = 
      {
      "npc_dota_dummy",
      "npc_dota_dummy1",
      "npc_dota_dummy2",
      "npc_dota_dummy3",
      }

			local r = randPoint[RandomInt(1,#randPoint)]
			local rpos = Entities:FindByName(nil, r)
		boss:CastAbilityOnPosition(rpos:GetAbsOrigin(), eruption, -1)

		Timers:CreateTimer(1, function()
		--self:Eruption()
		end)
	end

if randomexplode == 12 or 8 or 3  and flameburst:IsCooldownReady() then
	boss:CastAbilityNoTarget(flameburst, -1)
	
if randomexplode == 2 then
	self:Erupt()
end
end
end
end
