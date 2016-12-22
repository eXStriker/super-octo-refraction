RijonLeagueOutside_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, RijonLeague_SetFlyFlag

RijonLeague_SetFlyFlag:
	setflag ENGINE_FLYPOINT_RIJON_LEAGUE
	return

RijonLeagueOutsideHiddenItem_1:
	dw EVENT_RIJON_LEAGUE_OUTSIDE_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

RijonLeagueOutsideSignpost1:
	ctxt "Rijon League"
	done

RijonLeagueOutside_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $5, $9, 1, RIJON_LEAGUE_INSIDE
	warp_def $5, $a, 2, RIJON_LEAGUE_INSIDE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 7, 12, SIGNPOST_LOAD, RijonLeagueOutsideSignpost1
	signpost 6, 6, SIGNPOST_ITEM, RijonLeagueOutsideHiddenItem_1

	;people-events
	db 0
