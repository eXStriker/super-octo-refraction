SaxifrageMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaxifrageMartNPC1:
	faceplayer
	opentext
	pokemart 0, 10
	closetext
	end

SaxifrageMartNPC2:
	jumptextfaceplayer SaxifrageMartNPC2_Text_14f950

SaxifrageMartNPC3:
	jumptextfaceplayer SaxifrageMartNPC3_Text_14f90b

SaxifrageMartNPC2_Text_14f950:
	ctxt "My boyfriend was"
	line "thrown in jail"
	cont "because he stole"
	cont "a Potion when his"
	cont "#mon was hurt."

	para "<...>"

	para "Why he didn't just"
	line "get a job?"

	para "Well, the economy<...>"
	done

SaxifrageMartNPC3_Text_14f90b:
	ctxt "A mart! And in a"
	line "prison town!"

	para "Do the prisoners"
	line "get to shop here?"
	done

SaxifrageMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 4, SAXIFRAGE_ISLAND
	warp_def $7, $7, 4, SAXIFRAGE_ISLAND

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaxifrageMartNPC1, -1
	person_event SPRITE_COOLTRAINER_F, 3, 2, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, SaxifrageMartNPC2, -1
	person_event SPRITE_GENTLEMAN, 6, 10, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SaxifrageMartNPC3, -1
