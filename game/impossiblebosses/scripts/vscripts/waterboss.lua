if waterboss == nil then
  waterboss = class({})
end


--[[Author: Pizzalol
    Date: 21.09.2015.
    Prepares all the required information for movement]]
function TimeWalk( keys )
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local target_point = keys.target_points[1]
    local ability = keys.ability
    local caster_aura = keys.caster_aura

    -- Distance calculations
    local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
    local distance = (target_point - caster_location):Length2D()
    local direction = (target_point - caster_location):Normalized()
    local duration = distance/speed

    -- Saving the data in the ability
    ability.time_walk_distance = distance
    ability.time_walk_speed = speed * 1/30 -- 1/30 is how often the motion controller ticks
    ability.time_walk_direction = direction
    ability.time_walk_traveled_distance = 0

    -- Apply the slow aura and invlunerability modifier to the caster
    ability:ApplyDataDrivenModifier(caster, caster, caster_aura, {duration = duration})
    caster:AddNewModifier(caster, nil, "modifier_invulnerable", nil)
end

--[[Author: Pizzalol
    Date: 21.09.2015.
    Moves the target until it has traveled the distance to the chosen point]]
function TimeWalkMotion( keys )
    local caster = keys.target
    local ability = keys.ability
    local model = "models/development/invisiblebox.vmdl"
    -- Saves the original model and attack capability
    if caster.caster_model == nil then 
        caster.caster_model = caster:GetModelName()
    end

    -- Move the caster while the distance traveled is less than the original distance upon cast
    if ability.time_walk_traveled_distance < ability.time_walk_distance then
        caster.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = caster:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(caster.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
        caster:AddEffects(EF_NODRAW)
        pfx = ParticleManager:CreateParticle("particles/splash.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.time_walk_direction * ability.time_walk_speed)
        ability.time_walk_traveled_distance = ability.time_walk_traveled_distance + ability.time_walk_speed
    else
        -- Remove the motion controller once the distance has been traveled
        caster:InterruptMotionControllers(false)
        caster:RemoveModifierByName("modifier_invulnerable")
    for i,v in pairs(caster.hiddenWearables) do
        v:RemoveEffects(EF_NODRAW)
    end
        caster:RemoveEffects(EF_NODRAW)
        caster:SetModel(caster.caster_model)
        caster:SetOriginalModel(caster.caster_model)
    end
end


function GoUnder( keys )
    local model = "models/development/invisiblebox.vmdl"
    local caster = keys.caster
    local ability = keys.ability
    local caster_aura = keys.caster_aura

    -- Saves the original model and attack capability
    if caster.caster_model == nil then 
        caster.caster_model = caster:GetModelName()
    end

    local center = Entities:FindByName(nil, "npc_dota_waterplacer"):GetAbsOrigin()
    if center ~= nil then
    ability:ApplyDataDrivenModifier(caster, caster, caster_aura, {duration = duration})
    caster:AddNewModifier(caster, nil, "modifier_disarmed", nil)
    caster:AddNewModifier(fireboss, nil, "modifier_invulnerable", nil)
        -- Hide Boss
    caster.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = caster:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(caster.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
        caster:AddEffects(EF_NODRAW)
        pfx = ParticleManager:CreateParticle("particles/submerge.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        Timers:CreateTimer(2, function()
    local angle = RandomInt(-180, 180)
    local origin = center
    local anglePos = QAngle(0, angle, 0)
    local forwardV = caster:GetForwardVector()
    local distance = RandomInt(0,1500)
    local emergeradius = origin + forwardV * distance
    local emergeradius1  = RotatePosition(origin, anglePos, emergeradius)
        
            caster:SetAbsOrigin(emergeradius1)
            pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            end)
    end

end

function GoOver( keys )
    local caster = keys.caster
    for i,v in pairs(caster.hiddenWearables) do
        v:RemoveEffects(EF_NODRAW)
    end
        caster:RemoveEffects(EF_NODRAW)
        caster:RemoveModifierByName("modifier_disarmed")
        caster:RemoveModifierByName("modifier_invulnerable")
end

function SpawnMinions ( keys )
    local caster = keys.caster
    local center = Entities:FindByName(nil, "npc_dota_waterplacer"):GetAbsOrigin()
    if center ~= nil then
    local counter = 0
    caster:EmitSound("medusa_medus_attack_14")
    Timers:CreateTimer(2, function()
    local angle = RandomInt(-180, 180)
    local origin = center
    local anglePos = QAngle(0, angle, 0)
    local forwardV = caster:GetForwardVector()
    local distance = RandomInt(0,1500)
    local emergeradius = origin + forwardV * distance
    local emergeradius1  = RotatePosition(origin, anglePos, emergeradius)
    local randPoint = 
      {
      "npc_minion_slardar",
      "npc_minion_siren",
      }
            
            local r = randPoint[RandomInt(1,#randPoint)]

            local minions = CreateUnitByName(r, emergeradius1, true, caster, caster, caster:GetTeamNumber())
            minions:AddNewModifier(caster, ability, "modifier_kill", {duration = 12})

            pfx = ParticleManager:CreateParticle("particles/splash.vpcf", PATTACH_ABSORIGIN_FOLLOW, minions)
            minions:EmitSound("Hero_NagaSiren.Riptide.Cast")
            counter = counter + 1

            if counter <= 6 then
                return 0.2
            end
            end)
    end
end


function whirl_pool( keys )
    local caster = keys.caster

  if hero == nil then
  for i=0,DOTA_MAX_TEAM_PLAYERS-1 do
  player = PlayerResource:GetPlayer(i)
  if player ~= nil then
  local hero = player:GetAssignedHero()
  if hero ~= nil then
  Physics:Unit(hero)
    end
else
    print('nil')
end
  end
end

  local counter = 0
  Physics:Unit(caster)
  collider = caster:AddColliderFromProfile("gravity")
  --collider.draw = {color = Vector(200,50,200), alpha = 0}
  collider.radius = 1900
  collider.force = 1000
  collider.linear = false
  collider.test = function(self, collider, collided)

    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
    end

  Timers:CreateTimer(0.03, function()
   if counter < 8 then

    counter = counter + 1
    print(counter)
    return 1
    else
        caster:RemoveCollider()
        print("removed collider")
    end
 end)

local ability = keys.ability
local dusa = keys.caster
local numIce = 0
local angle = 0

Timers:CreateTimer( function()
local randomvec = RandomInt( -10, 10 )
        local origin = dusa:GetAbsOrigin() 
        local anglePos = QAngle(0, angle, 0)
        local forwardV = dusa:GetForwardVector()
        local distance = 800
        local casterLocRotated = RotatePosition(dusa:GetAbsOrigin(), anglePos, origin * 100)
        local casterLoc = RotatePosition(casterLocRotated, anglePos, origin) --[[Returns:Vector
        Rotate a ''Vector'' around a point.
        ]]
        local forwardVec = origin - casterLocRotated
        forwardVec = forwardVec:Normalized()
    

        local Velocityvec = Vector( forwardVec.x, forwardVec.y, 0 )

-- Ship this to flameburst later
    local projectileTable = {
                Ability = ability,
                EffectName = "particles/waterball1.vpcf",
                vSpawnOrigin = origin,
                fDistance = distance,
                fStartRadius = 50,
                fEndRadius = 50,
                Source = dusa,
                bHasFrontalCone = false,
                bReplaceExisting = false,
                bProvidesVision = false,
                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL,
                vVelocity = Velocityvec * 400
            }
            ProjectileManager:CreateLinearProjectile( projectileTable )
            numIce = numIce + 1
            angle = angle + 40
            if 
                numIce >= 60 then
                            return nil
            else
                return 0.12
            end
        end
    )

end

function march_of_the_machines_spawn( keys )
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
    local dummyModifierName = "modifier_waves_datadriven"
    
    -- Find forward vector
    local forwardVec = targetLoc - casterLoc
    forwardVec = forwardVec:Normalized()
    
    -- Find backward vector
    local backwardVec = casterLoc - targetLoc
    backwardVec = backwardVec:Normalized()
    
    -- Find middle point of the spawning line
    local middlePoint = casterLoc + ( radius * backwardVec )
    
    -- Find perpendicular vector
    local v = middlePoint - casterLoc
    local dx = -v.y
    local dy = v.x
    local perpendicularVec = Vector( dx, dy, v.z )
    perpendicularVec = perpendicularVec:Normalized()
    
    -- Create dummy to store data in case of multiple instances are called
    local dummy = CreateUnitByName( "npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
    ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
    dummy.march_of_the_machines_num = 0
    
    -- Create timer to spawn projectile
    Timers:CreateTimer( function()
            -- Get random location for projectile
            local random_distance = RandomInt( -radius, radius )
            local spawn_location = middlePoint + perpendicularVec * random_distance
            
            local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )
            
            -- Spawn projectiles
            local projectileTable = {
                Ability = ability,

                EffectName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
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
            
            -- Increment the counter
            dummy.march_of_the_machines_num = dummy.march_of_the_machines_num + 1
            
            -- Check if the number of machines have been reached
            if dummy.march_of_the_machines_num == machines_per_sec * duration then
                dummy:Destroy()
                return nil
            else
                return 1 / machines_per_sec
            end
        end
    )
end