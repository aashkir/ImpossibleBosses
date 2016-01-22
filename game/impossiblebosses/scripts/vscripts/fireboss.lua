--[[
	CHANGELIST:
	10.01.2015 - Delete unnecessary parameter to avoid confusion
]]

--[[
	Author: kritth
	Date: 10.01.2015
	Find necessary vectors, and spawn spawning until units cap is reached
]]

function march_of_the_machines_spawn( event )
local ability = event.ability
local caster = event.caster
local numFire = 0
local angle = 0

Timers:CreateTimer( function()
local randomvec = RandomInt( -10, 10 )

		local origin =   caster:GetAbsOrigin() 
		local anglePos = QAngle(0, angle, 0)
		local forwardV = caster:GetForwardVector()
		local distance = 1200
		local casterLocRotated = RotatePosition(caster:GetAbsOrigin(), anglePos, origin * 100)
		local casterLoc = RotatePosition(casterLocRotated, anglePos, origin) --[[Returns:Vector
		Rotate a ''Vector'' around a point.
		]]
		local forwardVec = origin - casterLocRotated
		forwardVec = forwardVec:Normalized()
	

		local Velocityvec = Vector( forwardVec.x, forwardVec.y, 0 )

-- Ship this to flameburst later
	local projectileTable = {
				Ability = ability,
				EffectName = "particles/fireball2.vpcf",
				vSpawnOrigin = origin,
				fDistance = distance,
				fStartRadius = 50,
				fEndRadius = 50,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				bProvidesVision = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL,
				vVelocity = Velocityvec * RandomFloat(300, 700)
			}
			ProjectileManager:CreateLinearProjectile( projectileTable )
			numFire = numFire + 1
			angle = angle + 30
			if 
				numFire >= 12 then
							return nil
			else
				return 0.03
			end
		end
	)
end


--[[function march_of_the_machines_spawn( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = keys.target_points[1]
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local collision_radius = ability:GetLevelSpecialValueFor( "collision_radius", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local machines_per_sec = ability:GetLevelSpecialValueFor ( "machines_per_sec", ability:GetLevel() - 1 )
	local dummyModifierName = "modifier_march_of_the_machines_dummy_datadriven"
	

	
	-- Create dummy to store data in case of multiple instances are called
	local dummy = CreateUnitByName( "npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
	dummy.march_of_the_machines_num = 0
	
	-- Create timer to spawn projectile
	Timers:CreateTimer( function()
		local randomvec = RandomInt( -10, 10 )
		local angle = RandomInt(-180,180)
		local anglePos = QAngle(0, angle, 0)
			local casterLocRotated = caster:GetAbsOrigin() - Vector( randomvec, 0, randomvec )
			local casterLoc = RotatePosition(casterLocRotated, anglePos, targetLoc)
			local targetLoc = keys.target_points[1]

				-- Find forward vector
	local forwardVec = targetLoc - casterLoc
	forwardVec = forwardVec:Normalized()
	
	-- Find backward vector
	local backwardVec = casterLoc - targetLoc
	backwardVec = backwardVec:Normalized()
	
	-- Find middle point of the spawning line
	local middlePoint = casterLoc
	
	-- Find perpendicular vector
	local v = middlePoint - casterLoc
	local dx = -v.y
	local dy = v.x
	local perpendicularVec = Vector( dx, dy, v.z )
	perpendicularVec = perpendicularVec:Normalized()

			-- Get random location for projectile
			local random_distance = RandomInt( -radius, radius )
			local spawn_location = middlePoint
			
			local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )
			
			-- Spawn projectiles
			local projectileTable = {
				Ability = ability,
				EffectName = "particles/fireball2.vpcf",
				vSpawnOrigin = spawn_location,
				fDistance = distance,
				fStartRadius = collision_radius,
				fEndRadius = collision_radius,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				bProvidesVision = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL,
				vVelocity = velocityVec * projectile_speed
			}
			ProjectileManager:CreateLinearProjectile( projectileTable )
			--print(dummy.march_of_the_machines_num)
			-- Increment the counter
			dummy.march_of_the_machines_num = dummy.march_of_the_machines_num + 1
			
			-- Check if the number of machines have been reached
			if dummy.march_of_the_machines_num == machines_per_sec * duration then
				dummy:Destroy()
				--print("Destroying")
				return nil
			else
				return 1 / machines_per_sec
			end
		end
	)
end]]--


--[[
	Author: kritth
	Date: 9.1.2015.
	Bubbles seen only to ally as pre-effect
]]
function torrent_bubble_allies( keys )
	local caster = keys.caster
	
	local allHeroes = HeroList:GetAllHeroes()
	local delay = keys.ability:GetLevelSpecialValueFor( "delay", keys.ability:GetLevel() - 1 )
	local particleName = "particles/flamestrike.vpcf"
	local target = keys.target_points[1]
	
	for k, v in pairs( allHeroes ) do
		if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
			
			
			Timers:CreateTimer( delay + 1, function()
					
					return nil
					end)
			
			-- Destroy particle after delay
			Timers:CreateTimer( delay, function()
					--target:EmitSound("IB.flame")
					
					return nil
				end
			)
		end
	end
end

--[[
	Author: kritth
	Date: 9.1.2015.
	Emit sound at location
]]
function torrent_emit_sound( keys )
	local dummy = CreateUnitByName( "npc_dummy_unit", keys.target_points[1], false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	EmitSoundOn( "IB.flame", dummy )
	dummy:ForceKill( true )
end



--[[
	Author: kritth
	Date: 9.1.2015.
	Provide post vision
]]
function torrent_post_vision( keys )
	local ability = keys.ability
	local target = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )
	
	ability:CreateVisibilityNode( target, radius, duration )
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Cast spirits.
]]
function CastSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	ability.spirits_startTime		= GameRules:GetGameTime()
	ability.spirits_numSpirits		= 0		-- Use this rather than "#spirits_spiritsSpawned"
	ability.spirits_spiritsSpawned	= {}
	caster.spirits_radius			= event.default_radius
	caster.spirits_movementFactor	= 0		-- Changed by the toggle abilities

	-- Enable the toggle abilities
	--caster:SwapAbilities( event.empty1_ability, event.spirits_in_ability, false, true )
	--caster:SwapAbilities( event.empty2_ability, event.spirits_out_ability, false, true )

end

function StartMoving (event)

	local caster = event.caster
	local ability = event.ability

end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Update spirits.
]]
function ThinkSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	local numSpiritsMax	= event.num_spirits

	local casterOrigin	= caster:GetAbsOrigin()

	local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime

	--------------------------------------------------------------------------------
	-- Validate the number of spirits summoned
	--
	local idealNumSpiritsSpawned = elapsedTime / event.spirit_summon_interval
	idealNumSpiritsSpawned = math.min( idealNumSpiritsSpawned, numSpiritsMax )

	if ability.spirits_numSpirits < idealNumSpiritsSpawned then

		-- Spawn a new spirit
		local newSpirit = CreateUnitByName( "npc_dota_wisp_spirit", casterOrigin, false, caster, caster, caster:GetTeam() )

		-- Create particle FX
		local pfx = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
		newSpirit.spirit_pfx = pfx

		-- Update the state
		local spiritIndex = ability.spirits_numSpirits + 1
		newSpirit.spirit_index = spiritIndex
		ability.spirits_numSpirits = spiritIndex
		ability.spirits_spiritsSpawned[spiritIndex] = newSpirit

		-- Apply the spirit modifier
		ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )

	end

	--------------------------------------------------------------------------------
	-- Update the radius
	--
	local currentRadius	= caster.spirits_radius
	local deltaRadius = caster.spirits_movementFactor * event.spirit_movement_rate * event.think_interval
	currentRadius = currentRadius + deltaRadius
	currentRadius = math.min( math.max( currentRadius, event.min_range ), event.max_range )

	caster.spirits_radius = currentRadius

	--------------------------------------------------------------------------------
	-- Update the spirits' positions
	--
	local currentRotationAngle	= elapsedTime * event.spirit_turn_rate
	local rotationAngleOffset	= 360 / event.num_spirits

	local numSpiritsAlive = 0

	for k,v in pairs( ability.spirits_spiritsSpawned ) do

		numSpiritsAlive = numSpiritsAlive + 1

		-- Rotate
		local rotationAngle = currentRotationAngle - rotationAngleOffset * ( k - 1 )
		local relPos = Vector( 0, currentRadius, 0 )
		relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )

		local absPos = GetGroundPosition( relPos + casterOrigin, v )

		v:SetAbsOrigin( absPos )

		-- Update particle
		ParticleManager:SetParticleControl( v.spirit_pfx, 1, Vector( currentRadius, 0, 0 ) )

	end

	if ability.spirits_numSpirits == numSpiritsMax and numSpiritsAlive == 0 then
		-- All spirits have been exploded.
		caster:RemoveModifierByName( event.caster_modifier )
		return
	end

end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Destroy all spirits and swap the abilities back to the original states.
]]
function EndSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	local spiritModifier	= event.spirit_modifier

	-- Destroy all spirits
	for k,v in pairs( ability.spirits_spiritsSpawned ) do
		v:RemoveModifierByName( spiritModifier )
	end

	-- Disable the toggle abilities
	--caster:SwapAbilities( event.empty1_ability, event.spirits_in_ability, true, false )
	--caster:SwapAbilities( event.empty2_ability, event.spirits_out_ability, true, false )

	-- Reset the toggle states.
	--ResetToggleState( caster, event.spirits_in_ability )
	--ResetToggleState( caster, event.spirits_out_ability )

end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Change the movement factor.
]]
--[[function ToggleOn( event )
	local caster	= event.caster

	-- Make sure that the opposite ability is toggled off.
	ResetToggleState( caster, event.opposite_ability )

	-- Change the movement factor
	caster.spirits_movementFactor = event.spirit_movement
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Reset the movement factor.
]]
function ToggleOff( event )
	event.caster.spirits_movementFactor = 0
end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Reset the toggle state.

function ResetToggleState( caster, abilityName )
	local ability = caster:FindAbilityByName( abilityName )
	if ability:GetToggleState() then
		ability:ToggleAbility()
	end
end]]--
--[[
	Author: Ractidous
	Date: 09.02.2015.
	Apply a modifier which detects collision with a hero.
]]
function OnCreatedSpirit( event )
	
	local spirit = event.target
	local ability = event.ability

	-- Set the spirit to caster
	ability:ApplyDataDrivenModifier( spirit, spirit, event.additionalModifier, {} )

end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Destroy a spirit.
]]
function OnDestroySpirit( event )

	local spirit	= event.target
	local ability	= event.ability
	
	ParticleManager:DestroyParticle( spirit.spirit_pfx, false )

	-- Create vision
	ability:CreateVisibilityNode( spirit:GetAbsOrigin(), event.vision_radius, event.vision_duration )

	-- Kill
	spirit:ForceKill( true )

end

--[[
	Author: Ractidous
	Date: 09.02.2015.
	Explode the spirit due to collision with an enemy hero.
]]
function ExplodeSpirit( event )
	
	local spirit	= event.caster		-- We have set the spirit to the caster
	local ability	= event.ability

	if not spirit.spirit_isExploded then

		spirit.spirit_isExploded = true

		-- Remove from the list of spirits
		ability.spirits_spiritsSpawned[spirit.spirit_index] = nil

		-- Remove the spirit modifier
		spirit:RemoveModifierByName( event.spirit_modifier )

		-- Fire the hit sound
		StartSoundEvent( event.explosion_sound, spirit )

	end

end

function Eruption(event)

local volc = CreateUnitByName( "npc_volcano", event.target_points[1], false, event.caster, event.caster, event.caster:GetTeamNumber() )
volc:AddNewModifier(caster, ability, "modifier_kill", {duration = 25})
local erupt = volc:FindAbilityByName("flameburst")
if erupt:IsCooldownReady() then

	Timers:CreateTimer(0.03, function()
	if not volc:IsNull() then
	volc:CastAbilityNoTarget(erupt, -1) 
	return 1
end
	end)

	--[[Returns:void
	Cast an ability with no target. ( hAbility, iPlayerIndex )
	]]
end

end

--[[
	Author: Noya
	Date: 16.01.2015.
	Levels up the ability_name to the same level of the ability that runs this
]]
function LevelUpAbility( event )
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	-- The ability to level up
	local ability_name = event.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	
	local ability_level = ability_handle:GetLevel()

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end

--[[
	Author: Ractidous
	Date: 29.01.2015.
	Stop a sound.
]]
function StopSound( event )
	StopSoundEvent( event.sound_name, event.caster )
end

function spawn_volc( event )
	print("spawning volc")
	local dummy = CreateUnitByName( "npc_volcano", event.target_points[1], false, event.caster, event.caster, event.caster:GetTeamNumber() )
	--EmitSoundOn( "Hero_ElderTitan.EarthSplitter.Cast", dummy )
	--dummy:ForceKill( true )
end