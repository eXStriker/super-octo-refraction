HeathGymGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HeathGymGateNPC1:
	faceplayer
	opentext
	writetext HeathGymGateNPC1_Text_11075b
	endtext

HeathGymGateNPC1_Text_11075b:
	ctxt "Ages ago, the"
	line "region was watched"
	para "over by the so"
	line "called Guardians."

	para "Only descendants"
	line "of The Messenger"
	para "would be able to"
	line "tame them."

	para "The only known"
	line "descendant is"
	cont "a strong Trainer."

	para "He along with his"
	line "family moved away"
	cont "a long time ago."
	done

HeathGymGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $9, $d, 1, HEATH_GYM
	warp_def $9, $e, 1, HEATH_GYM
	warp_def $6, $13, 2, HEATH_VILLAGE
	warp_def $7, $13, 1, HEATH_VILLAGE

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_LOIS, 5, 13, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, HeathGymGateNPC1, -1
