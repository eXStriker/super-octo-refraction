CastroSuperRod_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

CastroSuperRodNPC:
	faceplayer
	opentext
	checkevent EVENT_GOT_SUPERROD
	sif true
		jumptext CastroSuperRodNPC_Text_AfterRod
	writetext CastroSuperRodNPC_Text_Initial
	waitbutton
	giveitem SUPER_ROD, 1
	sif false
		jumptext CastroSuperRodNPC_Text_NoSpace
	writetext CastroSuperRod_Text_PlayerReceivedRod
	playwaitsfx SFX_ITEM
	itemnotify
	setevent EVENT_GOT_SUPERROD
	endtext

CastroSuperRodNPC_Text_AfterRod:
	ctxt "If you see any of"
	line "my family, say hi!"
	done

CastroSuperRodNPC_Text_Initial:
	ctxt "You love fishing?"

	para "Well then, take"
	line "this gift!"
	done

CastroSuperRod_Text_PlayerReceivedRod:
	ctxt "<PLAYER> received"
	line "Super Rod!"
	done

CastroSuperRodNPC_Text_NoSpace:
	ctxt "Free some space!"
	done

CastroSuperRod_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 8, CASTRO_VALLEY
	warp_def $7, $3, 8, CASTRO_VALLEY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_FISHING_GURU, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, CastroSuperRodNPC, -1
