RijonLeagueInside_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw 5, RijonLeagueCheckVacation
	
RijonLeagueCheckVacation:
	setevent EVENT_LEAGUE_BLOCKER
	checkevent EVENT_RIJON_LEAGUE_WON
	sif true, then
		checkcode VAR_BADGES
		if_less_than 20, .showGuard
	sendif
	return
	
.showGuard
	clearevent EVENT_LEAGUE_BLOCKER
	return

RijonLeagueInsideNPC1:
	jumptextfaceplayer RijonLeagueInsideNPC1_Text_2f445d

RijonLeagueInsideNPC2:
	jumptextfaceplayer RijonLeagueInsideNPC2_Text_2f43cd

RijonLeagueInsideNPC3:
	faceplayer
	opentext
	pokemart 0, 14
	closetext
	end

RijonLeagueInsideNPC4:
	jumpstd pokecenternurse
	
RijonLeagueInsideNPC5:
	jumptextfaceplayer RijonLeagueHiatusText
	
RijonLeagueHiatusText:
	ctxt "The Rijon League"
	line "is temporarly"
	cont "closed."

	para "The league members"
	line "are taking a well"
	
	para "deserved vacation"
	line "after a crushing"
	cont "defeat."
	
	para "Come back later."
	done
	
RijonLeagueInsideNPC1_Text_2f445d:
	ctxt "Stock on supplies"
	line "before heading"
	cont "in."

	para "You'll need them!"
	done

RijonLeagueInsideNPC2_Text_2f43cd:
	ctxt "Yo, Champ in the"
	line "making!"

	para "The Champion here"
	line "is no pushover!"

	para "The Trainer known"
	line "as Brown was once"
	cont "the Champion."

	para "But!"

	para "Another legendary"
	line "Trainer bested"
	cont "him!"
	done

RijonLeagueInside_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $6, 1, RIJON_LEAGUE_OUTSIDE
	warp_def $7, $7, 2, RIJON_LEAGUE_OUTSIDE
	warp_def $0, $7, 1, RIJON_LEAGUE_YUKI

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 5
	person_event SPRITE_ROCKER, 6, 11, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, RijonLeagueInsideNPC1, -1
	person_event SPRITE_COOLTRAINER_M, 4, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, RijonLeagueInsideNPC2, -1
	person_event SPRITE_CLERK, 1, 12, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, RijonLeagueInsideNPC3, -1
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, RijonLeagueInsideNPC4, -1
	person_event SPRITE_COOLTRAINER_M, 1, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, RijonLeagueInsideNPC5, EVENT_LEAGUE_BLOCKER
