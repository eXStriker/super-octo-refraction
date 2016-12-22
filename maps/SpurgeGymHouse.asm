SpurgeGymHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SpurgeGymHouseNPC3:
	faceplayer
	opentext
	writetext SpurgeGymHouseNPC3_Text_AbraExclamation
	cry ABRA
	endtext

SpurgeGymHouseNPC2:
	faceplayer
	opentext
	writetext AbraManText
	yesorno
	sif false
		jumptext AbraManRefusedText
	checkmoney 0, 400
	sif !=, 2, then
		writetext AbraManPaidMoneyText
	selse
		writetext AbraManNotEnoughMoneyText
	sendif
	takemoney 0, 400
	waitbutton
	closetext
	playsound SFX_WARP_FROM
	special FadeOutPalettes
	waitsfx
	warp SPURGE_GYM_1F, 4, 4 ; add actual coords
	end

AbraManText:
	ctxt "Fufufu... Are you"
	line "stuck, child?"

	para "My Abra can let"
	line "you out, for a"
	cont "small fee<...>"

	para "How's about<...>"
	line "¥400?"
	done

AbraManRefusedText:
	ctxt "Fufufu... fine by"
	line "me."
	done

AbraManPaidMoneyText:
	ctxt "Fufufu... very"
	line "well."
	done

AbraManNotEnoughMoneyText:
	ctxt "Eh?! You don't"
	line "have enough"
	cont "money?"

	para "Give me whatever"
	line "you have then."
	done

SpurgeGymHouseNPC3_Text_AbraExclamation:
	ctxt "Abra: Aabraa<...>"
	done

SpurgeGymHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $0, $7, 1, SPURGE_GYM_B1F

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_GRAMPS, 4, 1, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, SpurgeGymHouseNPC2, -1
	person_event SPRITE_ABRA, 4, 2, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SpurgeGymHouseNPC3, -1
