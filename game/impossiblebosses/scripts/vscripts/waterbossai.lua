if waterbossai == nil then
  waterbossai = class({})
end

WATER_BOSS = nil



function waterbossai:KillBoss()
if WATER_BOSS ~= nil then
WATER_BOSS:ForceKill(false)
WATER_BOSS = nil
print("killed")
else
print("water check")
end
end

function waterbossai:StartBossWater()

	local spawnLocation = Entities:FindByName( nil, "npc_dota_waterplacer" )
  SPAWN_LOCATION1 = spawnLocation
	local entVision = CreateUnitByName( "npc_firevision", spawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
	entVision:AddNewModifier(entVision, nil, "modifier_invulnerable", nil)
	entVision:AddNewModifier(entVision, nil, "modifier_invisible", nil)
	self:TeleportPlayers()
end

function waterbossai:TeleportPlayers()
local dummy = Entities:FindByName( nil, "npc_dota_dummywater" )
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
  for i=0, DOTA_MAX_TEAM_PLAYERS-1  do
    local playerid = PlayerResource:GetPlayer(i)
    if playerid ~= nil then 
      PlayerResource:SetCameraTarget(i, nil) -- Remove Camera Lock
    end
  end
  end)

end


function waterbossai:BossIntro()
  local spawnLocation = Entities:FindByName( nil, "npc_dota_waterplacer" )
  local waterboss = CreateUnitByName( "npc_waterboss", spawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
    waterboss:SetMana(0)
    waterboss:AddNewModifier(waterboss, nil, "modifier_phased", nil)
    waterboss:AddNewModifier(waterboss, nil, "modifier_invulnerable", nil)
    waterboss:AddNewModifier(waterboss, nil, "modifier_silence", nil)
    waterboss:AddNewModifier(waterboss, nil, "modifier_disarmed", nil)
    waterboss:AddNewModifier(waterboss, nil, "modifier_rooted", nil)
    WATER_BOSS = waterboss
    waterbossid = waterboss:GetEntityIndex()
    CustomGameEventManager:Send_ServerToAllClients("display_health", {msg="Remaining", duration=10, mode=0, endfade=false, position=0, warning=waterbossid, paused=false, sound=true} )
    self:RemoveModifiers()

  waterboss:AddSpeechBubble(1, "I am the last thing you'll see.", 6, 0, 0) 
  FindClearSpaceForUnit(waterboss, spawnLocation:GetAbsOrigin(), true)
    waterboss:EmitSound("medusa_medus_cast_03")

    local ability = WATER_BOSS:FindAbilityByName("waterattack")
	if ability then

	ability:ToggleAutoCast() 
	print("upgradedability")
	
end
end

function waterbossai:RemoveModifiers()
  Timers:CreateTimer(5, function()
    WATER_BOSS:RemoveModifierByName("modifier_phased")
    WATER_BOSS:RemoveModifierByName("modifier_invulnerable")
    WATER_BOSS:RemoveModifierByName("modifier_silence")
    WATER_BOSS:RemoveModifierByName("modifier_disarmed")
    --WATER_BOSS:RemoveModifierByName("modifier_rooted")
    self:Think()
    self:SpellThink()
    self:OtherCast()
    USE_WATER = true
    USE_SUB = true
  end)
end

function waterbossai:SpellThink()

Timers:CreateTimer(60, function()

  local randomNum = RandomInt(40, 70)

  self:Waves()

  return randomNum
  end)
end

function waterbossai:Waves()
  if WATER_BOSS ~= nil then
  local waves = SPAWN_LOCATION1:FindAbilityByName("tidal_waves") 

    local origin = SPAWN_LOCATION1:GetAbsOrigin() 

    local angle = RandomInt(-180, 180)
    local anglePos = QAngle(0, angle, 0)
    local forwardV = SPAWN_LOCATION1:GetForwardVector()
    local distance = 1400
    local waveradius = origin + forwardV * distance
    local waveradius1  = RotatePosition(origin, anglePos, waveradius)

print("casting waves")
if WATER_BOSS:IsAlive() then
    SPAWN_LOCATION1:CastAbilityOnPosition(waveradius1, waves, -1)
end
    --SPAWN_LOCATION1:EmitSound(string soundName)
end
end
function waterbossai:Think()
  local bosstime = 0

  Timers:CreateTimer(0.03, function()

    bosstime = bosstime + 1
    print("debug: bosstime " ..bosstime)
    

  if WATER_BOSS ~= nil then
    if not WATER_BOSS:IsAlive() then

       ImpossibleBosses:TeleportHomeWater()
       GameRules:SendCustomMessage("BOSS COMPLETE TIME: "..COLOR_BLUE .." ".. bosstime, DOTA_TEAM_NOTEAM, 0)
       WATER_BOSS = nil
      else

        if WATER_BOSS:GetManaPercent() == 100 then
          --print("ulting")
          self:Ultimate()

          
          end

        self:Cast()
        waterbossai:tornado()
        WATER_BOSS:AddNewModifier(WATER_BOSS, nil, "modifier_rooted", nil)


          
    end
    return 1
    end
  end)
end

function waterbossai:Ultimate()
    if WATER_BOSS ~= nil then
	WATER_BOSS:EmitSound("medusa_medus_stonegaze_14")

local whirl = WATER_BOSS:FindAbilityByName("whirl_pool")
WATER_BOSS:AddNewModifier(WATER_BOSS, nil, "modifier_silence", {duration=6})
USE_WATER = false
USE_SUB = false
WATER_BOSS:SetMana(0)
WATER_BOSS.Ultimate = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, WATER_BOSS)
WATER_BOSS:EmitSound("General.LevelUp")
WATER_BOSS:SetAbsOrigin(SPAWN_LOCATION1:GetAbsOrigin())
FindClearSpaceForUnit(WATER_BOSS, SPAWN_LOCATION1:GetAbsOrigin(), true)

for i,v in pairs(WATER_BOSS.hiddenWearables) do
        v:RemoveEffects(EF_NODRAW)
    end
        WATER_BOSS:RemoveEffects(EF_NODRAW)

Timers:CreateTimer(2, function()
WATER_BOSS:CastAbilityNoTarget(whirl, -1)
end)
Timers:CreateTimer(12, function()
USE_WATER = true
USE_SUB = true

end)
end
end

function waterbossai:Cast()
  if WATER_BOSS ~= nil then
  local underwater = WATER_BOSS:FindAbilityByName("underwater_datadriven")
  if USE_WATER then
  	
  local randomNum = RandomInt(1, 16)
  					if randomNum == 2 then
            	  local counter = 0
  	 Timers:CreateTimer(0.03, function()
            if underwater:IsCooldownReady() then
            	  USE_SUB = false
 
  				  local random = RandomInt(0, DOTA_MAX_TEAM_PLAYERS-1)
          		  local randomH = PlayerResource:GetPlayer(random)
                  if randomH == nil then
                  	return 0.1
                  else
                  local heroR = randomH:GetAssignedHero()
                  if heroR ~= nil and heroR:IsAlive() then
                  WATER_BOSS:CastAbilityOnPosition( heroR:GetAbsOrigin(), underwater, -1) 
                end

              	  -- Check if waterboss is already in spell
              	  Timers:CreateTimer(0.03, function()
              	  	if WATER_BOSS:HasModifier("modifier_invulnerable") then
             		print("has")
              	  	return 0.1
              	    end  	
          		  end)
          		  counter = counter + 1

       			  end
  			end
  			if counter <= 3 then
  				return 1
  			else
  				  			USE_SUB = true
  				  			return nil
  				  		end
  	end)
  	end
  else
  	print("false noob!!")
  end
end
end

function waterbossai:OtherCast()
    if WATER_BOSS ~= nil then
Timers:CreateTimer(15, function()
  local minions = WATER_BOSS:FindAbilityByName("spawn_minions") 
  local submerge = WATER_BOSS:FindAbilityByName("submerge_datadriven") 
  if minions:IsCooldownReady() then
  WATER_BOSS:CastAbilityImmediately(minions, -1)
  end

  if submerge:IsCooldownReady() then
  	if USE_SUB then
  WATER_BOSS:CastAbilityNoTarget(submerge, -1)
  USE_WATER = false
  Timers:CreateTimer(4.5, function()

  	USE_WATER = true
  	end)
else 
	print("false noob!")
end
  end

  if WATER_BOSS:IsAlive() then
    return 4 + RandomInt(0, 12)
  else 
    return nil
  end
  end)
end
end

function waterbossai:tornado()
    if WATER_BOSS ~= nil then
  local tornado = SPAWN_LOCATION1:FindAbilityByName("tornado_ability") 
  if tornado:IsCooldownReady() and WATER_BOSS:IsAlive() then
  print("tornados")
    local waterplacer
    local origin = SPAWN_LOCATION1:GetAbsOrigin() 
    local tornadocount = 0

    Timers:CreateTimer(0.03, function()
    local angle = RandomInt(-180, 180)
    local anglePos = QAngle(0, angle, 0)
    local forwardV = SPAWN_LOCATION1:GetForwardVector()
    local distance = RandomInt(100,1900)
    local tornadoradius = origin + forwardV * distance
    local tornadoradius1  = RotatePosition(origin, anglePos, tornadoradius)


    SPAWN_LOCATION1:CastAbilityOnPosition(tornadoradius1, tornado, -1)

    if tornadocount < 2 and WATER_BOSS:IsAlive() then
      tornadocount = tornadocount + 1
      return 0.2
    else
      return nil
    end
  end)
end
end
end
