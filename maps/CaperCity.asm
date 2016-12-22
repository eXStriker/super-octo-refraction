CaperCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, Caper_SetFlyFlag

Caper_SetFlyFlag:
	setflag ENGINE_FLYPOINT_CAPER_CITY
	return

CaperCitySignpost1:
	ctxt "The town that's"
	next "always under a"
	next "white blanket"
	done

CaperCitySignpost2:
	ctxt "Prof Ilk's Lab"
	done

CaperCityNPC1:
	jumptextfaceplayer CaperCityNPC1_Text_122f98

CaperCityNPC2:
	jumptextfaceplayer CaperCityNPC2_Text_122728

CaperCityNPC3:
	checkevent EVENT_CAPER_SHOVELING_SNOW
	sif true
		end
	checkcode VAR_XCOORD
	sif =, 12, then
		spriteface 0, RIGHT
		spriteface 4, LEFT
	selse
		faceplayer
	sendif
	opentext 	
	writetext CaperCityNPC3_Text_120a0b
	waitbutton
	closetext
	checkcode VAR_XCOORD
	sif =, 12, then
		applymovement 0, CaperWalkDown
	sendif
	end

CaperCityNPC4:
	jumptextfaceplayer CaperCityNPC4_Text_120a91

CaperCityMartSignpost:
	jumpstd martsign

CaperCityPokecenterSignpost:
	jumpstd pokecentersign
	
CaperWalkDown:
	step_down
	step_end

CaperCityNPC1_Text_122f98:
	ctxt "Prof. Ilk lives"
	line "in this town!"

	para "That man is a"
	line "#mon genius!"

	para "Not only is he a"
	line "revered #mon"
	cont "professor<...>"

	para "<...>he's also a"
	line "famed historian."
	done

CaperCityNPC2_Text_122728:
	ctxt "I don't recognize"
	line "you at all<...>"

	para "So, where did"
	line "you come from?"

	para "<...>"

	para "Mmhmm<...>"

	para "Huh. I've never"
	line "heard of it."
	done

CaperCityNPC3_Text_120a0b:
	ctxt "I'm shoveling"
	line "snow right now."
	
	para "When I'm done, it"
	line "should be safe to"
	cont "go past."
	done

CaperCityNPC4_Text_120a91:
	ctxt "Watch out!"

	para "This is really"
	line "thin ice!"

	para "I'm trying not to"
	line "move to stop it"
	cont "from cracking!"
	done

CaperCity_MapEventHeader:: db 0, 0

.Warps: db 5
	warp_def 9, 33, 1, CAPER_MART
	warp_def 7, 5, 1, ACQUA_EXITCHAMBER
	warp_def 9, 7, 1, CAPER_HOUSE
	warp_def 9, 17, 1, CAPER_POKECENTER
	warp_def 5, 26, 1, ILKS_LAB

.CoordEvents: db 1
	xy_trigger 0, 8, 12, $0, CaperCityNPC3, $0, $0

.BGEvents: db 4
	signpost 5, 10, SIGNPOST_LOAD, CaperCitySignpost1
	signpost 7, 22, SIGNPOST_LOAD, CaperCitySignpost2
	signpost 9, 18, SIGNPOST_READ, CaperCityPokecenterSignpost
	signpost 9, 34, SIGNPOST_READ, CaperCityMartSignpost

.ObjectEvents: db 4
	person_event SPRITE_YOUNGSTER, 3, 11, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_OW_RED, 0, 0, CaperCityNPC1, -1
	person_event SPRITE_BUG_CATCHER, 12, 9, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, PAL_OW_YELLOW, 0, 0, CaperCityNPC2, -1
	person_event SPRITE_TEACHER, 8, 13, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 8, 0, 0, CaperCityNPC3, EVENT_CAPER_SHOVELING_SNOW
	person_event SPRITE_YOUNGSTER, 15, 31, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, CaperCityNPC4, EVENT_MET_ILK

