MysteryZoneLeagueAirport_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MysteryZoneAirportNPC:
	faceplayer
	opentext
	writetext AskToReturnToSoutherly
	yesorno
	iffalse .no
	writetext AskToReturnToSoutherlyYes
	waitbutton
	special FadeOutPalettes
	playwaitsfx SFX_RAZOR_WIND
	wait 10
	warp SOUTHERLY_AIRPORT, 6, 6
	end
.no
	closetext
	end

AskToReturnToSoutherlyYes:
	ctxt "Great!"

	para "We'll depart"
	line "shortly."
	done

AskToReturnToSoutherly:
	ctxt "Hello."

	para "Would you like to"
	line "fly to Southerly"
	cont "City?"
	done

MysteryZoneLeagueAirport_MapEventHeader:: db 0, 0

.Warps: db 1
	warp_def 0, 11, 1, MYSTERY_ZONE

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 3
	person_event SPRITE_OFFICER, 9, 1, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, MysteryZoneAirportNPC, -1
	person_event SPRITE_OFFICER, 9, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, MysteryZoneAirportNPC, -1
	person_event SPRITE_OFFICER, 9, 15, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, MysteryZoneAirportNPC, -1
