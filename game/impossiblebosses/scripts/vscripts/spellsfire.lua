
--[[
	Author: kritth
	Date: 9.1.2015.
	Bubbles seen only to ally as pre-effect
]]
function torrent_bubble_allies( keys )
	local caster = keys.caster
	
	local allHeroes = HeroList:GetAllHeroes()
	local delay = keys.ability:GetLevelSpecialValueFor( "delay", keys.ability:GetLevel() - 1 )
	local particleName = "particles/pit_lava_glow.vpcf"
	local target = keys.target_points[1]
	
	for k, v in pairs( allHeroes ) do
		if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
			local fxIndex = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, v, PlayerResource:GetPlayer( v:GetPlayerID() ) )
			ParticleManager:SetParticleControl( fxIndex, 0, target )
			
			EmitSoundOnClient( "Hero_ElderTitan.EarthSplitter.Cast", PlayerResource:GetPlayer( v:GetPlayerID() ) )

			Timers:CreateTimer( delay + 1, function()
					EmitSoundOnClient( "Hero_Magnataur.ShockWave.Particle.Anvil", PlayerResource:GetPlayer( v:GetPlayerID() ) )
					return nil
					end)
			
			-- Destroy particle after delay
			Timers:CreateTimer( delay, function()
					EmitSoundOnClient( "Roshan.Slam", PlayerResource:GetPlayer( v:GetPlayerID() ) )
					ParticleManager:DestroyParticle( fxIndex, false )
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
	EmitSoundOn( "Hero_ElderTitan.EarthSplitter.Cast", dummy )
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

function RestoreMana( keys )
	
	local target = keys.unit
	local ability = keys.ability
	local restore_amount = ability:GetLevelSpecialValueFor("restore_amount", (ability:GetLevel() -1))
	local max_mana = 24
	local new_mana = target:GetMana() + max_mana

	print("test")
	print(max_mana)

	--target:GiveMana(max_mana)
	--target:RestoreMana(max_mana)

	if new_mana > target:GetMaxMana() then
		target:SetMana(target:GetMaxMana())
	else
		target:SetMana(new_mana)
	end
end

function spawn_volc( keys )
	local dummy = CreateUnitByName( "npc_dummy_unit", keys.target_points[1], false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	EmitSoundOn( "Hero_ElderTitan.EarthSplitter.Cast", dummy )
	dummy:ForceKill( true )
end