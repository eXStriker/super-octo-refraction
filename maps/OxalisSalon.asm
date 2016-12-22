OxalisSalon_MapScriptHeader: ;trigger count
	db 0
 ;callback count
	db 0

OxalisSalonStylistScript:
	opentext
	special PlaceMoneyTopRight
	writetext SalonStylistText
	yesorno
	iffalse .no
	checkmoney 0, 1000
	if_equal 2, .notEnoughMoney
	waitsfx
	playsound SFX_TRANSACTION
	takemoney 0, 1000
	special PlaceMoneyTopRight
	writetext SalonStylistYesText
	closetext
	refreshscreen
	callasm OxalisSalonCustomization
	anonjumptable
	dw .giveBackMoney
	dw .done
	dw .didNotChange
.giveBackMoney
	givemoney 0, 1000
.no
	jumptext SalonStylistNoText
.done
	jumptext SalonStylistDoneText
.didNotChange
	givemoney 0, 1000
	jumptext SalonStylistDidNotChangeText
.notEnoughMoney
	jumptext SalonStylistNoMoney

OxalisSalonNPC2:
	jumptextfaceplayer OxalisSalonNPC2Text

OxalisSalonNPC3:
	jumptextfaceplayer OxalisSalonNPC3Text

OxalisSalonNPC4:
	jumptextfaceplayer OxalisSalonNPC4Text

OxalisSalonNPC2Text:
	ctxt "That lady is a"
	line "true genius!"

	para "You should see my"
	line "before picture!"
	done

OxalisSalonNPC3Text:
	ctxt "Try not to look"
	line "too different!"

	para "One time I got a"
	line "makeover, and my"

	para "#mon didn't even"
	line "recognize me!"
	done

OxalisSalonNPC4Text:
	ctxt "Hair like this"
	line "takes some proper"
	cont "time and care."

	para "Thus, I come here"
	line "all the time!"
	done

SalonStylistDoneText:
	ctxt "There we go!"

	para "You look a lot"
	line "better now!"

	para "Come again!"
	done

SalonStylistYesText:
	ctxt "Wonderful!"

	para "Let's get started!"
	sdone

SalonStylistNoMoney
	ctxt "You can't pay with"
	line "piggy bank scraps."

	para "Come back when you"
	line "have enough."
	done

SalonStylistNoText
	ctxt "That's a big"
	line "disapointment."

	para "Please reconsider"
	line "in the future."
	done

SalonStylistDidNotChangeText:
	ctxt "What? You didn't"
	line "change your look"
	cont "at all!"

	para "In that case, I'll"
	line "give you a refund."

	para "Come back when you"
	line "want a different"
	cont "look."
	done

SalonStylistText:
	ctxt "Hi there sweetie!"

	para "Unhappy with the"
	line "way you look?"

	para "Your worries will"
	line "be over once I"

	para "give you a stylish"
	line "makeover!"

	para "It's only ¥1000!"
	done

OxalisSalon_MapEventHeader: ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $6, 1, OXALIS_CITY
	warp_def $9, $7, 1, OXALIS_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_TEACHER, 1, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, OxalisSalonStylistScript, -1
	person_event SPRITE_BUENA, 5, 3, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, OxalisSalonNPC2, -1
	person_event SPRITE_POKEFAN_F, 7, 9, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, OxalisSalonNPC3, -1
	person_event SPRITE_ROCKER, 6, 5, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_YELLOW, PERSONTYPE_SCRIPT, 0, OxalisSalonNPC4, -1
