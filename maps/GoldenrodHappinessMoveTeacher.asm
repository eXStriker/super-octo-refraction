GoldenrodHappinessMoveTeacher_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodHappinessMoveTeacherNPC1:
	jumptextfaceplayer GoldenrodHappinessMoveTeacherNPC1_Text_3278a8

GoldenrodHappinessMoveTeacherNPC2:
	jumptextfaceplayer GoldenrodHappinessMoveTeacherNPC2_Text_3278de

GoldenrodHappinessMoveTeacherNPC3:
	faceplayer
	opentext
	special Special_GoldenrodHappinessMoveTutor
	endtext

GoldenrodHappinessMoveTeacherNPC1_Text_3278a8:
	ctxt "Using vitamins on"
	line "#mon will make"
	cont "them happy!"
	done

GoldenrodHappinessMoveTeacherNPC2_Text_3278de:
	ctxt "Your #mon won't"
	line "be happy if it"

	para "faints during"
	line "battle."
	done

GoldenrodHappinessMoveTeacher_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 8, GOLDENROD_CITY
	warp_def $7, $3, 8, GOLDENROD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_LASS, 3, 7, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_GREEN, 0, 0, GoldenrodHappinessMoveTeacherNPC1, -1
	person_event SPRITE_POKEFAN_M, 4, 5, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodHappinessMoveTeacherNPC2, -1
	person_event SPRITE_TEACHER, 3, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, GoldenrodHappinessMoveTeacherNPC3, -1
