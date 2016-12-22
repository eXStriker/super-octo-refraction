AzaleaCharcoal_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

AzaleaCharcoalNPC1:
	jumptextfaceplayer AzaleaCharcoalNPC1_Text_3248d7

AzaleaCharcoalNPC2:
	jumptextfaceplayer AzaleaCharcoalNPC2_Text_324859

AzaleaCharcoalNPC1_Text_3248d7:
	ctxt "Our family"
	line "produces charcoal"
	cont "for the mart."

	para "Our Farfetch'd"
	line "cuts down trees"

	para "in Ilex Forest to"
	line "help."

	para "It's just tough on"
	line "us every time it"
	cont "starts to run off."
	done

AzaleaCharcoalNPC2_Text_324859:

	ctxt "That landslide"
	line "east of here has"

	para "blocked off"
	line "travelers."

	para "No matter for"
	line "someone like"

	para "myself though,"
	line "I'll just climb it!"
	done

AzaleaCharcoal_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 7, AZALEA_TOWN
	warp_def $7, $3, 7, AZALEA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_YOUNGSTER, 2, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AzaleaCharcoalNPC1, -1
	person_event SPRITE_BLACK_BELT, 3, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, AzaleaCharcoalNPC2, -1
