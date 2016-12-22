BattleCenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

BattleCenterSignpost1:
	special Special_TimeCapsule
	newloadmap 248
	end

BattleCenterSignpost2:
	special Special_TimeCapsule
	newloadmap 248
	end

BattleCenterNPC1:
	jumptext BattleCenterNPC1_Text_17153d

BattleCenterNPC2:
	jumptext BattleCenterNPC1_Text_17153d

BattleCenterNPC1_Text_17153d:
	ctxt "Your friend is"
	line "ready."
	done

BattleCenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $4, 3, POKECENTER_BACKROOM
	warp_def $7, $5, 3, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 4, 4, SIGNPOST_RIGHT, BattleCenterSignpost1
	signpost 4, 5, SIGNPOST_LEFT, BattleCenterSignpost2

	;people-events
	db 2
	person_event SPRITE_P0, 4, 3, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, BattleCenterNPC1, EVENT_BATTLE_CENTER_NPC_1
	person_event SPRITE_P0, 4, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, BattleCenterNPC2, EVENT_BATTLE_CENTER_NPC_2
