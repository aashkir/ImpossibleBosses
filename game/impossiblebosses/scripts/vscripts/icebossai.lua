if icebossai == nil then
  icebossai = class({})
end

ICE_BOSS = nil

function icebossai:KillBoss()
if ICE_BOSS ~= nil then
ICE_BOSS:ForceKill(false)
ICE_BOSS = nil
print("killed")
    
end
end


function icebossai:StartBossIce()
	local spawnLocation = Entities:FindByName( nil, "npc_dota_iceplacer" )
	local entVision = CreateUnitByName( "npc_firevision", spawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
	entVision:AddNewModifier(entVision, nil, "modifier_invulnerable", nil)
	entVision:AddNewModifier(entVision, nil, "modifier_invisible", nil)
	self:TeleportPlayers()
end

function icebossai:TeleportPlayers()
local dummy = Entities:FindByName( nil, "npc_dota_dummyice" )
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

Timers:CreateTimer(1.4, function()
 	for i=0, DOTA_MAX_TEAM_PLAYERS-1  do
    local playerid = PlayerResource:GetPlayer(i)
    if playerid ~= nil then 
    	PlayerResource:SetCameraTarget(i, nil) -- Remove Camera Lock
    end
	end
  end)

end




function icebossai:BossIntro()
	local spawnLocation = Entities:FindByName( nil, "npc_dota_iceplacer" )
	local iceboss = CreateUnitByName( "npc_iceboss", spawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
		iceboss:SetMana(0)
		iceboss:AddNewModifier(iceboss, nil, "modifier_phased", nil)
		iceboss:AddNewModifier(iceboss, nil, "modifier_invulnerable", nil)
		iceboss:AddNewModifier(iceboss, nil, "modifier_silence", nil)
		iceboss:AddNewModifier(iceboss, nil, "modifier_disarmed", nil)
		iceboss:AddNewModifier(iceboss, nil, "modifier_rooted", nil)
		ICE_BOSS = iceboss
		icebossid = iceboss:GetEntityIndex()
		CustomGameEventManager:Send_ServerToAllClients("display_health", {msg="Remaining", duration=10, mode=0, endfade=false, position=0, warning=icebossid, paused=false, sound=true} )
		self:RemoveModifiers()

	iceboss:AddSpeechBubble(1, "Tshhahahahaha.. I shall cover you in ice!!!", 6, 0, 0) 
	FindClearSpaceForUnit(iceboss, spawnLocation:GetAbsOrigin(), true)
		iceboss:EmitSound("warlock_golem_wargol_laugh_12")
end

function icebossai:RemoveModifiers()
	Timers:CreateTimer(5, function()
		ICE_BOSS:RemoveModifierByName("modifier_phased")
		ICE_BOSS:RemoveModifierByName("modifier_invulnerable")
		ICE_BOSS:RemoveModifierByName("modifier_silence")
		--ICE_BOSS:RemoveModifierByName("modifier_disarmed")
		--ICE_BOSS:RemoveModifierByName("modifier_rooted")
		self:Think()
		self:SpellThink()
		USE_ICE = true
	end)
end

function icebossai:SpellThink()

Timers:CreateTimer(2, function()

	local randomNum = RandomInt(8, 20)

	self:IceBurst()

	return randomNum
	end)
end


function icebossai:Think()
	local bosstime = 0

	Timers:CreateTimer(0.03, function()
		
		bosstime = bosstime + 1
		print("debug: bosstime " ..bosstime)
		

		if ICE_BOSS ~= nil then
		if not ICE_BOSS:IsAlive() then

			 ImpossibleBosses:TeleportHomeIce()
			 GameRules:SendCustomMessage("BOSS COMPLETE TIME: "..COLOR_BLUE .." ".. bosstime, DOTA_TEAM_NOTEAM, 0)
			 ICE_BOSS = nil
			else
			--TODO: teleport heroes to base

				if ICE_BOSS:GetManaPercent() == 100 then
					print("ulting")
					self:Ultimate()
				end

				self:Cast()
		end
		return 1
		end
	end)
end

function icebossai:Ultimate()
	print("ulting")
	if ICE_BOSS ~= nil then
ICE_BOSS:EmitSound("General.LevelUp")
ICE_BOSS.Ultimate = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, ICE_BOSS)
local gravechill = ICE_BOSS:FindAbilityByName("gravefrost")
	USE_ICE = false
	ICE_BOSS:SetMana(0)
	local ultcount = 0
	Timers:CreateTimer(0.03, function()
	ICE_BOSS:CastAbilityImmediately(gravechill, -1)
	ultcount = ultcount + 1
	if ultcount <= 3 then
		return 14
	else

	USE_ICE = true
end
	end)
end
end
function icebossai:IceBurst()
	if ICE_BOSS ~= nil then
	local shardburst = ICE_BOSS:FindAbilityByName("shardburst") 
	print("iceburst")

		local origin = ICE_BOSS:GetAbsOrigin() 
		local icecount = 0

		Timers:CreateTimer(0.03, function()
		local angle = RandomInt(-180, 180)
		local anglePos = QAngle(0, angle, 0)
		local forwardV = ICE_BOSS:GetForwardVector()
		local distance = RandomInt(100,2100)
		local iceradius = origin + forwardV * distance
		local iceradius1  = RotatePosition(origin, anglePos, iceradius)

		if USE_ICE == true then
				ICE_BOSS:CastAbilityOnPosition(iceradius1, shardburst, -1)
			else print("Can't use ice, it's false.")
			end

		if icecount <= 8 and ICE_BOSS:IsAlive() then
			icecount = icecount + 1
			return 0.5
		else
			return nil
		end
	end)
end
end

function icebossai:Cast()
	if ICE_BOSS ~= nil then
	local icebarrier = ICE_BOSS:FindAbilityByName("ice_barrier")
	local icelance = ICE_BOSS:FindAbilityByName("ice_lance")
	local blizzard = ICE_BOSS:FindAbilityByName("blizzard_nova") 
	local wolves = ICE_BOSS:FindAbilityByName("hiddenfrost") 
	if icebarrier:IsCooldownReady() then
	ICE_BOSS:CastAbilityNoTarget(icebarrier, -1)
	end

	if icelance:IsCooldownReady() then
	ICE_BOSS:CastAbilityNoTarget(icelance, -1)
	end

	if blizzard:IsCooldownReady() then
	ICE_BOSS:CastAbilityNoTarget(blizzard, -1)
	end

	if wolves:IsCooldownReady() then
	ICE_BOSS:CastAbilityNoTarget(wolves, -1)
	end
end
end

function IceBarrier( event )
	if ICE_BOSS ~= nil then
	local caster = event.caster
	USE_ICE = false
	local shardburst = caster:FindAbilityByName("shardburst") 
	--FIRE_BOSS:SetMana(0)
	--FIRE_BOSS:AddSpeechBubble(1, "Let the flames consume you...", 3, 0, 0) 
	--FIRE_BOSS:AddNewModifier(FIRE_BOSS, nil, "modifier_rooted", nil)
-- We are going to make giant spiral of flamestrikes for his ultimate
	local origin = caster:GetAbsOrigin()
	local forwardV = caster:GetForwardVector()
	local angNum = -180
	local distance = 600

	Timers:CreateTimer(0.03, function()
	--spiral timer
	local angle = QAngle(0, angNum, 0)
	local iceradius = origin + forwardV * distance
	local iceradius1  = RotatePosition(origin, angle, iceradius)
	caster:CastAbilityOnPosition(iceradius1, shardburst, -1)
	angNum = angNum + 20

	if angNum < 180 and ICE_BOSS:IsAlive() then
		return 0.3
	else
		Timers:CreateTimer(16, function()
		USE_ICE = true
		end)
	end
	end)

end
end

function IceLance( event )
	local caster = event.caster
	local shardburst = caster:FindAbilityByName("shardburst") 
	--FIRE_BOSS:SetMana(0)
	--FIRE_BOSS:AddSpeechBubble(1, "Let the flames consume you...", 3, 0, 0) 
	--FIRE_BOSS:AddNewModifier(FIRE_BOSS, nil, "modifier_rooted", nil)
-- We are going to make giant spiral of flamestrikes for his ultimate
	local origin = caster:GetAbsOrigin()
	local forwardV = caster:GetForwardVector()
	local angNum = RandomInt(-180, 180) --[[Returns:int
	Get a random ''int'' within a range
	]]
	local distance = 200

	Timers:CreateTimer(0.03, function()
	--spiral timer
	local angle = QAngle(0, angNum, 0)
	local iceradius = origin + forwardV * distance
	local iceradius1  = RotatePosition(origin, angle, iceradius)
	caster:CastAbilityOnPosition(iceradius1, shardburst, -1)
	distance = distance + 220

	if distance < 1700 and ICE_BOSS:IsAlive() then
		return 0.2
	end
	end)

end

function iceblockkill( event )
local ability = event.ability
local iceblock = event.caster
local numIce = 0
local angle = 0

local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_taunt_icemelt_explode.vpcf", PATTACH_POINT, iceblock)
			ParticleManager:SetParticleControl(particle1, 1, iceblock:GetAbsOrigin())
Timers:CreateTimer( function()
local randomvec = RandomInt( -10, 10 )
		local origin = iceblock:GetAbsOrigin() 
		local anglePos = QAngle(0, angle, 0)
		local forwardV = iceblock:GetForwardVector()
		local distance = 800
		local casterLocRotated = RotatePosition(iceblock:GetAbsOrigin(), anglePos, origin * 100)
		local casterLoc = RotatePosition(casterLocRotated, anglePos, origin) --[[Returns:Vector
		Rotate a ''Vector'' around a point.
		]]
		local forwardVec = origin - casterLocRotated
		forwardVec = forwardVec:Normalized()
	

		local Velocityvec = Vector( forwardVec.x, forwardVec.y, 0 )

-- Ship this to flameburst later
	local projectileTable = {
				Ability = ability,
				EffectName = "particles/fireball4.vpcf",
				vSpawnOrigin = origin,
				fDistance = distance,
				fStartRadius = 50,
				fEndRadius = 50,
				Source = iceblock,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				bProvidesVision = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL,
				vVelocity = Velocityvec * 400
			}
			ProjectileManager:CreateLinearProjectile( projectileTable )
			numIce = numIce + 1
			angle = angle + 60
			if 
				numIce >= 6 then
							return nil
			else
				print(numIce)
				return 0.12
			end
		end
	)
end

function iceblock( event)
local iceblock = event.caster
end

function icewolves(event)

local ability = event.ability
local iceblock = event.caster
local numIce = 0
local angle = 0

local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_taunt_icemelt_explode.vpcf", PATTACH_POINT, iceblock)
			ParticleManager:SetParticleControl(particle1, 1, iceblock:GetAbsOrigin())
Timers:CreateTimer( function()
local randomvec = RandomInt( -10, 10 )
		local origin = iceblock:GetAbsOrigin() 
		local anglePos = QAngle(0, angle, 0)
		local forwardV = iceblock:GetForwardVector()
		local distance = 800
		local casterLocRotated = RotatePosition(iceblock:GetAbsOrigin(), anglePos, origin * 100)
		local casterLoc = RotatePosition(casterLocRotated, anglePos, origin) --[[Returns:Vector
		Rotate a ''Vector'' around a point.
		]]
		local forwardVec = origin - casterLocRotated
		forwardVec = forwardVec:Normalized()
	

		local Velocityvec = Vector( forwardVec.x, forwardVec.y, 0 )

-- Ship this to flameburst later
	local projectileTable = {
				Ability = ability,
				EffectName = "particles/fireball4.vpcf",
				vSpawnOrigin = origin,
				fDistance = distance,
				fStartRadius = 100,
				fEndRadius = 100,
				Source = iceblock,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				bProvidesVision = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL,
				vVelocity = Velocityvec * 400
			}
			ProjectileManager:CreateLinearProjectile( projectileTable )
			numIce = numIce + 1
			angle = angle + 60
			if 
				numIce >= 6 then
							return nil
			else
				return 0.12
			end
			end)
	end

