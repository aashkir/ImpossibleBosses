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

	local quake = CreateUnitByName("npc_dota_quake", target, false, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	quake:AddNewModifier(caster, ability, "modifier_kill", {duration = 8})
	local startPos = quake:GetAbsOrigin()

	local particleName ="particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, quake )
	ParticleManager:SetParticleControl( pfx, 1, quake:GetAbsOrigin() )
	EmitSoundOn( "Hero_EarthSpirit.Magnetize.Cast", quake )

	Timers:CreateTimer( 0.03, function()
	if not quake:IsAlive() then
		ParticleManager:DestroyParticle(pfx,false)
		EmitSoundOn( "Hero_EarthSpirit.Magnetize.End", quake )
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
