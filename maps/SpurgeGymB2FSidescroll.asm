SpurgeGymB2FSidescroll_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SpurgeGymB2FSidescrollSignpost1:
	opentext
	checkevent EVENT_SPURGE_GYM_SWITCH_ENABLED
	iffalse SpurgeGymB2FSidescroll_2ff485
	writetext SpurgeGymB2FSidescrollSignpost1_Text_2ff4b8
	yesorno
	iftrue SpurgeGymB2FSidescroll_2ff48b
	closetext
	end

SpurgeGymB2FSidescrollNPC1:
	setevent EVENT_SPURGE_GYM_POKEMON_2
	farjump SpurgeGymGetPokemon

SpurgeGymB2FSidescrollNPC2:
	setevent EVENT_SPURGE_GYM_POKEMON_5
	farjump SpurgeGymGetPokemon

SpurgeGymB2FSidescroll_2ff485:
	writetext SpurgeGymB2FSidescroll_2ff485_Text_2ff4d2
	endtext

SpurgeGymB2FSidescroll_2ff48b:
	playsound SFX_ENTER_DOOR
	checkevent EVENT_0
	iftrue SpurgeGymB2FSidescroll_2ff4a6
	changeblock 18, 10, $52
	changeblock 18, 12, $51
	changeblock 2, 12, $6b
	setevent EVENT_0
	reloadmappart
	closetext
	end

SpurgeGymB2FSidescroll_2ff4a6:
	changeblock 18, 10, $67
	changeblock 18, 12, $68
	changeblock 2, 12, $6a
	clearevent EVENT_0
	reloadmappart
	closetext
	end

SpurgeGymB2FSidescrollSignpost1_Text_2ff4b8:
	ctxt "Want to pull the"
	line "switch?"
	done

SpurgeGymB2FSidescroll_2ff485_Text_2ff4d2:
	ctxt "This switch is"
	line "disabled!"
	done

SpurgeGymB2FSidescroll_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 5, 25, 2, SPURGE_GYM_B1F
	warp_def 5, 5, 1, SPURGE_GYM_B2F

.CoordEvents: db 0

.BGEvents: db 1
	signpost 12, 2, SIGNPOST_READ, SpurgeGymB2FSidescrollSignpost1

.ObjectEvents: db 2
	person_event SPRITE_POKE_BALL, 12, 20, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGymB2FSidescrollNPC1, EVENT_SPURGE_GYM_POKEMON_2
	person_event SPRITE_POKE_BALL, 14, 23, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeGymB2FSidescrollNPC2, EVENT_SPURGE_GYM_POKEMON_5
