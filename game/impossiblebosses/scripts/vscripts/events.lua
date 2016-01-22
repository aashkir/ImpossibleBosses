-- This file contains all impossiblebosses-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the ImpossibleBosses:_Function calls in these events as it will mess with the internal impossiblebosses systems.

-- Cleanup a player when they leave
function ImpossibleBosses:OnDisconnect(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid
  local player = PlayerResource:GetPlayer(keys.userid)

end
-- The overall game state has changed
function ImpossibleBosses:OnGameRulesStateChange(keys)
  DebugPrint("[IMPOSSIBLEBOSSES] GameRules State Changed")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main impossiblebosses functions
  ImpossibleBosses:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function ImpossibleBosses:OnNPCSpawned(keys)
  DebugPrint("[IMPOSSIBLEBOSSES] NPC Spawned")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main impossiblebosses functions
  ImpossibleBosses:_OnNPCSpawned(keys)

  local npc = EntIndexToHScript(keys.entindex)
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function ImpossibleBosses:OnEntityHurt(keys)
  --DebugPrint("[IMPOSSIBLEBOSSES] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function ImpossibleBosses:OnItemPickedUp(keys)
  DebugPrint( '[IMPOSSIBLEBOSSES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function ImpossibleBosses:OnPlayerReconnect(keys)
  DebugPrint( '[IMPOSSIBLEBOSSES] OnPlayerReconnect' )
  DebugPrintTable(keys) 
  local plyID = keys.PlayerID
  local ply = PlayerResource:GetPlayer(plyID)
  local plyh = ply:GetAssignedHero()
Timers:CreateTimer(0.03, function()
   for i=0,DOTA_MAX_TEAM_PLAYERS-1 do
  player = PlayerResource:GetPlayer(i)
  if player ~= nil then
  local hero = player:GetAssignedHero()

  plyh:SetAbsOrigin(hero)
  else return 1
  end
end

end)

end

-- An item was purchased by a player
function ImpossibleBosses:OnItemPurchased( keys )
  DebugPrint( '[IMPOSSIBLEBOSSES] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function ImpossibleBosses:OnAbilityUsed(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function ImpossibleBosses:OnNonPlayerUsedAbility(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function ImpossibleBosses:OnPlayerChangedName(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function ImpossibleBosses:OnPlayerLearnedAbility( keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function ImpossibleBosses:OnAbilityChannelFinished(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function ImpossibleBosses:OnPlayerLevelUp(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function ImpossibleBosses:OnLastHit(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function ImpossibleBosses:OnTreeCut(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function ImpossibleBosses:OnRuneActivated (keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function ImpossibleBosses:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function ImpossibleBosses:OnPlayerPickHero(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function ImpossibleBosses:OnTeamKillCredit(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function ImpossibleBosses:OnEntityKilled( keys )
  DebugPrint( '[IMPOSSIBLEBOSSES] OnEntityKilled Called' )
  DebugPrintTable( keys )

  ImpossibleBosses:_OnEntityKilled( keys )
  

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Put code here to handle when an entity gets killed

  if killedUnit and killedUnit:IsRealHero() then

    local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
    newItem:SetPurchaseTime( 0 )
    newItem:SetPurchaser( killedUnit )
    local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
    tombstone:SetContainedItem( newItem )
    tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
    FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true ) 
    
    Timers:CreateTimer(6, function()
    ImpossibleBosses:_CheckForDefeat()
    end)
end

end



-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function ImpossibleBosses:PlayerConnect(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function ImpossibleBosses:OnConnectFull(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnConnectFull')
  DebugPrintTable(keys)

  ImpossibleBosses:_OnConnectFull(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function ImpossibleBosses:OnIllusionsCreated(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function ImpossibleBosses:OnItemCombined(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function ImpossibleBosses:OnAbilityCastBegins(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function ImpossibleBosses:OnTowerKill(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function ImpossibleBosses:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end



-- This function is called whenever an NPC reaches its goal position/target
function ImpossibleBosses:OnNPCGoalReached(keys)
  DebugPrint('[IMPOSSIBLEBOSSES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function ImpossibleBosses:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = self.vUserIds[userID]:GetPlayerID()
  local text = keys.text
  if text == "tpme" then
   --earthbossai:Ultimate()
   --earthbossai:StartBossEarth()
   bossfireai:StartBossFire()
   --waterbossai:StartBossWater()
   --waterbossai:tornado()
   --icebossai:StartBossIce()
   --waterbossai:Waves()
  end
  if text == "tor" then
    --waterbossai:Waves()
  end
end

function ImpossibleBosses:RefreshPlayers()
  for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
    if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
      if PlayerResource:HasSelectedHero( nPlayerID ) then
        local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
        if not hero:IsAlive() then
          hero:RespawnUnit()
        end

        if hero:HasItemInInventory("item_token") then
           for i=0,5,1 do 
                local item = hero:GetItemInSlot(i)
                if  item ~= nil and item:GetName()  == "item_token" then
                    hero:RemoveItem(item)
                end
              end
          hero:EmitSound("General.CoinsBig")
          local coinfx = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN, hero)
          ParticleManager:SetParticleControl(coinfx, 1, hero:GetAbsOrigin())
          hero:SetGold(hero:GetGold()+22, true)
        end

        hero:SetHealth( hero:GetMaxHealth() )
        hero:SetMana( hero:GetMaxMana() )

        hero:SetGold(hero:GetGold()+45, true)
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(nPlayerID) .. COLOR_NONE .. ", You have been granted".. COLOR_GREEN .. "45 gold.", DOTA_TEAM_NOTEAM, nPlayerID)
        
      end
    end
  end
end


function ImpossibleBosses:TeleportHome( events )
local spawn = Entities:FindByName( nil, "ent_dota_fountain" )
local spawnLocation = spawn:GetAbsOrigin()    
self:RefreshPlayers()   
Timers:CreateTimer(44, function()

  icebossai:StartBossIce()
  end)

Timers:CreateTimer(4, function()
EmitGlobalSound("IB.win") 

for i = 0, HeroList:GetHeroCount()-1 do -- so we can teleport DC'ers aswell
      --print( "i: " .. i )
    
      local hero = HeroList:GetHero( i )
      local player = PlayerResource:GetPlayer(i)
    
        --local hero = player:GetAssignedHero() -- hero handle
        hero:SetAbsOrigin(spawnLocation)
        
        FindClearSpaceForUnit(hero, spawnLocation, true)
        hero:SetModifierStackCount("tome_karma_modifier", hero, (hero:GetModifierStackCount("tome_karma_modifier", hero) + 1))
        local karma = hero:GetModifierStackCount("tome_karma_modifier", hero)
       

    if player ~= nil then 
        local playerID = player:GetPlayerID()
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(playerID) .. COLOR_NONE .. ", You have been granted".. COLOR_GREEN .. "1 Karma point.", DOTA_TEAM_NOTEAM, playerID)
        PlayerResource:SetCameraTarget(i, hero)
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(playerID) .. COLOR_NONE .. ", You currently have ".. COLOR_GREEN .. karma .. " point(s).", DOTA_TEAM_NOTEAM, playerID)
    end

end

Timers:CreateTimer(2, function()
  for i=0, DOTA_MAX_TEAM_PLAYERS-1  do
    local playerid = PlayerResource:GetPlayer(i)
    if playerid ~= nil then 
      PlayerResource:SetCameraTarget(i, nil) -- Remove Camera Lock
    end
  end
end)

Timers:CreateTimer(2, function()
      local chest = CreateUnitByName( "npc_treasure", spawnLocation, true, nil, nil,  DOTA_TEAM_BADGUYS)

      local particle1 = ParticleManager:CreateParticle("particles/ui/ui_generic_treasure_impact.vpcf", PATTACH_ABSORIGIN, chest)
      --local chest:EmitSound(string soundName)
      ParticleManager:SetParticleControl(particle1, 1, chest:GetAbsOrigin())
  end)
CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Next Boss In", duration=40, mode=0, endfade=false, position=0, warning=5, paused=false, sound=false} )
 
end)

end




function ImpossibleBosses:TeleportHomeIce( events )
local spawn = Entities:FindByName( nil, "ent_dota_fountain" )
local spawnLocation = spawn:GetAbsOrigin()   
self:RefreshPlayers()   

Timers:CreateTimer(44, function()

  earthbossai:StartBossEarth()
  end)

Timers:CreateTimer(4, function()
EmitGlobalSound("IB.win") 
for i = 0, HeroList:GetHeroCount()-1 do -- so we can teleport DC'ers aswell
      --print( "i: " .. i )
    
      local hero = HeroList:GetHero( i )
      local player = PlayerResource:GetPlayer(i)
    
        --local hero = player:GetAssignedHero() -- hero handle
        hero:SetAbsOrigin(spawnLocation)
        
        FindClearSpaceForUnit(hero, spawnLocation, true)
        hero:SetModifierStackCount("tome_karma_modifier", hero, (hero:GetModifierStackCount("tome_karma_modifier", hero) + 1))
        local karma = hero:GetModifierStackCount("tome_karma_modifier", hero)
       

    if player ~= nil then 
        local playerID = player:GetPlayerID()
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(playerID) .. COLOR_NONE .. ", You have been granted".. COLOR_GREEN .. "1 Karma point.", DOTA_TEAM_NOTEAM, playerID)
        PlayerResource:SetCameraTarget(i, hero)
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(playerID) .. COLOR_NONE .. ", You currently have ".. COLOR_GREEN .. karma .. " point(s).", DOTA_TEAM_NOTEAM, playerID)
    end
end

Timers:CreateTimer(2, function()
  for i=0, DOTA_MAX_TEAM_PLAYERS-1  do
    local playerid = PlayerResource:GetPlayer(i)
    if playerid ~= nil then 
      PlayerResource:SetCameraTarget(i, nil) -- Remove Camera Lock
    end
  end
end)

Timers:CreateTimer(2, function()
      local chest = CreateUnitByName( "npc_treasure", spawnLocation, true, nil, nil,  DOTA_TEAM_BADGUYS)
      local particle1 = ParticleManager:CreateParticle("particles/ui/ui_generic_treasure_impact.vpcf", PATTACH_ABSORIGIN, chest)
      --local chest:EmitSound(string soundName)
      ParticleManager:SetParticleControl(particle1, 1, chest:GetAbsOrigin())
  end)
CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Next Boss In", duration=40, mode=0, endfade=false, position=0, warning=5, paused=false, sound=false} )
 
end)

end


function ImpossibleBosses:TeleportHomeEarth( events )
local spawn = Entities:FindByName( nil, "ent_dota_fountain" )
local spawnLocation = spawn:GetAbsOrigin()   
self:RefreshPlayers()   

Timers:CreateTimer(44, function()

  waterbossai:StartBossWater()
  end)

Timers:CreateTimer(4, function()
EmitGlobalSound("IB.win") 

for i = 0, HeroList:GetHeroCount()-1 do -- so we can teleport DC'ers aswell
      --print( "i: " .. i )
    
      local hero = HeroList:GetHero( i )
      local player = PlayerResource:GetPlayer(i)
    
        --local hero = player:GetAssignedHero() -- hero handle
        hero:SetAbsOrigin(spawnLocation)
        
        FindClearSpaceForUnit(hero, spawnLocation, true)
        hero:SetModifierStackCount("tome_karma_modifier", hero, (hero:GetModifierStackCount("tome_karma_modifier", hero) + 1))
        local karma = hero:GetModifierStackCount("tome_karma_modifier", hero)
       

    if player ~= nil then 
        local playerID = player:GetPlayerID()
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(playerID) .. COLOR_NONE .. ", You have been granted".. COLOR_GREEN .. "1 Karma point.", DOTA_TEAM_NOTEAM, playerID)
        PlayerResource:SetCameraTarget(i, hero)
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(playerID) .. COLOR_NONE .. ", You currently have ".. COLOR_GREEN .. karma .. " point(s).", DOTA_TEAM_NOTEAM, playerID)
    end
end


Timers:CreateTimer(2, function()
  for i=0, DOTA_MAX_TEAM_PLAYERS-1  do
    local playerid = PlayerResource:GetPlayer(i)
    if playerid ~= nil then 
      PlayerResource:SetCameraTarget(i, nil) -- Remove Camera Lock
    end
  end
end)

Timers:CreateTimer(2, function()
      local chest = CreateUnitByName( "npc_treasure", spawnLocation, true, nil, nil,  DOTA_TEAM_BADGUYS)
      local particle1 = ParticleManager:CreateParticle("particles/ui/ui_generic_treasure_impact.vpcf", PATTACH_ABSORIGIN, chest)
      --local chest:EmitSound(string soundName)
      ParticleManager:SetParticleControl(particle1, 1, chest:GetAbsOrigin())
  end)
CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Next Boss In", duration=40, mode=0, endfade=false, position=0, warning=5, paused=false, sound=false} )
 
end)

end

function ImpossibleBosses:TeleportHomeWater( events )
local spawn = Entities:FindByName( nil, "ent_dota_fountain" )
local spawnLocation = spawn:GetAbsOrigin()   
self:RefreshPlayers()   

Timers:CreateTimer(44, function()

  --earthbossai:StartBossEarth()
  end)

Timers:CreateTimer(4, function()
EmitGlobalSound("IB.win") 

for i = 0, HeroList:GetHeroCount()-1 do -- so we can teleport DC'ers aswell
      --print( "i: " .. i )
    
      local hero = HeroList:GetHero( i )
      local player = PlayerResource:GetPlayer(i)
    
        --local hero = player:GetAssignedHero() -- hero handle
        hero:SetAbsOrigin(spawnLocation)
        
        FindClearSpaceForUnit(hero, spawnLocation, true)
        hero:SetModifierStackCount("tome_karma_modifier", hero, (hero:GetModifierStackCount("tome_karma_modifier", hero) + 1))
        local karma = hero:GetModifierStackCount("tome_karma_modifier", hero)
       

    if player ~= nil then 
        local playerID = player:GetPlayerID()
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(playerID) .. COLOR_NONE .. ", You have been granted".. COLOR_GREEN .. "1 Karma point.", DOTA_TEAM_NOTEAM, playerID)
        PlayerResource:SetCameraTarget(i, hero)
        GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(playerID) .. COLOR_NONE .. ", You currently have ".. COLOR_GREEN .. karma .. " point(s).", DOTA_TEAM_NOTEAM, playerID)
    end
end


Timers:CreateTimer(2, function()
  for i=0, DOTA_MAX_TEAM_PLAYERS-1  do
    local playerid = PlayerResource:GetPlayer(i)
    if playerid ~= nil then 
      PlayerResource:SetCameraTarget(i, nil) -- Remove Camera Lock
    end
  end
end)

Timers:CreateTimer(2, function()
      local chest = CreateUnitByName( "npc_treasure", spawnLocation, true, nil, nil,  DOTA_TEAM_BADGUYS)
      local particle1 = ParticleManager:CreateParticle("particles/ui/ui_generic_treasure_impact.vpcf", PATTACH_ABSORIGIN, chest)
      --local chest:EmitSound(string soundName)
      ParticleManager:SetParticleControl(particle1, 1, chest:GetAbsOrigin())
  end)
GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
--CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Next Boss In", duration=40, mode=0, endfade=false, position=0, warning=5, paused=false, sound=false} )
 
end)

end