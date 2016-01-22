if earthbossai == nil then
  earthbossai = class({})
end

EARTH_BOSS = nil

function earthbossai:KillBoss()
if EARTH_BOSS ~= nil then
EARTH_BOSS:ForceKill(false)
EARTH_BOSS = nil
print("killed")
else
print("earth check")
end
end

function earthbossai:StartBossEarth()
	local spawnLocation = Entities:FindByName( nil, "npc_dota_earthplacer" )
  SPAWN_LOCATION = spawnLocation
	local entVision = CreateUnitByName( "npc_firevision", spawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
	entVision:AddNewModifier(entVision, nil, "modifier_invulnerable", nil)
	entVision:AddNewModifier(entVision, nil, "modifier_invisible", nil)
	self:TeleportPlayers()
end

function earthbossai:TeleportPlayers()
local dummy = Entities:FindByName( nil, "npc_dota_dummyearth" )
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




function earthbossai:BossIntro()
  local spawnLocation = Entities:FindByName( nil, "npc_dota_earthplacer" )
  local earthboss = CreateUnitByName( "npc_earthboss", spawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
    earthboss:SetMana(0)
    earthboss:AddNewModifier(earthboss, nil, "modifier_phased", nil)
    earthboss:AddNewModifier(earthboss, nil, "modifier_invulnerable", nil)
    earthboss:AddNewModifier(earthboss, nil, "modifier_silence", nil)
    earthboss:AddNewModifier(earthboss, nil, "modifier_disarmed", nil)
    earthboss:AddNewModifier(earthboss, nil, "modifier_rooted", nil)
    EARTH_BOSS = earthboss
    earthbossid = earthboss:GetEntityIndex()
    CustomGameEventManager:Send_ServerToAllClients("display_health", {msg="Remaining", duration=10, mode=0, endfade=false, position=0, warning=earthbossid, paused=false, sound=true} )
    self:RemoveModifiers()

  earthboss:AddSpeechBubble(1, "SHAKE WELL AND DESTROY!!!", 6, 0, 0) 
  FindClearSpaceForUnit(earthboss, spawnLocation:GetAbsOrigin(), true)
    earthboss:EmitSound("earthshaker_erth_fastres_01")
end

function earthbossai:PowerBalls()
 local spawnLocation = Entities:FindByName( nil, "npc_dota_earthplacer" )
 local ability = spawnLocation:FindAbilityByName("power_orbs")
 spawnLocation:CastAbilityImmediately(ability, -1)
 print("cast")
  end

function earthbossai:RemoveModifiers()
  Timers:CreateTimer(5, function()
    EARTH_BOSS:RemoveModifierByName("modifier_phased")
    EARTH_BOSS:RemoveModifierByName("modifier_invulnerable")
    EARTH_BOSS:RemoveModifierByName("modifier_silence")
    EARTH_BOSS:RemoveModifierByName("modifier_disarmed")
    EARTH_BOSS:RemoveModifierByName("modifier_rooted")
    self:Think()
    self:SpellThink()
    self:OtherCast()
    --USE_ICE = true
  end)
end

function earthbossai:Think()
  local bosstime = 0

  Timers:CreateTimer(0.03, function()

    bosstime = bosstime + 1
    print("debug: bosstime " ..bosstime)
    

    if EARTH_BOSS ~= nil then
    if not EARTH_BOSS:IsAlive() then
       ImpossibleBosses:TeleportHomeEarth()
       GameRules:SendCustomMessage("BOSS COMPLETE TIME: "..COLOR_BLUE .." ".. bosstime, DOTA_TEAM_NOTEAM, 0)
       EARTH_BOSS = nil
      else

        if EARTH_BOSS:GetManaPercent() == 100 then
          print("ulting")
          self:Ultimate()

          EARTH_BOSS:EmitSound("earthshaker_erth_kill_04")
        end

        self:Cast()

          
    end
    return 1
    end
  end)
end

function earthbossai:Ultimate()
  if EARTH_BOSS ~= nil then
local earthquake = SPAWN_LOCATION:FindAbilityByName("earthquake") 
local pummel = EARTH_BOSS:FindAbilityByName("pummel")
EARTH_BOSS:AddNewModifier(EARTH_BOSS, nil, "modifier_rooted", {duration=2})
EARTH_BOSS:AddNewModifier(EARTH_BOSS, nil, "modifier_phased", {duration=10})
EARTH_BOSS:AddNewModifier(EARTH_BOSS, nil, "modifier_rune_haste", {duration=12})
EARTH_BOSS:SetBaseMoveSpeed(420)
EARTH_BOSS:SetMana(0)
EARTH_BOSS.Ultimate = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, EARTH_BOSS)
EARTH_BOSS:EmitSound("General.LevelUp")
EARTH_BOSS:SetAbsOrigin(SPAWN_LOCATION:GetAbsOrigin())
FindClearSpaceForUnit(EARTH_BOSS, SPAWN_LOCATION:GetAbsOrigin(), true)
Timers:CreateTimer(2, function()
EARTH_BOSS:CastAbilityNoTarget(pummel, -1)
SPAWN_LOCATION:CastAbilityNoTarget(earthquake, -1)
end)
end
--vpk:C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\dota\pak01.vpk:sounds\weapons\hero\sand_king\sand_king_epicenter_spell.vsnd_c



end

function earthbossai:SpellThink()

Timers:CreateTimer(2, function()

  local randomNum = RandomInt(12, 40)

  self:Quake()

  return randomNum
  end)
end

function earthbossai:Quake()
  if EARTH_BOSS ~= nil then
  local quake = SPAWN_LOCATION:FindAbilityByName("quake") 
  print("quakes")
    local earthplacer
    local origin = SPAWN_LOCATION:GetAbsOrigin() 
    local quakecount = 0

    Timers:CreateTimer(0.03, function()
    local angle = RandomInt(-180, 180)
    local anglePos = QAngle(0, angle, 0)
    local forwardV = SPAWN_LOCATION:GetForwardVector()
    local distance = RandomInt(100,1900)
    local quakeradius = origin + forwardV * distance
    local quakeradius1  = RotatePosition(origin, anglePos, quakeradius)

    if not EARTH_BOSS:IsNull() then
    SPAWN_LOCATION:CastAbilityOnPosition(quakeradius1, quake, -1)
  end

    if quakecount <= 3 and not EARTH_BOSS:IsNull() then
      quakecount = quakecount + 1
      return 0.5
    else
      return nil
    end
  end)
end
end

function earthbossai:Cast()
  if EARTH_BOSS ~= nil then
  --local quake = EARTH_BOSS:FindAbilityByName("ice_barrier")
  local charge = EARTH_BOSS:FindAbilityByName("charge") 
  local balls = SPAWN_LOCATION:FindAbilityByName("power_orbs") --[[Returns:handle
  Retrieve an ability by name from the unit.
  ]]
 -- local intimidate = EARTH_BOSS:FindAbilityByName("hiddenfrost") 

  if charge:IsCooldownReady() then
  self:Charge()
  end

  if balls:IsCooldownReady() then
  SPAWN_LOCATION:CastAbilityNoTarget(balls, -1)
  end
end
end

function earthbossai:OtherCast()
  if EARTH_BOSS ~= nil then
Timers:CreateTimer(15, function()
  local slam = EARTH_BOSS:FindAbilityByName("slam")
  local intimidate = EARTH_BOSS:FindAbilityByName("intimidate") 


  if intimidate:IsCooldownReady() then
  EARTH_BOSS:CastAbilityNoTarget(intimidate, -1)
  EARTH_BOSS:EmitSound("earthshaker_erth_level_08")   
  end

  if slam:IsCooldownReady() then
  EARTH_BOSS:CastAbilityNoTarget(slam, -1)
  EARTH_BOSS:EmitSound("earthshaker_erth_ability_fissure_01")   
  end

  if EARTH_BOSS:IsAlive() then
    return 4
  else 
    return nil
  end
  end)
end
end

function earthbossai:Charge()
  if EARTH_BOSS ~= nil then
     local charge = EARTH_BOSS:FindAbilityByName("charge") 
        if charge ~= nil and charge:IsCooldownReady() then

          Timers:CreateTimer(0.03, function()
          local random = RandomInt(0, DOTA_MAX_TEAM_PLAYERS-1)
          local randomH = PlayerResource:GetPlayer(random)
          if randomH ~= nil then
          local heroR = randomH:GetAssignedHero()
          if heroR ~= nil then
            if charge:IsCooldownReady() and heroR:IsAlive() then

              EARTH_BOSS:CastAbilityOnTarget( heroR ,charge, -1) 
              EARTH_BOSS:EmitSound("earthshaker_erth_anger_06")
                       Timers:CreateTimer(3, function()
                        EARTH_BOSS:EmitSound("earthshaker_erth_ability_enchant_02")  
                        if heroR:IsAlive()  then    
                          self:Pummel()
                        end
                        end)
            end
          end
        end
          end)
        end
end
end

function earthbossai:Pummel()
  if EARTH_BOSS ~= nil then
  local counter = 0
  local pummel = EARTH_BOSS:FindAbilityByName("pummel") 
      Timers:CreateTimer(0.03, function()
        EARTH_BOSS:CastAbilityNoTarget(pummel, -1)
        counter = counter + 1
          if counter < 5 then
            return 0.4
          end
        end)
    end
end
