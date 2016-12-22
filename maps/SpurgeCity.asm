SpurgeCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, SpurgeCity_SetFlyFlag

SpurgeCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_SPURGE_CITY
	return

SpurgeCitySignpost1:
	ctxt "The city where"
	next "anything can"
	next "happen!"
	done ;14

SpurgeCitySignpost2:
	ctxt "Orphanage"
	done ;16

SpurgeCitySignpost3:
	opentext
	qrcode 6
	waitbutton
	checkitem QR_READER
	iffalse SpurgeCity_127220
	farwritetext UsingQRScannerText
	playwaitsfx SFX_CALL
	jumptext SpurgeCitySignpost3_Text_127243

SpurgeCitySignpost4:
	ctxt "Spurge Casino"
	next "Earn big bucks"
	next "inside!"
	done ;15

SpurgeCitySignpost5:
	jumpstd pokecentersign

SpurgeCitySignpost6:
	jumpstd martsign

SpurgeCityNPC1:
	jumptextfaceplayer SpurgeCityNPC1_Text_124235

SpurgeCityNPC2:
	jumptextfaceplayer SpurgeCityNPC2_Text_1261e0

SpurgeCityNPC3:
	jumptextfaceplayer SpurgeCityNPC3_Text_12434e

SpurgeCityNPC4:
	jumptextfaceplayer SpurgeCityNPC4_Text_1266f7

SpurgeCityNPC5:
	jumptextfaceplayer SpurgeCityNPC5_Text_12668e

SpurgeCityNPC6:
	jumptextfaceplayer SpurgeCityNPC6_Text_126618

SpurgeCityNPC7:
	faceplayer
	opentext
	checkevent EVENT_GET_TM39
	iftrue SpurgeCity_127631
	writetext SpurgeCityNPC7_Text_127637
	waitbutton
	givetm 39 + RECEIVED_TM
	setevent EVENT_GET_TM39
	closetext
	end

SpurgeCity_127631:
	writetext SpurgeCity_127631_Text_127696
	waitbutton
SpurgeCity_127220:
	closetext
	end

SpurgeCitySignpost3_Text_127243:
	ctxt "Crystal Egg -"
	line "Silk Tunnel's"
	cont "First Floor."
	done

SpurgeCityNPC1_Text_124235:
	ctxt "I recently adopted"
	line "a #mon from"
	cont "the orphanage."

	para "It seems to have"
	line "bruises covering"
	cont "all of its body."
	done

SpurgeCityNPC2_Text_1261e0:
	ctxt "I was told to"
	line "block the Gym"
	cont "until the leader"
	cont "returns."

	para "My legs are about"
	line "to get stiff."
	done

SpurgeCityNPC3_Text_12434e:
	ctxt "I heard a big"
	line "explosion earlier,"
	cont "what was that?"
	done

SpurgeCityNPC4_Text_1266f7:
	ctxt "zzz<...>"

	para "Oh, uh, what?"

	para "I must have"
	line "fallen asleep!"

	para "I lost the keys"
	line "to my apartment"
	cont "and I have been"
	cont "looking for them."

	para "It's been at least"
	line "half a day now."
	done

SpurgeCityNPC5_Text_12668e:
	ctxt "Did you know!"

	para "Only a decade"
	line "ago, this city"
	cont "didn't exist."

	para "Look at it now!"

	para "Imagine it 20"
	line "years from now!"
	done

SpurgeCityNPC6_Text_126618:
	ctxt "I'm just tending"
	line "to the garden."

	para "They just keep on"
	line "building further"
	cont "to the north,"

	para "so I keep on"
	line "having to move it."
	done

SpurgeCityNPC7_Text_127637:
	ctxt "What am I doing"
	line "over here?"

	para "Well, if you take"
	line "this TM, could"

	para "you please mind"
	line "your own business?"
	done

SpurgeCity_127631_Text_127696:
	ctxt "TM39 is Swift!"

	para "This attack will"
	line "never miss unless"
	cont "the opponent uses"
	cont "the moves Fly,"
	cont "Dig, or Protect!"
	done

SpurgeCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 11
	warp_def $17, $21, 1, SPURGE_POKECENTER
	warp_def $11, $14, 1, APARTMENTS_F1
	warp_def $11, $1c, 1, SPURGE_GAME_CORNER
	warp_def $1a, $25, 1, CAPER_CITY
	warp_def $17, $5, 1, SPURGE_HOUSE
	warp_def $5, $22, 1, SPURGE_GYM_1F
	warp_def $18, $c, 1, ORPHANAGE
	warp_def $19, $14, 1, SPURGE_MART
	warp_def $1b, $25, 2, CAPER_CITY
	warp_def $1d, $5, 68, MOUND_B3F
	warp_def $1d, $6, 68, MOUND_B3F

	;xy triggers
	db 0

	;signposts
	db 6
	signpost 25, 31, SIGNPOST_LOAD, SpurgeCitySignpost1
	signpost 25, 11, SIGNPOST_LOAD, SpurgeCitySignpost2
	signpost 12, 32, SIGNPOST_READ, SpurgeCitySignpost3
	signpost 19, 29, SIGNPOST_LOAD, SpurgeCitySignpost4
	signpost 23, 34, SIGNPOST_READ, SpurgeCitySignpost5
	signpost 25, 24, SIGNPOST_READ, SpurgeCitySignpost6

	;people-events
	db 7
	person_event SPRITE_LASS, 28, 23, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, SpurgeCityNPC1, -1
	person_event SPRITE_SCHOOLBOY, 6, 34, SPRITEMOVEDATA_00, 0, 0, -1, -1, 0, 0, 0, SpurgeCityNPC2, EVENT_DEFEATED_CEO
	person_event SPRITE_POKEFAN_M, 26, 14, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeCityNPC3, -1
	person_event SPRITE_SCHOOLBOY, 18, 23, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, 0, 0, SpurgeCityNPC4, -1
	person_event SPRITE_SAILOR, 14, 8, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeCityNPC5, -1
	person_event SPRITE_BEAUTY, 7, 12, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 3, -1, -1, PAL_OW_RED, 0, 0, SpurgeCityNPC6, -1
	person_event SPRITE_PSYCHIC, 13, 28, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SpurgeCityNPC7, -1
