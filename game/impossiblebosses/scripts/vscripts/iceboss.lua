function hpcheck( keys )

local caster = keys.caster
local target = keys.target

if target:IsAlive() and caster:IsAlive() then
	if target:GetManaPercent() == 0 then
		Timers:CreateTimer( 2, function()
			if target:GetManaPercent() == 0 and target:GetTeamNumber() ~= caster:GetTeamNumber() then
				if caster:IsAlive() then
				target:ForceKill(true)
					end
				end
			end)
		end
end

	if caster:GetHealthPercent() < 30 and caster:IsAlive() then
		if target:IsAlive() and caster:IsAlive() then
				target:ReduceMana(1)
		end
	end
end


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
	dummy:ForceKill( true )
	print("TESTbbb")

	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )

	local iceblock = CreateUnitByName("npc_iceblock", target, false, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	iceblock:AddNewModifier(caster, ability, "modifier_kill", {duration = 12})
	local startPos = iceblock:GetAbsOrigin()

	local particleName ="particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, iceblock )
	ParticleManager:SetParticleControl( pfx, 1, iceblock:GetAbsOrigin() )
	EmitSoundOn( "Hero_Tusk.FrozenSigil.Cast", iceblock )

	Timers:CreateTimer( 0.03, function()
	if not iceblock:IsAlive() then
		ParticleManager:DestroyParticle(pfx,false)
		EmitSoundOn( "Hero_Tusk.IceShards", iceblock )
else
	return 0.5
	end
	end)


end



--[[
	Author: kritth
	Date: 9.1.2015.
	Provide post vision
]]
function torrent_post_vision( keys )
	print("TESTbeis")


	
	ability:CreateVisibilityNode( target, radius, duration )
end

function item_shivas_guard_datadriven_on_spell_start(keys)
	local shivas_guard_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControl(shivas_guard_particle, 1, Vector(keys.BlastFinalRadius, keys.BlastFinalRadius / keys.BlastSpeedPerSecond, keys.BlastSpeedPerSecond))
	
	keys.caster:EmitSound("DOTA_Item.ShivasGuard.Activate")
	keys.caster.shivas_guard_current_blast_radius = 0
	
	--Every .03 seconds, damage and apply a movement speed debuff to all units within the current radius of the blast (centered around the caster)
	--that do not already have the debuff.
	--Stop the timer when the blast has reached its maximum radius.
	Timers:CreateTimer({
		endTime = .03, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
			keys.ability:CreateVisibilityNode(keys.caster:GetAbsOrigin(), keys.BlastVisionRadius, keys.BlastVisionDuration)  --Shiva's Guard's active provides 800 flying vision around the caster, which persists for 2 seconds.
		
			keys.caster.shivas_guard_current_blast_radius = keys.caster.shivas_guard_current_blast_radius + (keys.BlastSpeedPerSecond * .03)
			local nearby_enemy_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, keys.caster.shivas_guard_current_blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for i, individual_unit in ipairs(nearby_enemy_units) do
				if not individual_unit:HasModifier("modifier_item_shivas_guard_datadriven_blast_debuff") then
					ApplyDamage({victim = individual_unit, attacker = keys.caster, damage = keys.BlastDamage, damage_type = DAMAGE_TYPE_MAGICAL,})
					
					--This impact particle effect should radiate away from the caster of Shiva's Guard.
					local shivas_guard_impact_particle = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, individual_unit)
					local target_point = individual_unit:GetAbsOrigin()
					local caster_point = individual_unit:GetAbsOrigin()
					ParticleManager:SetParticleControl(shivas_guard_impact_particle, 1, target_point + (target_point - caster_point) * 30)
					
					keys.ability:ApplyDataDrivenModifier(keys.caster, individual_unit, "modifier_item_shivas_guard_datadriven_blast_debuff", nil)
				end
			end
			
			if keys.caster.shivas_guard_current_blast_radius < keys.BlastFinalRadius then  --If the blast should still be expanding.
				return .03
			else  --The blast has reached or exceeded its intended final radius.
				keys.caster.shivas_guard_current_blast_radius = 0
				return nil
			end
		end
	})
end

function CastSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	ability.spirits_startTime		= GameRules:GetGameTime()
	ability.spirits_numSpirits		= 0		-- Use this rather than "#spirits_spiritsSpawned"
	ability.spirits_spiritsSpawned	= {}
	caster.spirits_radius			= event.default_radius
	caster.spirits_movementFactor	= 0		-- Changed by the toggle abilities

	-- Enable the toggle abilities
	caster:SwapAbilities( event.empty1_ability, event.spirits_in_ability, false, true )
	caster:SwapAbilities( event.empty2_ability, event.spirits_out_ability, false, true )

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
	local casterOrigin	= caster:GetAbsOrigin()

	local spiritModifier	= event.spirit_modifier
	local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime
	local randomDelay = RandomInt(0, 4)
	
Timers:CreateTimer(randomDelay, function()
	for k,v in pairs( ability.spirits_spiritsSpawned ) do
		v:MoveToPosition(casterOrigin)
		v:SetBaseMoveSpeed(500)
	end

	-- Destroy all spirits
	Timers:CreateTimer(5, function()
	for k,v in pairs( ability.spirits_spiritsSpawned ) do
		v:RemoveModifierByName( spiritModifier )
	end
	end)

	end)

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
function ToggleOn( event )
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
]]
function ResetToggleState( caster, abilityName )
	local ability = caster:FindAbilityByName( abilityName )
	if ability:GetToggleState() then
		ability:ToggleAbility()
	end
end

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

function ManaBreak( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local manaBurn = ability:GetLevelSpecialValueFor("mana_per_hit", (ability:GetLevel() - 1))
	local manaDamage = ability:GetLevelSpecialValueFor("damage_per_burn", (ability:GetLevel() - 1))

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability

	-- If the target is not magic immune then reduce the mana and deal damage
	if not target:IsMagicImmune() then
		-- Checking the mana of the target and calculating the damage
		if(target:GetMana() >= manaBurn) then
			damageTable.damage = manaBurn * manaDamage
			target:ReduceMana(manaBurn)
		else
			damageTable.damage = target:GetMana() * manaDamage
			target:ReduceMana(manaBurn)
		end

		ApplyDamage(damageTable)
	end
end