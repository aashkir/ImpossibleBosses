--[[
	Author: Ractidous
	Date: 28.01.2015.
	Start cooldown.
]]
function StartCooldown( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local cooldown = ability:GetCooldown( ability:GetLevel() - 1 )
	local modifierName = "modifier_liquid_fire_orb_datadriven"
	local fireball = caster:FindAbilityByName("bossattack")

	caster:CastAbilityOnTarget(target, fireball, -1) --[[Returns:void
	Cast an ability on a target entity.
	]]
	--[[Returns:void
	Cast an ability with no target. ( hAbility, iPlayerIndex )
	]]

	-- Start cooldown
	ability:EndCooldown()
	ability:StartCooldown( cooldown )

	-- Disable orb modifier
	caster:RemoveModifierByName( "modifier_liquid_fire_orb_datadriven" )

	-- Re-enable orb modifier after for the duration
	ability:SetContextThink( DoUniqueString("activateLiquidFire"), function ()
		-- Here's a magic
		-- Reset the ability level in order to restore a passive modifier
		ability.liquid_fire_forceEnableOrb = true
		ability:SetLevel( ability:GetLevel() )	
	end, cooldown)
end

function StartCooldownAi( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local targetid = target:GetPlayerID() --[[Returns:int
	Returns player ID of the player owning this hero
	]]
	local cooldown = ability:GetCooldown( ability:GetLevel() - 1 )
	local modifierName = "modifier_liquid_fire_orb_datadriven"
	local fireball = caster:FindAbilityByName("ai_attack")

	caster:CastAbilityOnTarget(target, fireball, targetid) --[[Returns:void
	Cast an ability on a target entity.
	]]
	--[[Returns:void
	Cast an ability with no target. ( hAbility, iPlayerIndex )
	]]

	-- Start cooldown
	ability:EndCooldown()
	ability:StartCooldown( cooldown )

	-- Disable orb modifier
	caster:RemoveModifierByName( "modifier_liquid_fire_orb_datadriven" )

	-- Re-enable orb modifier after for the duration
	ability:SetContextThink( DoUniqueString("activateLiquidFire"), function ()
		-- Here's a magic
		-- Reset the ability level in order to restore a passive modifier
		ability.liquid_fire_forceEnableOrb = true
		ability:SetLevel( ability:GetLevel() )	
	end, cooldown)
end


--[[
	Author: Ractidous
	Dage: 28.01.2015.
	Check orb modifer state on upgrading.
]]
function CheckOrbModifier( event )
	local ability = event.ability
	local caster = event.caster

	if ability.liquid_fire_forceEnableOrb then
		ability.liquid_fire_forceEnableOrb = nil
		return
	end

	if ability:IsCooldownReady() then
		return
	end

	caster:RemoveModifierByName( "modifier_liquid_fire_orb_datadriven" )
end