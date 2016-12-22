SaxifragePokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaxifragePokecenterNPC1:
	jumpstd pokecenternurse

SaxifragePokecenterNPC2:
	jumptextfaceplayer SaxifragePokecenterNPC2_Text_14f3b5

SaxifragePokecenterNPC3:
	jumptextfaceplayer SaxifragePokecenterNPC3_Text_14f9e9

SaxifragePokecenterNPC4:
	jumptextfaceplayer SaxifragePokecenterNPC4_Text_14e926

SaxifragePokecenterNPC2_Text_14f3b5:
	ctxt "They don't allow"
	line "the locked up"
	cont "#mon to use"
	cont "the #mon"
	cont "Center<...>"

	para "I believe some"
	line "#mon don't know"
	cont "any better."

	para "Most of them were"
	line "poorly raised"
	cont "and abused by"
	cont "their Trainers."
	done

SaxifragePokecenterNPC3_Text_14f9e9:
	ctxt "This island is"
	line "very unkempt."

	para "Wild #mon still"
	line "roam freely and"
	cont "bother anyone"
	cont "choosing to visit."
	done

SaxifragePokecenterNPC4_Text_14e926:
	ctxt "I think the"
	line "conditions for"
	cont "the prisoners"
	cont "are very cruel."

	para "Both humans and"
	line "#mon can go"
	cont "days without"
	cont "being given a"
	cont "meal."

	para "Sometimes the"
	line "#mon have to"
	cont "resort to eating"
	cont "each other in"
	cont "order to survive."
	done

SaxifragePokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 3, SAXIFRAGE_ISLAND
	warp_def $7, $5, 3, SAXIFRAGE_ISLAND
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaxifragePokecenterNPC1, -1
	person_event SPRITE_BLACK_BELT, 7, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SaxifragePokecenterNPC2, -1
	person_event SPRITE_TEACHER, 6, 1, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SaxifragePokecenterNPC3, -1
	person_event SPRITE_YOUNGSTER, 4, 5, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SaxifragePokecenterNPC4, -1
