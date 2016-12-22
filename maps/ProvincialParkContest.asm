ProvincialParkContest_MapScriptHeader
	;trigger count
	db 0
	;callback count
	db 0

ProvincialParkContest_Spot1:
	writebyte 1
	farjump ParkSpotScript

ProvincialParkContest_Spot2:
	writebyte 2
	farjump ParkSpotScript

ProvincialParkContest_Spot3:
	writebyte 3
	farjump ParkSpotScript

ProvincialParkContest_Spot4:
	writebyte 4
	farjump ParkSpotScript

ProvincialParkContest_Spot5:
	writebyte 5
	farjump ParkSpotScript

ProvincialParkContest_Spot6:
	writebyte 6
	farjump ParkSpotScript

ProvincialParkContest_Spot7:
	writebyte 7
	farjump ParkSpotScript

ProvincialParkContest_Spot8:
	writebyte 8
	farjump ParkSpotScript

ProvincialParkContest_Spot9:
	writebyte 9
	farjump ParkSpotScript

ProvincialParkContest_Spot10:
	writebyte 10
	farjump ParkSpotScript

ProvincialParkContest_Spot11:
	writebyte 11
	farjump ParkSpotScript

ProvincialParkContest_Spot12:
	writebyte 12
	farjump ParkSpotScript

ProvincialParkContest_Spot13:
	writebyte 13
	farjump ParkSpotScript

ProvincialParkContest_MagmaCavernsEntranceNPC:
	faceplayer
	opentext
	writetext .magma_caverns_not_allowed_text
	waitbutton
	closetext
	spriteface 2, DOWN
	end
.magma_caverns_not_allowed_text
	ctxt "Firelight Caverns"
	line "are off-limits"
	para "during the"
	line "challenge."

	para "Insisting won't"
	line "make me move."
	done

ProvincialParkContest_GateNPC:
	faceplayer
	scall ProvincialParkContest_QuitParkMinigame
	sif true
		end
	spriteface 3, LEFT
	end

ProvincialParkContest_GateNPCTrigger:
	spriteface 3, DOWN
	scall ProvincialParkContest_QuitParkMinigame
	sif true
		end
	spriteface 3, LEFT
	applymovement PLAYER, .go_back
	end
.go_back
	step_left
	step_end

ProvincialParkContest_QuitParkMinigame:
	opentext
	writetext .are_you_leaving_text
	yesorno
	closetext
	sif false
		end
	farscall StopParkMinigameScript
	writebyte 1
	end
.are_you_leaving_text
	ctxt "Are you leaving?"
	line "The challenge is"
	cont "over if you leave."
	done

ProvincialParkContest_MapEventHeader
	db 0, 0

	; warps
	db 0

	; xy triggers
	db 1
	xy_trigger 0, 9, 33, 0, ProvincialParkContest_GateNPCTrigger, 0, 0

	; signposts
	db 13
	signpost 11, 13, SIGNPOST_UP, ProvincialParkContest_Spot1
	signpost  7, 23, SIGNPOST_UP, ProvincialParkContest_Spot2
	signpost 17, 25, SIGNPOST_UP, ProvincialParkContest_Spot3
	signpost 25,  7, SIGNPOST_UP, ProvincialParkContest_Spot4
	signpost 23, 19, SIGNPOST_UP, ProvincialParkContest_Spot5
	signpost 33, 15, SIGNPOST_UP, ProvincialParkContest_Spot6
	signpost 41,  5, SIGNPOST_UP, ProvincialParkContest_Spot7
	signpost 37,  9, SIGNPOST_UP, ProvincialParkContest_Spot8
	signpost 43, 17, SIGNPOST_UP, ProvincialParkContest_Spot9
	signpost 37, 33, SIGNPOST_UP, ProvincialParkContest_Spot10
	signpost 25, 27, SIGNPOST_UP, ProvincialParkContest_Spot11
	signpost 47, 31, SIGNPOST_UP, ProvincialParkContest_Spot12
	signpost 11,  5, SIGNPOST_UP, ProvincialParkContest_Spot13

	; people events
	db 2
	person_event SPRITE_OFFICER, 48, 22, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ProvincialParkContest_MagmaCavernsEntranceNPC, -1
	person_event SPRITE_OFFICER,  8, 33, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ProvincialParkContest_GateNPC, -1
