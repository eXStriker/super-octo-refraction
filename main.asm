INCLUDE "includes.asm"

INCLUDE "home.asm"
INCLUDE "battle/files.asm"
INCLUDE "data/files.asm"

SECTION "Code 1", ROMX, BANK[CODE_1]

INCLUDE "engine/map_objects.asm"

INCLUDE "engine/intro_menu.asm"

INCLUDE "gfx/initialize_map.asm"

INCLUDE "engine/learn.asm"

INCLUDE "engine/check_nick_errors.asm"

INCLUDE "engine/link_trade.asm"

INCLUDE "items/item_attributes.asm"
INCLUDE "engine/npc_movement.asm"

INCLUDE "engine/happiness.asm"

INCLUDE "engine/daycare.asm"

INCLUDE "engine/specials2.asm"

INCLUDE "engine/timeofdaypals.asm"

INCLUDE "engine/fruit_trees.asm"

INCLUDE "misc/mobile_function_refugees.asm"

ReadScriptVarMonName::
	ld hl, wPartyMonNicknames - PKMN_NAME_LENGTH
	ld bc, PKMN_NAME_LENGTH
	ld a, [hScriptVar]
	rst AddNTimes
	ld d, h
	ld e, l
	jp CopyName1

INCLUDE "battle/place_waiting_text.ctf"

INCLUDE "gfx/push_oam.asm"

SECTION "Code 2", ROMX, BANK[CODE_2]

INCLUDE "engine/color.asm"

INCLUDE "engine/printer.ctf"

INCLUDE "engine/customization.ctf"

INCLUDE "event/move_relearner.asm"

INCLUDE "event/poisonstep.asm"

INCLUDE "engine/pokedex2.asm"

; Another egg pic. This is shifted up a few pixels.
UnknownEggPic:: INCBIN "gfx/misc/unknown_egg.5x5.2bpp.lz"

SECTION "Code 3", ROMX, BANK[CODE_3]

INCLUDE "items/item_effects.asm"

SECTION "Code 4", ROMX, BANK[CODE_4]

INCLUDE "engine/pack.asm"
INCLUDE "engine/time.asm"
INCLUDE "engine/tmhm.asm"
INCLUDE "engine/namingscreen.ctf"

INCLUDE "event/itemball.asm"
INCLUDE "engine/healmachineanim.asm"
INCLUDE "event/whiteout.asm"
INCLUDE "event/itemfinder.asm"
INCLUDE "engine/startmenu.ctf"
INCLUDE "engine/selectmenu.asm"
INCLUDE "event/elevator.asm"

SetMemEvent:
	ld hl, wCurSignpostItemFlag
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld b, SET_FLAG
	predef_jump EventFlagAction

INCLUDE "engine/pokerus2.asm"

INCLUDE "event/magnet_train.asm"

INCLUDE "engine/crash_report.asm"

INCLUDE "engine/repel.asm"

INCLUDE "engine/signpost.ctf"

SECTION "Code 5", ROMX, BANK[CODE_5]

INCLUDE "engine/rtc.asm"
INCLUDE "engine/overworld.asm"
INCLUDE "engine/tile_events.asm"
INCLUDE "engine/save.asm"
INCLUDE "engine/spawn_points.asm"
INCLUDE "engine/map_setup.asm"
INCLUDE "engine/pokecenter_pc.asm"
INCLUDE "engine/mart.asm"
INCLUDE "engine/money.asm"
INCLUDE "items/marts.asm"
INCLUDE "event/bank.ctf"
INCLUDE "event/daycare.asm"
INCLUDE "engine/breeding.asm"

SECTION "Code 6", ROMX, BANK[CODE_6]

INCLUDE "engine/move_mon.asm"

INCLUDE "engine/breed_mon_growth.asm"

INCLUDE "engine/move_player_pic.asm"

INCLUDE "engine/name_player.asm"

INCLUDE "engine/playerpic.asm"

INCLUDE "text/battle.ctf"

INCLUDE "engine/player_step.asm"

INCLUDE "items/pokeball_wobble.asm"

SECTION "Code 7", ROMX, BANK[CODE_7]

INCLUDE "data/egg_moves.asm"
INCLUDE "engine/clock_reset.asm"

INCLUDE "engine/print_number.asm"

INCLUDE "event/hidden_item.asm"

INCLUDE "battle/badge_boosts.asm"

SECTION "Code 8", ROMX, BANK[CODE_8]

INCLUDE "engine/pokepic.asm"

INCLUDE "engine/objects.asm"

INCLUDE "engine/scrolling_menu.asm"
INCLUDE "engine/switch_items.asm"

INCLUDE "engine/mon_menu.asm"
INCLUDE "battle/menu.asm"
INCLUDE "engine/buy_sell_toss.asm"
INCLUDE "engine/trainer_card.asm"
INCLUDE "trainers/dvs.asm"

_ReturnToBattle_UseBall:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .gettutorialbackpic
	callba GetMonBackpic
	jr .continue

.gettutorialbackpic
	ld de, DudeBackpic
	lb bc, BANK(DudeBackpic), 6 * 6
	ld hl, VTiles2 tile $31
	call Get2bpp
.continue
	callba GetMonFrontpic
	callba _LoadBattleFontsHPBar
	ld b, SCGB_RAM
	predef GetSGBLayout
	call CloseWindow
	call LoadStandardMenuDataHeader
	call ApplyTilemapInVBlank
	jp SetPalettes

INCLUDE "battle/consume_held_item.asm"

MoveEffectsPointers: INCLUDE "battle/moves/move_effects_pointers.asm"

MoveEffects: INCLUDE "battle/moves/move_effects.asm"

INCLUDE "battle/effect_commands_2.asm"

INCLUDE "engine/player_movement.asm"

INCLUDE "engine/search.asm"

SECTION "Code 9", ROMX, BANK[CODE_9]

INCLUDE "engine/link.ctf"

INCLUDE "engine/wildmons.asm"

INCLUDE "battle/link_battle_result.asm"

SECTION "Code 10", ROMX, BANK[CODE_10]

INCLUDE "battle/trainer_huds.asm"

TrainerClassNames:: INCLUDE "text/trainer_class_names.asm"

INCLUDE "battle/ai/redundant.asm"

INCLUDE "event/move_deleter.asm"

INCLUDE "engine/tmhm2.asm"

MoveDescriptions:: INCLUDE "battle/moves/move_descriptions.ctf"

INCLUDE "engine/pokerus.asm"

INCLUDE "battle/initialize.asm"

INCLUDE "battle/music.asm"

INCLUDE "gfx/place_graphic.asm"

INCLUDE "engine/spawn_player.asm"

INCLUDE "engine/object_structs.asm"

INCLUDE "engine/walk_follow.asm"

INCLUDE "battle/abilities.asm"

INCLUDE "engine/heal_party.asm"

SECTION "Code 11", ROMX, BANK[CODE_11]

INCLUDE "engine/main_menu.ctf"

SECTION "Code 12", ROMX, BANK[CODE_12]

INCLUDE "battle/ai/move.asm"
INCLUDE "battle/ai/items.asm"

AIScoring: INCLUDE "battle/ai/scoring.asm"

INCLUDE "engine/mining.asm"
INCLUDE "engine/smelting.ctf"
INCLUDE "engine/jeweling.ctf"

LandmarkSignGFX:: INCBIN "gfx/misc/landmarksign.2bpp"

INCLUDE "event/forced_movement.asm"

SECTION "Code 13", ROMX, BANK[CODE_13]

INCLUDE "engine/pokedex.ctf"

INCLUDE "battle/moves/moves.asm"

INCLUDE "engine/evolve.asm"
INCLUDE "data/evos_attacks_pointers.asm"
INCLUDE "data/evos_attacks.asm"

INCLUDE "engine/printnum.asm"

SECTION "Code 14", ROMX, BANK[CODE_14]

INCLUDE "engine/prof_oaks_pc.asm"

ItemNames:: INCLUDE "items/item_names.asm"

INCLUDE "items/item_descriptions.ctf"

LevelUpHappinessMod:
	ld a, [wCurPartyMon]
	ld hl, PartyMon1CaughtLocation
	call GetPartyLocation
	ld a, [hl]
	and $7f
	ld d, a
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp d
	ld c, HAPPINESS_GAINLEVEL
	jr nz, .ok
	ld c, HAPPINESS_GAINLEVELATHOME
.ok
	jpba ChangeHappiness

MoveNames:: INCLUDE "battle/move_names.asm"

INCLUDE "engine/landmarks.asm"

INCLUDE "engine/math.asm"

INCLUDE "engine/vwf.asm"

INCLUDE "battle/hidden_power.asm"

INCLUDE "engine/sound_stack.asm"

SECTION "Code 15", ROMX, BANK[CODE_15]

INCLUDE "event/pachisi.ctf"

INCLUDE "engine/place_on_screen.asm"

INCLUDE "engine/items.asm"

MilosSwitchAction::
	call GetScriptHalfword
	ld e, l
	ld d, h
	push de
	ld b, CHECK_FLAG
	predef EventFlagAction
	pop de
	push af
	ld b, SET_FLAG
	jr z, .set
	ld b, RESET_FLAG
.set
	predef EventFlagAction
	call GetScriptHalfword
	ld d, h
	ld e, l
	call GetScriptHalfword
	pop af
	jr z, .okay
	ld d, h
	ld e, l
.okay
	ld a, [ScriptBank]
	ld b, a
	ret

SECTION "Code 16", ROMX, BANK[CODE_16]

INCLUDE "gfx/palettes.asm"
INCLUDE "tilesets/palette_maps.asm"

TileCollisionTable:: INCLUDE "tilesets/collision.asm"

INCLUDE "engine/save2.asm"

INCLUDE "engine/map_triggers.asm"

INCLUDE "engine/copy_tilemap_at_once.asm"

Shrink1Pic: INCBIN "gfx/shrink1.2bpp.lz"

Shrink2Pic: INCBIN "gfx/shrink2.2bpp.lz"

INCLUDE "misc/link_display.asm"

INCLUDE "engine/clock_password.asm"

Tilesets:: INCLUDE "tilesets/tileset_headers.asm"

INCLUDE "engine/trademon_pic.asm"

INCLUDE "engine/pokerus3.asm"

GiveANickname_YesNo:
	ld a, BANK(UnknownText_0x1c12fc)
	ld hl, UnknownText_0x1c12fc
	call FarPrintText
	jp YesNoBox

INCLUDE "engine/set_caught_data.asm"

INCLUDE "engine/find_pokemon.asm"

INCLUDE "engine/stats_screen.ctf"

INCLUDE "event/catch_tutorial.asm"

INCLUDE "engine/evolution_animation.asm"

INCLUDE "event/end_game.asm"

INCLUDE "battle/sliding_intro.asm"

INCLUDE "misc/gbc_only.ctf"

SECTION "Code 17", ROMX, BANK[CODE_17]

INCLUDE "engine/party_menu.ctf"
INCLUDE "event/sweet_scent.asm"

INCLUDE "engine/pokemon_structs.asm"

INCLUDE "engine/hp_bars.asm"

INCLUDE "engine/print_mon_stats.asm"

INCLUDE "engine/gender.asm"
INCLUDE "engine/show_pokemon_info.asm"
INCLUDE "engine/switch_party_mons.asm"

INCLUDE "gfx/load_pics.asm"

BaseData:: INCLUDE "data/base_stats.asm"

PokemonNames:: INCLUDE "data/pokemon_names.asm"

INCLUDE "engine/events_2.asm"

SECTION "Code 18", ROMX, BANK[CODE_18]

; linked, do not separate
INCLUDE "event/park_minigame.ctf"
INCLUDE "data/park_minigame.asm"
; end linked section

INCLUDE "engine/menu.asm"
INCLUDE "event/red_credits.asm"

INCLUDE "engine/find_free_box.asm"
INCLUDE "engine/fish.asm"

INCLUDE "engine/options_menu.ctf"

INCLUDE "engine/variables.asm"

SECTION "Code 19", ROMX, BANK[CODE_19]

INCLUDE "event/ballmaking.ctf"
INCLUDE "event/happiness_tutor.asm"

INCLUDE "engine/specials.asm"

SECTION "Code 20", ROMX, BANK[CODE_20]

INCLUDE "engine/battle_start.asm"

INCLUDE "engine/sprites.asm"

INCLUDE "engine/mon_icons.asm"

INCLUDE "engine/timeset.asm"
INCLUDE "engine/pokegear.asm"

INCLUDE "engine/script_conditionals.asm"

INCLUDE "event/qrcode.asm"

SECTION "Code 21", ROMX, BANK[CODE_21]

INCLUDE "engine/events.asm"
INCLUDE "engine/std_scripts.asm"

SECTION "Code 22", ROMX, BANK[CODE_22]

; linked, do not separate
INCLUDE "event/battle_tower.asm"
INCLUDE "text/battle_tower.ctf"
; end linked section

INCLUDE "engine/specials_move_tutor.asm"

INCLUDE "battle/bg_effects.asm"

SECTION "Code 23", ROMX, BANK[CODE_23]

INCLUDE "engine/time_capsule_conversion.asm"

SECTION "Code 24", ROMX, BANK[CODE_24]

INCLUDE "gfx/pics/animation.asm"
INCLUDE "engine/dateset.ctf"
INCLUDE "engine/treasure_bag.asm"

PackFGFX: INCBIN "gfx/misc/pack_f.2bpp"

SECTION "Code 25", ROMX, BANK[CODE_25]

INCLUDE "engine/slot_machine.asm"

INCLUDE "engine/field_moves.asm"
INCLUDE "engine/field_items.asm"

SECTION "Code 26", ROMX, BANK[CODE_26]
INCLUDE "engine/engine_flags.asm"

SECTION "Code 27", ROMX, BANK[CODE_27]

INCLUDE "event/bingo.ctf"

SECTION "Code 28", ROMX, BANK[CODE_28]

INCLUDE "battle/anims.asm"

INCLUDE "engine/print_bcd.asm"

SECTION "Code 29", ROMX, BANK[CODE_29]

; linked, do not separate
INCLUDE "battle/anim_objects.asm"
INCLUDE "battle/anim_commands.asm"
INCLUDE "engine/growl_roar_ded_vblank_hook.asm"
; end of linked section

INCLUDE "engine/experience.asm"

INCLUDE "engine/pop_mon.asm"

SECTION "Code 30", ROMX, BANK[CODE_30]

CheckTime::
	ld a, [TimeOfDay]
	ld hl, TimeOfDayTable
	ld e, 2
	call IsInArray
	inc hl
	ld c, [hl]
	ret

TimeOfDayTable:
	db MORN, 1 << MORN
	db DAY,  1 << DAY
	db NITE, 1 << NITE
	db -1, 0

SECTION "Code 31", ROMX, BANK[CODE_31]

INCLUDE "tilesets/animations.asm"

INCLUDE "event/halloffame.ctf"

INCLUDE "engine/compressed_text.asm"

SECTION "Code 32", ROMX, BANK[CODE_32]

INCLUDE "battle/anim_gfx.asm"

SECTION "Code 33", ROMX, BANK[CODE_33]

INCLUDE "event/card_flip.asm"
INCLUDE "engine/unown_puzzle.asm"
INCLUDE "event/memory_game.asm"
INCLUDE "engine/billspc.ctf"

INCLUDE "engine/stable_rng.asm"

SECTION "Code 34", ROMX, BANK[CODE_34]

INCLUDE "engine/crystal_intro.asm"

INCLUDE "engine/math16.asm"

INCLUDE "engine/stopwatch.asm"

IntroLogoGFX: INCBIN "gfx/intro/logo.2bpp.lz"

INCLUDE "engine/warp_connection.asm"

SECTION "Code 35", ROMX, BANK[CODE_35]

INCLUDE "engine/npctrade.asm"

SECTION "Code 36", ROMX, BANK[CODE_36]

INCLUDE "engine/hp_bars_2.asm"

INCLUDE "engine/anim_hp_bar.asm"
INCLUDE "event/sacred_ash.asm"

SECTION "Code 37", ROMX, BANK[CODE_37]

INCLUDE "engine/title.asm"

INCLUDE "engine/credits.ctf"

SECTION "Code 38", ROMX, BANK[CODE_38]

INCLUDE "misc/printer_77.ctf"

PrinterHPIcon: INCBIN "gfx/misc/hp.1bpp"
PrinterLvIcon: INCBIN "gfx/misc/lv.1bpp"

INCLUDE "event/catch_tutorial_2.asm"

INCLUDE "engine/diploma.ctf"

INCLUDE "event/judge.ctf"

QuestionMarkLZ: INCBIN "gfx/pics/questionmark/front.2bpp.lz"

INCLUDE "engine/print_time.asm"

INCLUDE "gfx/blank_screen.asm"

INCLUDE "engine/relative_facing.asm"

INCLUDE "engine/sine.asm"

INCLUDE "data/predefs.asm"

SECTION "Code 39", ROMX, BANK[CODE_39]

; linked, do not separate
INCLUDE "data/battle_arcade.asm"
INCLUDE "event/battle_arcade.ctf"
; end of linked section

INCLUDE "event/gold_tokens.asm"

SECTION "Code 40", ROMX, BANK[CODE_40]

; linked, do not separate
INCLUDE "event/cardgames.ctf"
INCLUDE "event/poker.ctf"
INCLUDE "event/blackjack.ctf"
; end of linked section

INCLUDE "engine/debug_menu.ctf"

SECTION "Code 41", ROMX, BANK[CODE_41]

INCLUDE "event/field_moves.asm"

SECTION "Code 42", ROMX, BANK[CODE_42]

INCLUDE "engine/fade.asm"

SECTION "Code 43", ROMX, BANK[CODE_43]

INCLUDE "battle/misc.asm"

SECTION "Code 44", ROMX, BANK[CODE_44]

INCLUDE "engine/hdma.asm"

SECTION "Code 45", ROMX, BANK[CODE_45]

INCLUDE "engine/font.asm"
