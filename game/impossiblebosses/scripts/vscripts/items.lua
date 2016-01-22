
function Speedused( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end


    if picker:HasModifier("tome_speed_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_speed_modifier", nil)
        picker:SetModifierStackCount("tome_speed_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_speed_modifier", picker, (picker:GetModifierStackCount("tome_speed_modifier", picker) + statBonus))
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 

end


function Healthused( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:IsRealHero() == false then
        picker = picker:GetPlayerOwner():GetAssignedHero()
    end


    if picker:HasModifier("tome_health_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_health_modifier", nil)
        picker:SetModifierStackCount("tome_health_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_health_modifier", picker, (picker:GetModifierStackCount("tome_health_modifier", picker) + statBonus))
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 

end
function Manaused( event )

    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:IsRealHero() == false then
        picker = picker:GetPlayerOwner():GetAssignedHero()
    end


    if picker:HasModifier("tome_mana_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_mana_modifier", nil)
        picker:SetModifierStackCount("tome_mana_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_mana_modifier", picker, (picker:GetModifierStackCount("tome_mana_modifier", picker) + statBonus))
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 

end

function Attackused( event )

    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:IsRealHero() == false then
        picker = picker:GetPlayerOwner():GetAssignedHero()
    end


    if picker:HasModifier("tome_attack_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_attack_modifier", nil)
        picker:SetModifierStackCount("tome_attack_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_attack_modifier", picker, (picker:GetModifierStackCount("tome_attack_modifier", picker) + statBonus))
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 

end


function InitKarma( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:IsRealHero() == false then
        picker = picker:GetPlayerOwner():GetAssignedHero()
    end


    if picker:HasModifier("tome_karma_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_karma_modifier", nil)
        picker:SetModifierStackCount("tome_karma_modifier", picker, statBonus)
        print(karma)
    else
        picker:SetModifierStackCount("tome_karma_modifier", picker, (picker:GetModifierStackCount("tome_karma_modifier", picker) + statBonus))
        print(karma)
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 

end

function ManaPot(event)
    local target = event.target
    target:GiveMana(300.0)
end

function SuperManaPot(event)
    local target = event.target
    target:GiveMana(500.0)
end

function SummonSpirits(event)
    local target = event.target
    local caster = event.caster
        local counter = 0
    Timers:CreateTimer(0.03, function()
    local angle = RandomInt(-180, 180)
    local origin = target:GetAbsOrigin() 
    local anglePos = QAngle(0, angle, 0)
    local forwardV = caster:GetForwardVector()
    local distance = RandomInt(0,500)
    local emergeradius = origin + forwardV * distance
    local emergeradius1  = RotatePosition(origin, anglePos, emergeradius)
    

            local minions = CreateUnitByName("npc_spirit", emergeradius1, true, caster, caster, caster:GetTeamNumber())
            minions:AddNewModifier(caster, ability, "modifier_kill", {duration = 12})

            pfx = ParticleManager:CreateParticle("particles/splash.vpcf", PATTACH_ABSORIGIN_FOLLOW, minions)
            minions:EmitSound("Hero_NagaSiren.Riptide.Cast")
            counter = counter + 1

            if counter <= 2 then
                return 0.2
            end
            end)
    end

function Resurrect(event)
    local caster = event.caster
    for i = 0, HeroList:GetHeroCount()-1 do -- so we can teleport DC'ers aswell
      --print( "i: " .. i )
    
      local hero = HeroList:GetHero( i )
       if not hero:IsAlive() then
          hero:RespawnUnit()
          hero:SetAbsOrigin(caster:GetAbsOrigin())
        FindClearSpaceForUnit(hero, caster:GetAbsOrigin(), true)
        hero:SetHealth( hero:GetMaxHealth() / 1.5 )
        hero:SetMana( hero:GetMaxMana() / 1.5 )
        end
    end
       
end

function GiveLoot(event)
    local chest = event.caster
    --local chestLoc = chest:GetAbsOrigin()
    local DropInfo = GameRules.DropTable[chest:GetUnitName()]

    chest:EmitSound("ui.treasure_reveal")

   if DropInfo then
        for k,ItemTable in pairs(DropInfo) do
            local chance = ItemTable.Chance or 100
            local max_drops = ItemTable.Multiple or 1
            local item_name = ItemTable.Item
            for i=1,max_drops do
                if RollPercentage(chance) then
                    print("Creating "..item_name)
                    local item = CreateItem(item_name, nil, nil)
                    item:SetPurchaseTime(0)
                    local pos = chest:GetAbsOrigin()
                    local drop = CreateItemOnPositionSync( pos, item )
                    local pos_launch = pos+RandomVector(RandomFloat(150,200))
                    item:LaunchLoot(false, 200, 0.75, pos_launch)
                end
            end
        end
    end
end