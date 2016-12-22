AzaleaMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AzaleaMartNPC1:
	faceplayer
	opentext
	pokemart 0, 32
	closetext
	end

AzaleaMartNPC2:
	jumptextfaceplayer AzaleaMartNPC2_Text_325b86

AzaleaMartNPC3:
	jumptextfaceplayer AzaleaMartNPC3_Text_325bf6

AzaleaMartNPC2_Text_325b86:
	ctxt "Kurt had plans to"
	line "supply the mart"

	para "with his custom"
	line "balls."

	para "It seems like a"
	line "loss due to his"
	cont "retirement<...>"
	done

AzaleaMartNPC3_Text_325bf6:
	ctxt "The prototype"
	line "versions of"

	para "Kurt's balls had"
	line "some problems."

	para "Love Balls used"
	line "to catch #mon"
	para "of the same"
	line "gender, and Fast"
	para "Balls only"
	line "worked on three"
	para "different"
	line "species."

	para "Thank goodness"
	line "those problems"
	cont "were fixed!"
	done

AzaleaMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 6, AZALEA_TOWN
	warp_def $7, $7, 6, AZALEA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AzaleaMartNPC1, -1
	person_event SPRITE_YOUNGSTER, 6, 12, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, AzaleaMartNPC2, -1
	person_event SPRITE_ROCKER, 2, 1, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, AzaleaMartNPC3, -1
