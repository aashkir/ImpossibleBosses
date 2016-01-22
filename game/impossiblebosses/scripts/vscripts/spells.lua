--[[
	Author: Noya
	Date: 15.01.2015.
	Swaps caster model and ability, gives a short period of invulnerability
]]


function TrueFormStart( event )
	local caster = event.caster
	local model = event.model
	local ability = event.ability
	local counter = caster:FindAbilityByName("counter_spell")
	local maul = caster:FindAbilityByName("maul")
	local star = caster:FindAbilityByName("star_strike")
	local shred = caster:FindAbilityByName("shred")
	local virtue = caster:FindAbilityByName("virtue")
	local rage = caster:FindAbilityByName("rage")

	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)

	-- Sets the new model
	caster:SetOriginalModel(model)

	-- Swap sub_ability
	local sub_ability_name = event.sub_ability_name
	local main_ability_name = ability:GetAbilityName()

	local sub_ability_name1 = maul:GetAbilityName()
	local main_ability_name1 = counter:GetAbilityName()

	local sub_ability_name2 = shred:GetAbilityName()
	local main_ability_name2 = star:GetAbilityName()

	local sub_ability_name3 = virtue:GetAbilityName()
	local main_ability_name3 = rage:GetAbilityName()


	caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)
	caster:SwapAbilities(main_ability_name1, sub_ability_name1, false, true)
	caster:SwapAbilities(main_ability_name2, sub_ability_name2, false, true)
	caster:SwapAbilities(sub_ability_name3, main_ability_name3, false, true)
	--TODO: Swap his other abilities with the wc3 stuff
	print("Swapped "..main_ability_name.." with " ..sub_ability_name)

end

-- Reverts back to the original model and attack type, swaps abilities, removes modifier passed
function TrueFormEnd( event )
	local caster = event.caster
	local ability = event.ability
	local modifier = event.remove_modifier_name
	local counter = caster:FindAbilityByName("counter_spell")
	local maul = caster:FindAbilityByName("maul")
	local star = caster:FindAbilityByName("star_strike")
	local shred = caster:FindAbilityByName("shred")
	local virtue = caster:FindAbilityByName("virtue")
	local rage = caster:FindAbilityByName("rage")



	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

	-- Swap the sub_ability back to normal
	local main_ability_name = event.main_ability_name
	local sub_ability_name = ability:GetAbilityName()

	local sub_ability_name1 = counter:GetAbilityName()
	local main_ability_name1 = maul:GetAbilityName()

	local sub_ability_name2 = shred:GetAbilityName()
	local main_ability_name2 = star:GetAbilityName()

	local sub_ability_name3 = virtue:GetAbilityName()
	local main_ability_name3 = rage:GetAbilityName()

	caster:SwapAbilities(sub_ability_name, main_ability_name, false, true)
	caster:SwapAbilities(main_ability_name1, sub_ability_name1, false, true)
	caster:SwapAbilities(sub_ability_name2, main_ability_name2, false, true)
	caster:SwapAbilities(main_ability_name3, sub_ability_name3, false, true)

	print("Swapped "..sub_ability_name.." with " ..main_ability_name)

	-- Remove modifier
	caster:RemoveModifierByName(modifier)
end



--[[Author: Noya
	Date: 09.08.2015.
	Hides all dem hats
]]
function HideWearables( event )
	local hero = event.caster
	local ability = event.ability

	hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
	local hero = event.caster

	for i,v in pairs(hero.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
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

	--[[local ability_name1 = event.ability_name
	local ability_handle1 = caster:FindAbilityByName(ability_name)	
	local ability_level1 = ability_handle1:GetLevel()]]--

	-- Check to not enter a level up loop
	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end

	--[[if ability_level1 ~= this_abilityLevel then
		ability_handle1:SetLevel(this_abilityLevel)
	end]]
end

function LevelUpAbility1( event )
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

function LevelUpAbility2( event )
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

function LevelUpAbility3( event )
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
	Author: Noya
	Date: 14.1.2015.
	If cast on an ally it will heal, if cast on an enemy it will do damage
]]
function DeathCoil( event )
	-- Variables
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "target_damage" , ability:GetLevel() - 1  )
	local self_damage = ability:GetLevelSpecialValueFor( "self_damage" , ability:GetLevel() - 1  )
	local heal = ability:GetLevelSpecialValueFor( "heal_amount" , ability:GetLevel() - 1 )
	local projectile_speed = ability:GetSpecialValueFor( "projectile_speed" )
	local particle_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"

	-- Play the ability sound
	caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")
	target:EmitSound("Hero_Abaddon.DeathCoil.Target")

	-- If the target and caster are on a different team, do Damage. Heal otherwise
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL })
	else
		target:Heal( heal, caster)
	end

	-- Self Damage
	ApplyDamage({ victim = caster, attacker = caster, damage = self_damage,	damage_type = DAMAGE_TYPE_PURE })

	-- Create the projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_name,
		bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = projectile_speed,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	ProjectileManager:CreateTrackingProjectile( info )


--[[
    Author: Bude
    Date: 29.09.2015
    Simply applies the lua modifier
--]]

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local modifiername = keys.ModifierName
    local duration = ability:GetDuration()

    target:AddNewModifier(caster, ability, modifiername, {Duration = duration})
end

end


--[[
	Author: Noya
	Date: 9.1.2015.
	Does non lethal magic damage to the caster
]]
function DoubleEdgeSelfDamage( event )
	-- Variables
	local caster = event.caster
	local ability = event.ability
	local self_damage = ability:GetLevelSpecialValueFor( "edge_damage" , ability:GetLevel() - 1  )
	local HP = caster:GetHealth()
	local MagicResist = caster:GetMagicalArmorValue()
	local damageType = ability:GetAbilityDamageType()

	-- Calculate the magic damage
	local damagePostReduction = self_damage * (1 - MagicResist)
	
	-- If its lethal damage, set hp to 1, else do the full self damage
	if HP <= damagePostReduction then
		caster:SetHealth(1)
	else
		-- Self Damage
		ApplyDamage({ victim = caster, attacker = caster, damage = self_damage,	damage_type = damageType })
	end

end

function DoubleEdgeParticle( event )
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local damageType = ability:GetAbilityDamageType()

	target:ReduceMana(25)

	local damage = ability:GetLevelSpecialValueFor( "bonus_damage" , ability:GetLevel() - 1  )
	if target:GetHealth()  <= target:GetMaxHealth()/5 then
		ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = damageType })
	end
	-- Particle
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- Destination
	ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin()) -- Hit Glow
end

function ReduceManas( event )
local ability = event.ability
	local caster = event.caster
	local target = event.target

	target:ReduceMana(50)

end