JaeruMart_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

JaeruMartNPC1:
	faceplayer
	opentext
	pokemart 0, 22
	closetext
	end

JaeruMartNPC2:
	jumptextfaceplayer JaeruMartNPC2_Text_32cc27

JaeruMartNPC3:
	jumptextfaceplayer JaeruMartNPC3_Text_32cc76

JaeruMartNPC2_Text_32cc27:
	ctxt "Don't drink too"
	line "much of that beer."

	para "Strange, but"
	line "#mon enjoy it"
	cont "too!"

	para "Ha!"
	done

JaeruMartNPC3_Text_32cc76:
	ctxt "Thunderstones are"
	line "so pretty!"

	para "I like to collect"
	line "them!"
	done

JaeruMart_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $6, 5, JAERU_CITY
	warp_def $7, $7, 5, JAERU_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_CLERK, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, JaeruMartNPC1, -1
	person_event SPRITE_HIKER, 6, 11, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, JaeruMartNPC2, -1
	person_event SPRITE_R_JRTRAINERF, 3, 1, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BROWN, 0, 0, JaeruMartNPC3, -1
