--[[Author: Pizzalol
	Date: 19.09.2015.
	Upon blinking to the target it applies the attack speed modifier if the target is an enemy
	and queues up an attack order on the target]]
function PhantomStrike( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local phantom_strike_modifier = keys.phantom_strike_modifier
	local duration = ability:GetDuration()
	ability.phantom_strike_attacks = ability:GetLevelSpecialValueFor("bonus_max_attack_count", ability_level)

	-- If the target is an enemy then do enemy team logic
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then

		-- Apply the attack speed modifier and keep track of the target for attack checks later
		ability:ApplyDataDrivenModifier(caster, caster, phantom_strike_modifier, {duration = duration})
		ability.phantom_strike_target = target

		target:ReduceMana(40)

		-- Order the caster to attack the target
		order = 
		{
			UnitIndex = caster:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:GetEntityIndex(),
			Queue = true
		}

		ExecuteOrderFromTable(order)
	end
end

--[[Triggers on every attack made while under the effect of the attack speed modifier
	It checks if the caster is still attacking the original target and if it exceeded the maximum number of attacks]]
function PhantomStrikeAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local phantom_strike_modifier = keys.phantom_strike_modifier

	-- Check if the attacked target is still the original target or if it still has any attack charges left
	if target ~= ability.phantom_strike_target or ability.phantom_strike_attacks <=0 then
		-- If not then remove the attack speed modifier
		caster:RemoveModifierByName(phantom_strike_modifier) 
	else
		-- Otherwise reduce the number of attack charges
		ability.phantom_strike_attacks = ability.phantom_strike_attacks - 1
	end
end

function DoubleEdgeParticle( event )
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local damageType = ability:GetAbilityDamageType()

	local victim_angle = target:GetAnglesAsVector().y
	local origin_difference = target:GetAbsOrigin() - caster:GetAbsOrigin()
	-- Get the radian of the origin difference between the attacker and Bristleback. We use this to figure out at what angle the attacker is at relative to Bristleback.
	local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
	-- Convert the radian to degrees.
	origin_difference_radian = origin_difference_radian * 180
	local attacker_angle = origin_difference_radian / math.pi
	-- See the opening block comment for why I do this. Basically it's to turn negative angles into positive ones and make the math simpler.
	attacker_angle = attacker_angle + 180.0
	-- Finally, get the angle at which Bristleback is facing the attacker.
	local result_angle = attacker_angle - victim_angle
	result_angle = math.abs(result_angle)

	local damage = ability:GetLevelSpecialValueFor( "edge_damage" , ability:GetLevel() - 1  )

		-- Check for back angle. If this check doesn't pass, then do side angle "damage reduction".
		if result_angle >= 180 - (70 / 2) and result_angle <= 180 + (70 / 2) then 
			-- This is the actual "damage reduction".
			local damageBack = (damage * 0.2)
			print(damageBack)
			
			ApplyDamage({ victim = target, attacker = caster, damage = damageBack,	damage_type = damageType })
			print("bonus damage")

			
			local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_POINT, target)
			ParticleManager:SetParticleControl(particle1, 1, target:GetAbsOrigin())
			target:EmitSound("Hero_PhantomAssassin.CoupDeGrace") --[[Returns:void
			 
			]]
			-- Play the sound on Bristleback.
			--EmitSoundOn(params.sound, params.unit)
			-- Create the back particle effect.
			--local back_damage_particle = ParticleManager:CreateParticle(particle1, 0, caster:GetAbsOrigin())
			-- Set Control Point 1 for the back damage particle; this controls where it's positioned in the world. In this case, it should be positioned on Bristleback.
			--ParticleManager:SetParticleControlEnt(back_damage_particle, 1, params.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", params.unit:GetAbsOrigin(), true) 
			-- Increase the Quill Spray damage counter based on how much damage was done *post-Bristleback mitigation*.
		else
			ApplyDamage({ victim = target, attacker = caster, damage = 0,	damage_type = damageType })
		end



	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- Destination
	ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin()) -- Hit Glow
end

function FlareParticle( event )
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local damageType = ability:GetAbilityDamageType()

		-- Particle
	local particle1 = ParticleManager:CreateParticle("particles/flarespell.vpcf", PATTACH_POINT, target)
			ParticleManager:SetParticleControl(particle1, 1, target:GetAbsOrigin())
			Timers:CreateTimer( 2, function()
			ParticleManager:DestroyParticle( particle1, false )
			end)
			target:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
			Timers:CreateTimer( 0.2, function()
			target:EmitSound("n_creep_SatyrHellCaster.Damage")
				end)

	local particle = ParticleManager:CreateParticle("particles/doubleedge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- Destination
	ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin()) -- Hit Glow
end

--[[
	Author: Noya
	Date: 9.1.2015.
	Plays the slardar_amp_damage particle and destroys it later
]]
function AmplifyDamageParticle( event )
	local target = event.target
	local location = target:GetAbsOrigin()
	local particleName = "particles/maledict.vpcf"
	local particleName1 = "particles/weakness.vpcf"

-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function() 
		target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

		target.AmpDamageParticle1 = ParticleManager:CreateParticle(particleName1, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.AmpDamageParticle1, 0, target:GetAbsOrigin())
		--ParticleManager:SetParticleControl(target.AmpDamageParticle1, 1, target:GetAbsOrigin())
		--ParticleManager:SetParticleControl(target.AmpDamageParticle1, 2, target:GetAbsOrigin())
	
		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end)
end

-- Destroys the particle when the modifier is destroyed
function EndAmplifyDamageParticle( event )
	local target = event.target
	if target ~= nil then
	ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
	ParticleManager:DestroyParticle(target.AmpDamageParticle1,false)
	end
end

--[[
	CHANGELIST
	09.01.2015 - Standized the variables
]]

--[[
	Author: kritth
	Date: 7.1.2015.
	Increasing stack after each hit
]]
function killer_instinct_attack( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_fury_swipes_target_datadriven"
	local damageType = ability:GetAbilityDamageType()
	local exceptionName = "put_your_exception_unit_here"
	
	-- Necessary value from KV
	local duration = ability:GetLevelSpecialValueFor( "bonus_reset_time", ability:GetLevel() - 1 )
	local damage_per_stack = ability:GetLevelSpecialValueFor( "damage_per_stack", ability:GetLevel() - 1 )
	if target:GetName() == exceptionName then	-- Put exception here
		duration = ability:GetLevelSpecialValueFor( "bonus_reset_time_roshan", ability:GetLevel() - 1 )
	end
	
	-- Check if unit already have stack
	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName, ability )
		
		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack * current_stack,
			damage_type = damageType
		}
		ApplyDamage( damage_table )
		
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, 1 )
	end
end