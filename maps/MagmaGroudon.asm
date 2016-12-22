MagmaGroudon_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MagmaGroudonNPC1:
	checkitem RED_ORB
	iftrue MagmaGroudon_398139
	jumptext MagmaGroudonNPC1_Text_39815a

MagmaGroudon_Item_1:
	db MAGMARIZER, 1

MagmaGroudon_398139:
	opentext
	writetext MagmaGroudon_398139_Text_3981d6
	waitbutton
	cry GROUDON
	takeitem RED_ORB, 1
	writetext MagmaGroudon_398139_Text_398200
	waitbutton
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon GROUDON, 50
	startbattle
	reloadmapafterbattle
	setevent EVENT_FOUGHT_GROUDON
	disappear 2
	closetext
	end

MagmaGroudonNPC1_Text_39815a:
	ctxt "It appears to be"
	line "a statue of a"
	cont "fierce #mon."

	para "It's strangely"
	line "holding out it's"
	cont "arms<...>"

	para "Maybe it's"
	line "expecting a gift"
	cont "from someone?"
	done

MagmaGroudon_398139_Text_3981d6:
	ctxt "Placed the Red"
	line "Orb in the"
	cont "statue's hands."
	done

MagmaGroudon_398139_Text_398200:
	ctxt "It started"
	line "moving!"

	para "This isn't a"
	line "statue, it's a"
	para "living #mon"
	line "and it looks like"
	para "it's going to"
	line "attack!"
	done

MagmaGroudon_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $11, $9, 6, MAGMA_ROOMS

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_GROUDON, 6, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MagmaGroudonNPC1, EVENT_FOUGHT_GROUDON
	person_event SPRITE_POKE_BALL, 17, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, MagmaGroudon_Item_1, EVENT_MAGMA_GROUDON_ITEM_1
