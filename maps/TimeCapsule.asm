TimeCapsule_MapScriptHeader:
.MapTriggers:
	db 2

	; triggers
	maptrigger .Trigger0
	maptrigger .Trigger1

.MapCallbacks:
	db 1

	; callbacks

	dbw MAPCALLBACK_OBJECTS, TimeCapsule_SetWhichChris

.Trigger0:
	priorityjump TimeCapsule_Initialize
	end

.Trigger1:
	end

TimeCapsule_SetWhichChris:
	special Special_CableClubCheckWhichChris
	iffalse .Chris2
	disappear 3
	appear 2
	return

.Chris2:
	disappear 2
	appear 3
	return

TimeCapsule_Initialize:
	dotrigger $1
	domaptrigger POKECENTER_BACKROOM, $3
	end

MapTimeCapsuleSignpost1Script:
	special Special_TimeCapsule
	newloadmap MAPSETUP_LINKRETURN
	end

ChrisScript_0x19351a:
	jumptext UnknownText_0x193521

UnknownText_0x193521:
	ctxt "Your friend is"
	line "ready."
	done

TimeCapsule_MapEventHeader:
	; filler
	db 0, 0

.Warps:
	db 2
	warp_def $7, $4, 4, POKECENTER_BACKROOM
	warp_def $7, $5, 4, POKECENTER_BACKROOM

.XYTriggers:
	db 0

.Signposts:
	db 2
	signpost 4, 4, SIGNPOST_RIGHT, MapTimeCapsuleSignpost1Script
	signpost 4, 5, SIGNPOST_LEFT, MapTimeCapsuleSignpost1Script

.PersonEvents:
	db 2
	person_event SPRITE_P0, 4, 3, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, ChrisScript_0x19351a, EVENT_LINKED_PLAYER_RIGHT
	person_event SPRITE_P0, 4, 6, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, ChrisScript_0x19351a, EVENT_LINKED_PLAYER_LEFT
