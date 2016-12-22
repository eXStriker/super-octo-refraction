MagikarpCavernsEnd_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagikarpCavernsEndNPC1:
	faceplayer
	opentext
	writetext MagikarpCavernsEndNPC1_Text_110b2e
	waitbutton
	setevent EVENT_MAGIKARP_TEST
	restorecustchar
	clearflag ENGINE_POKEMON_MODE
	clearflag ENGINE_CUSTOM_PLAYER_SPRITE
	warp LAUREL_CITY, 34, 12
	closetext
	end

MagikarpCavernsEndNPC1_Text_110b2e:
	ctxt "There's something"
	line "different about"
	cont "you now<...>"

	para "You appear to"
	line "have gained great"
	para "respect for the"
	line "many hardships of"
	para "#mon, much"
	line "like the natives"
	cont "of Naljo do."

	para "People who moved"
	line "here from many"
	para "lands solely use"
	line "their #mon"
	cont "as mere tools!"

	para "You may want to"
	line "speak to the"
	para "last remaining"
	line "descendant of"
	para "'The Messenger',"
	line "on Route 80."

	para "For you both share"
	line "the same vision of"
	cont "life with #mon."

	para "Well done!"

	para "I give you my"
	line "permission to go"
	para "south of the"
	line "Laurel Forest."
	done

MagikarpCavernsEnd_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $9, $2, 1, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_ELDER, 7, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, MagikarpCavernsEndNPC1, -1
