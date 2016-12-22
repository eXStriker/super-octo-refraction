MoragaHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MoragaHouseNPC1:
	jumptextfaceplayer MoragaHouseNPC1_Text_323f46

MoragaHouseNPC2:
	jumptextfaceplayer MoragaHouseNPC2_Text_323d7a

MoragaHouseNPC1_Text_323f46:
	ctxt "Papa always likes"
	line "to wax nostalgic."
	done

MoragaHouseNPC2_Text_323d7a:
	ctxt "This town's crime"
	line "rate has grown"
	cont "ever since they"
	cont "added that Botan"
	cont "train station."
	done

MoragaHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 10, MORAGA_TOWN
	warp_def $7, $3, 10, MORAGA_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_YOUNGSTER, 4, 5, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaHouseNPC1, -1
	person_event SPRITE_POKEFAN_M, 3, 2, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MoragaHouseNPC2, -1
