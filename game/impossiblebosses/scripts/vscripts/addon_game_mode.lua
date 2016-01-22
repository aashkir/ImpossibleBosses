-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('impossiblebosses')
require('attack')
require('bossfireai')
require('fireboss')
require('icebossai')
require('iceboss')
require('earthbossai')
require('earthboss')
require('powerballs')
require('waterboss')
require('waterbossai')



function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See ImpossibleBosses:PostLoadPrecache() in impossiblebosses.lua for more information
  ]]

  DebugPrint("[IMPOSSIBLEBOSSES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle",  "particles/units/heroes/hero_death_prophet/death_prophet_spirit_model.vpcf", context)
    PrecacheResource("particle",  "particles/units/heroes/hero_death_prophet/death_prophet_exorcism_attack.vpcf", context)
    PrecacheResource("particle",  "particles/units/heroes/hero_death_prophet/death_prophet_exorcism_attack_building.vpcf", context)
    PrecacheResource("particle",  "particles/units/heroes/hero_death_prophet/death_prophet_spirit_glow.vpcf", context)
   PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context)
    PrecacheResource( "particle" , "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", context)
    PrecacheResource(  "particle" , "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", context)
    PrecacheResource(  "particle" , "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf", context)
    PrecacheResource(  "soundfile","soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context)


  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle",  "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", context)
  PrecacheResource("particle",  "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_explosion_fallback_mid.vpcf", context)
  PrecacheResource("particle",  "particles/fireball2.vpcf", context)
  PrecacheResource("particle",  "particles/fireball3.vpcf", context)
  PrecacheResource("particle", "particles/fireballex.vpcf", context)
  PrecacheResource("particle", "particles/flamestrike.vpcf", context)
  PrecacheResource("particle", "particles/pulse.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_huskar/huskar_life_break.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", context)
  
  PrecacheResource("particle", "particles/flamestrikewarn.vpcf", context)
  PrecacheResource("particle", "particles/divinelight.vpcf", context)
  PrecacheResource("particle", "particles/sacredword.vpcf", context)
  PrecacheResource("particle", "particles/martyrdom.vpcf", context)
  PrecacheResource("particle", "particles/spiritwarrior.vpcf", context)
  PrecacheResource("particle", "particles/splash.vpcf", context)
  PrecacheResource("particle", "particles/waterball1.vpcf", context)
  PrecacheResource("particle", "particles/tornado.vpcf", context)
  PrecacheResource("particle", "particles/tornadoamb.vpcf", context)
  PrecacheResource("particle", "particles/tornadoactive.vpcf", context)
  PrecacheResource("particle", "particles/tornadoactiveamb.vpcf", context)
  PrecacheResource("particle", "particles/submerge.vpcf", context)
  PrecacheResource("particle", "particles/whirlpool.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_morphling/morphling_waveform.vpcf", context) --[[Returns:void
  Manually precache a single resource
  ]]
  --[["particle"  "particles/tornadoactive.vpcf"
    "particle"  "particles/units/heroes/hero_siren/naga_siren_riptide.vpcf"
    "particle" "particles/tornadoactiveamb.vpcf"]]
  PrecacheResource("particle",          "particles/status_fx/status_effect_life_stealer_rage.vpcf", context)
  PrecacheResource(      "particle",      "particles/status_fx/status_effect_keeper_spirit_form.vpcf", context)
  PrecacheResource(      "particle",      "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_cast.vpcf", context)
  PrecacheResource(      "particle",      "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"    , context)
  PrecacheResource("particle", "particles/ui/ui_generic_treasure_impact.vpcf", context) 
  PrecacheResource("particle", "particles/items3_fx/mango_active.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_ice_path.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context) 
   PrecacheResource("particle",          "particles/units/heroes/hero_wisp/wisp_guardian_.vpcf", context) 
   PrecacheResource("particle",          "particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", context) 
   PrecacheResource("particle",          "particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", context)
   PrecacheResource("particle",           "particles/units/heroes/hero_oracle/oracle_ambient_ball.vpcf", context)
   PrecacheResource("particle", "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf", context) 
   PrecacheResource("particle", "particles/items2_fx/tranquil_boots_healing.vpcf", context)
   PrecacheResource("particle", "particles/units/heroes/hero_skeletonking/skeletonking_reincarnation.vpcf", context) 

  PrecacheResource("particle",  "particles/hw_rosh_fireball.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)
  PrecacheResource("particle_folder", "particles/turbie", context)
  PrecacheResource("sound", "sounds/raze_flames.vsnd", context)
  PrecacheResource("sound", "sounds/weapons/creep/neutral/troll_priest_heal.vsnd", context)
  PrecacheResource("sound", "sounds/ui/inventory/treasure_reveal.vsnd", context)
  PrecacheResource("sound", "sounds/ui/treasure_01.vsnd", context)
  PrecacheResource("sound", "sounds/music/stingers/reincarnate_03.vsnd", context)
  PrecacheResource("sound", "sounds/weapons/hero/dazzle/weave.vsnd_c", context) 

  PrecacheResource("sound", "sounds/weapons/hero/naga_siren/riptide01.vsnd", context)
  PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context)
  PrecacheResource("particle", "particles/fireball4.vpcf", context)
  PrecacheResource("particle", "particles/quakeshake.vpcf", context)
  PrecacheResource("particle", "particles/magna.vpcf", context)

  PrecacheResource("particle", "particles/quake.vpcf", context)

  PrecacheResource("particle", "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_taunt_icemelt_explode.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf", context)



  --Models can also be precached by folder or individually
  --PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/props_gameplay/bottle_rejuvenation.vmdl" , context)
  PrecacheModel("models/props_gameplay/tpscroll01.vmdl", context)
  
  PrecacheModel("models/heroes/ancient_apparition/ancient_apparition.vmdl", context)
  PrecacheModel("models/heroes/earthshaker/earthshaker.vmdl", context)
  PrecacheModel("models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl", context )
  PrecacheModel("models/heroes/nerubian_assassin/mound.vmdl", context)
  PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
  PrecacheModel("models/items/lycan/wolves/icewrack_pack/icewrack_pack.vmdl", context)
  -- ES stuff
  PrecacheModel("models/heroes/earthshaker/totem.vmdl", context)
  PrecacheModel("models/heroes/earthshaker/bracers.vmdl", context)
  PrecacheModel("models/heroes/earthshaker/belt.vmdl", context)
  -- Dusa stuff
  PrecacheModel("models/items/medusa/blueice_armor/blueice_armor.vmdl", context)
  PrecacheModel("models/items/medusa/blueice_arms/blueice_arms.vmdl", context)
  PrecacheModel("models/items/medusa/blueice_head/blueice_head.vmdl", context)
  PrecacheModel("models/items/medusa/blueice_tail/blueice_tail.vmdl", context)
  PrecacheModel("models/items/medusa/blueice_weapon/blueice_weapon.vmdl", context)
  PrecacheModel("models/heroes/medusa/medusa.vmdl", context)
  -- Naga Minion
  PrecacheModel("models/heroes/siren/siren_armor.vmdl", context)
  PrecacheModel("models/heroes/siren/siren_hair.vmdl", context)
  PrecacheModel("models/heroes/siren/siren_tail.vmdl", context)
  PrecacheModel("models/heroes/siren/siren_weapon.vmdl", context)
  PrecacheModel("models/heroes/siren/siren.vmdl", context)
  -- Slar Minion
  PrecacheModel("models/heroes/slardar/slardar_bracers.vmdl", context)
  PrecacheModel("models/heroes/slardar/slardar_head.vmdl", context)
  PrecacheModel("models/heroes/slardar/slardar_back.vmdl", context)
  PrecacheModel("models/heroes/slardar/slardar_weapon.vmdl", context)
  PrecacheModel("models/heroes/slardar/slardar.vmdl", context)
  -- Spirit
  PrecacheModel("models/heroes/brewmaster/brewmaster_windspirit.vmdl", context)



    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context)
    PrecacheResource("soundfile", " soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context)  
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts", context)  
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context)  
    
    PrecacheResource("soundfile", "soundevents/game_sounds_ui_imported.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/soundevents_dota_ui.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_chen.vsndevts", context)
    PrecacheResource( "soundfile",     "soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts", context)
    PrecacheResource("soundfile",         "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context)
    PrecacheResource("soundfile",         "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context)
    PrecacheResource("soundfile",         "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context)
    PrecacheResource("soundfile",         "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
    PrecacheResource("soundfile", "sounds/claninvitation.vsnd", context)


    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts", context)
     PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_earthshaker.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_medusa.vsndevts", context)
    

--[[]
--[[]

    Manually precache a single resource
    ]]
  -- Sounds can precached here like anything else

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  --PrecacheItemByNameSync("example_ability", context)
  --PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  --PrecacheUnitByNameSync("npc_dota_hero_phantom_assassin_impossiblebosses", context)
  --PrecacheUnitByNameSync("npc_dota_hero_lone_druid_impossiblebosses", context)
   PrecacheUnitByNameSync("npc_dota_hero_wisp", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.ImpossibleBosses = ImpossibleBosses()
  GameRules.ImpossibleBosses:InitImpossibleBosses()
end
