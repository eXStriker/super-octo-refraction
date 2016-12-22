MoragaDiner_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MoragaDinerNPC1:
	faceplayer
	opentext
	pokemart 0, 4
	closetext
	end

MoragaDinerNPC2:
	jumptextfaceplayer MoragaDinerNPC2_Text_39404c

MoragaDinerNPC3:
	jumptextfaceplayer MoragaDinerNPC3_Text_39409f

MoragaDinerNPC4:
	jumptextfaceplayer MoragaDinerNPC4_Text_394076

MoragaDinerNPC2_Text_39404c:
	ctxt "Don't disturb me"
	line "while I'm eating!"
	done

MoragaDinerNPC3_Text_39409f:
	ctxt "I've had better"
	line "burgers up in"
	cont "Kanto."
	done

MoragaDinerNPC4_Text_394076:
	ctxt "My #mon love"
	line "these burgers"
	cont "too!"
	done

MoragaDiner_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $4, 7, MORAGA_TOWN
	warp_def $7, $5, 7, MORAGA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_CLERK, 4, 7, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaDinerNPC1, -1
	person_event SPRITE_FISHER, 6, 2, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, 0, 0, MoragaDinerNPC2, -1
	person_event SPRITE_YOUNGSTER, 6, 8, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, MoragaDinerNPC3, -1
	person_event SPRITE_RECEPTIONIST, 2, 2, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaDinerNPC4, -1
