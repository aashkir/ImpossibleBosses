-- The overall game state has changed
function ImpossibleBosses:_OnGameRulesStateChange(keys)
  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
    self.bSeenWaitForPlayers = true
  elseif newState == DOTA_GAMERULES_STATE_INIT then
    --Timers:RemoveTimer("alljointimer")
  elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
    ImpossibleBosses:PostLoadPrecache()
    ImpossibleBosses:OnAllPlayersLoaded()

    if USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS then
      for i=0,9 do
        if PlayerResource:IsValidPlayer(i) then
          local color = TEAM_COLORS[PlayerResource:GetTeam(i)]
          PlayerResource:SetCustomPlayerColor(i, color[1], color[2], color[3])
        end
      end
    end
  elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then

    GameRules:SendCustomMessage("Welcome to " .. COLOR_GREEN .. " Impossible Bosses Reborn! " .. COLOR_NONE .. " by " .. COLOR_RED .. "poisonrune", DOTA_TEAM_NOTEAM, 0)
    CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Next Boss In", duration=50, mode=0, endfade=false, position=0, warning=5, paused=false, sound=false} )
 
  elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    ImpossibleBosses:OnGameInProgress()
    bossfireai:StartBossFire()
    --earthbossai:StartBossEarth()
    --waterbossai:StartBossWater()
  end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function ImpossibleBosses:_OnNPCSpawned(keys)
  local npc = EntIndexToHScript(keys.entindex)

  if npc:IsRealHero() and npc.bFirstSpawned == nil then

    npc.bFirstSpawned = true
    local player = npc:GetPlayerID()
    local playerName = npc:GetPlayerOwner()
    ImpossibleBosses:OnHeroInGame(npc)
    npc:AddItemByName("item_karma") 
    local karma = npc:GetModifierStackCount("tome_karma_modifier", npc)

    if npc == Entities:FindByName(nil, "npc_dota_hero_furion") and npc.bFirstSpawned then
             local ability0 = npc:FindAbilityByName("mystical_veil")
             ability0:SetLevel(1)
             local ability1 = npc:FindAbilityByName("lone_druid_true_form_datadriven")
             ability1:SetLevel(1)
             local ability2 = npc:FindAbilityByName("star_strike")
             ability2:SetLevel(1)
             local ability3 = npc:FindAbilityByName("counter_spell")
             ability3:SetLevel(1)
             local ability4 = npc:FindAbilityByName("virtue")
             ability4:SetLevel(1)
             npc:SetAbilityPoints(0)
             npc:SpendGold(480, 0)
           end

    if npc == Entities:FindByName(nil, "npc_dota_hero_warlock") and npc.bFirstSpawned then
             --local ability0 = npc:FindAbilityByName("mystical_veil")
             --ability0:SetLevel(1)
             local ability1 = npc:FindAbilityByName("mystical_veil")
             ability1:SetLevel(1)
             local ability2 = npc:FindAbilityByName("counter_spell")
             ability2:SetLevel(1)
             local ability3 = npc:FindAbilityByName("meteor_datadriven")
             ability3:SetLevel(1)
             local ability4 = npc:FindAbilityByName("fireball")
             ability4:SetLevel(1)
             local ability5 = npc:FindAbilityByName("scorch")
             ability5:SetLevel(1)
             npc:SetAbilityPoints(0)
             local ability6 = npc:FindAbilityByName("enrage_spirit")
             ability6:SetLevel(1)
             local ability7 = npc:FindAbilityByName("mana_aura")
             ability7:SetLevel(1)
             npc:SetAbilityPoints(0)
             npc:SpendGold(480, 0)
           end

    if npc == Entities:FindByName(nil, "npc_dota_hero_phantom_assassin") and npc.bFirstSpawned then
             --local ability0 = npc:FindAbilityByName("mystical_veil")
             --ability0:SetLevel(1)
             local ability1 = npc:FindAbilityByName("unbreakable_will")
             ability1:SetLevel(1)
             local ability2 = npc:FindAbilityByName("close_in")
             ability2:SetLevel(1)
             local ability3 = npc:FindAbilityByName("assasinate")
             ability3:SetLevel(1)
             local ability4 = npc:FindAbilityByName("killer_instinct")
             ability4:SetLevel(1)
             local ability5 = npc:FindAbilityByName("sprint")
             ability5:SetLevel(1)
             npc:SetAbilityPoints(0)
             local ability6 = npc:FindAbilityByName("expose_weakness")
             ability6:SetLevel(1)
             npc:SetAbilityPoints(0)
             npc:SpendGold(480, 0)
           end

    if npc == Entities:FindByName(nil, "npc_dota_hero_chen") and npc.bFirstSpawned then
             --local ability0 = npc:FindAbilityByName("mystical_veil")
             --ability0:SetLevel(1)
             local ability1 = npc:FindAbilityByName("divine_light")
             ability1:SetLevel(1)
             local ability2 = npc:FindAbilityByName("sacred_word")
             ability2:SetLevel(1)
             local ability3 = npc:FindAbilityByName("healing_wave")
             ability3:SetLevel(1)
             local ability4 = npc:FindAbilityByName("martyrdom")
             ability4:SetLevel(1)
             local ability5 = npc:FindAbilityByName("omni_flash")
             ability5:SetLevel(1)
             local ability6 = npc:FindAbilityByName("mystical_veil")
             ability6:SetLevel(1)
             npc:SetAbilityPoints(0)
             npc:SpendGold(480, 0)
           end

           if npc == Entities:FindByName(nil, "npc_dota_hero_dragon_knight") and npc.bFirstSpawned then
             --local ability0 = npc:FindAbilityByName("mystical_veil")
             --ability0:SetLevel(1)
             local ability1 = npc:FindAbilityByName("impenetrable_guard")
             ability1:SetLevel(1)
             local ability2 = npc:FindAbilityByName("battlecry")
             ability2:SetLevel(1)
             local ability3 = npc:FindAbilityByName("war_stomp")
             ability3:SetLevel(1)
             local ability4 = npc:FindAbilityByName("warrior_charge")
             ability4:SetLevel(1)
             local ability5 = npc:FindAbilityByName("warrior_spirit")
             ability5:SetLevel(1)
             npc:SetAbilityPoints(0)
             npc:SpendGold(480, 0)
           end

    GameRules:SendCustomMessage(COLOR_BLUE .. PlayerResource:GetPlayerName(player) .. COLOR_NONE .. ", You currently have ".. COLOR_GREEN .. karma .. " point(s).", DOTA_TEAM_NOTEAM, player)
 end       
end



-- An entity died
function ImpossibleBosses:_OnEntityKilled( keys )
  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

end



function ImpossibleBosses:_CheckForDefeat()
  if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    return
  end

  local bAllPlayersDead = true
  for nPlayers = 0, DOTA_MAX_TEAM_PLAYERS-1 do
    if PlayerResource:GetTeam( nPlayers ) == DOTA_TEAM_GOODGUYS then
      if not PlayerResource:HasSelectedHero( nPlayers ) then
        bAllPlayersDead = false
      else
        local hero = PlayerResource:GetSelectedHeroEntity( nPlayers )
        if hero and hero:IsAlive() then
          bAllPlayersDead = false
        end
      end
    end
  end

  if bAllPlayersDead then
      --[[bossfireai:KillBoss()
      Timers:CreateTimer(0.03, function()
      icebossai:KillBoss()
      end
      Timers:CreateTimer(0.03, function()
      earthbossai:KillBoss()
      end
      Timers:CreateTimer(0.03, function()
      waterbossai:KillBoss()
      end

      GameRules:ResetDefeated()
      GameRules:ResetToHeroSelection()]]--
      GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS) 
  end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function ImpossibleBosses:_OnConnectFull(keys)
  ImpossibleBosses:_CaptureImpossibleBosses()

  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  local userID = keys.userid

  self.vUserIds = self.vUserIds or {}
  self.vUserIds[userID] = ply
end
