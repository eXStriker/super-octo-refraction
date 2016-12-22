HappinessRater_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HappinessRaterHiddenItem_1:
	dw EVENT_HAPPINESS_RATER_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

HappinessRaterNPC1:
	faceplayer
	opentext
	special GetFirstPokemonHappiness
	writetext HappinessRaterNPC1_Text_15f400
	buttonsound
	if_greater_than 249, HappinessRater_15fa52
	if_greater_than 199, HappinessRater_15c983
	if_greater_than 149, HappinessRater_15c989
	if_greater_than 99, HappinessRater_15c98f
	if_greater_than 49, HappinessRater_15c995
	jump HappinessRater_15fa6b

HappinessRater_15fa52:
	writetext HappinessRater_15fa52_Text_15ca06
	waitbutton
	checkevent EVENT_GOT_TM27
	if_equal 0, HappinessRater_15fa5f
	closetext
	end

HappinessRater_15c983:
	writetext HappinessRater_15c983_Text_15ca36
	endtext

HappinessRater_15c989:
	writetext HappinessRater_15c989_Text_15ca64
	endtext

HappinessRater_15c98f:
	writetext HappinessRater_15c98f_Text_15ca98
	endtext

HappinessRater_15c995:
	writetext HappinessRater_15c995_Text_15caa9
	endtext

HappinessRater_15fa6b:
	checkevent EVENT_GOT_TM21
	if_equal 0, HappinessRater_15fa74
	closetext
	end

HappinessRater_15fa5f:
	writetext HappinessRater_15fa5f_Text_15f9d2
	waitbutton
	givetm 27 + RECEIVED_TM
	setevent EVENT_GOT_TM27
	closetext
	end

HappinessRater_15fa74:
	writetext HappinessRater_15fa74_Text_15f9ff
	waitbutton
	givetm 21 + RECEIVED_TM
	setevent EVENT_GOT_TM21
	closetext
	closetext
	end

HappinessRaterNPC1_Text_15f400:
	ctxt "Hello, I am the"
	line "happiness rater."

	para "I can score your"
	line "#mon's happiness"
	cont "in an instant!"

	para "Can I see your"
	line "<STRBF3> for"
	cont "just a moment."
	cont "Please?"

	para "Hmm<...>"

	para "Your <STRBF3>"
	line "scored @"
	deciram hScriptVar, 1, 0
	ctxt "/255."
	done

HappinessRater_15fa52_Text_15ca06:
	ctxt "Grade: A Plus!"

	para "This #mon"
	line "definitely loves"
	cont "you!"
	done

HappinessRater_15c983_Text_15ca36:
	ctxt "Grade: A"

	para "Your #mon"
	line "likes you a lot!"
	done

HappinessRater_15c989_Text_15ca64:
	ctxt "Grade: B"

	para "This #mon"
	line "looks happy."
	done

HappinessRater_15c98f_Text_15ca98:
	ctxt "Grade: C"
	done

HappinessRater_15c995_Text_15caa9:
	ctxt "Grade: D"

	para "Seems your #mon"
	line "isn't used to you"
	cont "yet."
	done

HappinessRater_15fa5f_Text_15f9d2:
	ctxt "Go ahead and take"
	line "this TM, you"
	cont "deserve it!"
	done

HappinessRater_15fa74_Text_15f9ff:
	ctxt "If you take this"
	line "TM, will you get"
	cont "out of here?"
	done

HappinessRater_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $5, $2, 3, OXALIS_CITY
	warp_def $5, $3, 3, OXALIS_CITY

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 4, 0, SIGNPOST_ITEM, HappinessRaterHiddenItem_1

	;people-events
	db 1
	person_event SPRITE_TEACHER, 1, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, HappinessRaterNPC1, -1
