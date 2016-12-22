Route69IlkBrotherHouse_MapScriptHeader;trigger count
	db 2

	maptrigger .Trigger0
	maptrigger .Trigger1
 ;callback count
	db 0

.Trigger0
	priorityjump IlkBrothersInTrouble
	end

.Trigger1
	end

IlkBrothersInTrouble:
	playmusic MUSIC_RIVAL_ENCOUNTER
	applymovement 0, WalkToIlkBro
	showemote 0, 2, 15
	opentext
	writetext IlkBroNoticesYouText
	waitbutton
	closetext
	dotrigger 1
	setevent EVENT_ROUTE_69_ILK_BRO_TRAPPED
	end

IlkBrothersTalkToRival:
	opentext
	writetext IlkBroRivalTalkToPoke
	waitbutton
	closetext
	showemote 0, 3, 15
	faceplayer
	opentext
	writetext TextIlkBroRivalStartBattle
	waitbutton
	winlosstext IlkBroRivalWin, IlkBroRivalLose
	setlasttalked 255
	loadtrainer RIVAL1, RIVAL1_1
	writecode VAR_BATTLETYPE, BATTLETYPE_CANLOSE
	setlasttalked $3
	dontrestartmapmusic
	startbattle
	reloadmapafterbattle
	playmusic MUSIC_RIVAL_AFTER
	setevent EVENT_RIVAL_ROUTE_69
	disappear 4
	opentext
	writetext TextIlkBroRivalAfterBattle
	waitbutton
	closetext
	playmusic MUSIC_NONE
	playsound SFX_WARP_FROM
	applymovement 3, IlkBroRivalTeleport
	disappear 3
	waitsfx
	playmusic MUSIC_ROUTE_D

	spriteface 2, UP

	checkcode VAR_FACING
	sif =, RIGHT, then
		applymovement 0, WalkToIlkBroBackFacedRight
	selse
		applymovement 0, WalkToIlkBroBack
	sendif

	spriteface 2, RIGHT
	opentext
	writetext IlkBroTextAfter
	waitbutton
	special SpecialNameRival
	clearevent EVENT_ROUTE_69_ILK_BRO_TRAPPED
	jumptext IlkBroTextAfterNameRival

IlkBroRivalTeleport:
	teleport_from
	remove_person
	step_end

WalkToIlkBroBack:
	step_left
	step_left
	step_left
	step_down
	step_down
	step_down
	step_left
	step_end

WalkToIlkBroBackFacedRight:
	step_left
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	turn_head_left
	step_end

WalkToIlkBro:
	step_up
	step_up
	step_up
	turn_head_left
	step_end

IlkBroWalkToRival:
	step_up
	step_up
	step_right
	step_right
	step_right
	step_right
	step_up
	step_end

Route69IlkBrotherHouseSignpost1:
	jumptext Route69IlkBrotherHouseSignpost1_Text_188d32

Route69IlkBrotherHouseSignpost2:
	jumptext Route69IlkBrotherHouseSignpost1_Text_188d32

Route69IlkBrotherHouseSignpost3:
	jumptext Route69IlkBrotherHouseSignpost3_Text_188d73

Route69IlkBrotherHouseSignpost4:
	jumptext Route69IlkBrotherHouseSignpost3_Text_188d73

Route69IlkBrotherHouseSignpost5:
	jumptext Route69IlkBrotherHouseSignpost5_Text_188d9b

Route69IlkBrotherHouseNPC1:
	checkevent EVENT_RIVAL_ROUTE_69
	sif true
		jumptextfaceplayer Route69IlkBrotherHouseNPC1_Text_After
	jumptextfaceplayer Route69IlkBrotherHouseNPC1_Text_Before

IlkBroTextAfter:
	ctxt "I saw the whole"
	line "thing! Wow!"

	para "You sure put up a"
	line "good fight!"

	para "Did he tell you"
	line "his name?"
	done

IlkBroTextAfterNameRival:
	ctxt "<RIVAL>, huh?"

	para "That Larvitar you"
	line "battled with<...>"

	para "I think it belongs"
	line "to my brother."
	
	para "Oh you met him"
	line "already?"

	para "He asked you to"
	line "check up on me?"

	para "That was nice of"
	line "him."
	
	para "Don't forget to"
	line "return his"
	cont "Larvitar."
	
	para "He really loves"
	line "that #mon."
	done


IlkBroRivalWin:
	ctxt "It seems like"
	line "this #mon could"
	cont "use some training<...>"

	para "I will make it"
	line "stronger, by any"
	cont "means necessary."
	done

IlkBroRivalLose:
	ctxt "Hah!"

	para "That was extremely"
	line "pathetic!"
	done

TextIlkBroRivalAfterBattle:
	ctxt "You're so naff."

	para "Time to exit."

	para "I got just what I"
	line "needed from this"
	cont "old fart."

	para "Ciao!"

	para "<RIVAL> used an"
	line "Escape Rope."
	done

TextIlkBroRivalStartBattle:
	ctxt "What do you want,"
	line "you little brat?"

	para "You're not going"
	line "to get in my way!"
	done

IlkBroRivalTalkToPoke:
	ctxt "Haha!"

	para "You're mine now<...>"

	para "<...>unless you want"
	line "to get hurt<...>"
	done

IlkBroNoticesYouText:
	ctxt "Finally!"

	para "The cops are here!"

	para "Wait<...>"

	para "You're just a kid."

	para "<...>"

	para "The cops sent you"
	line "here? What were"
	cont "they thinking?"

	para "<...>"

	para "Oh? Prof. Ilk"
	line "sent you to help?"

	para "Well then<...>"

	para "See that guy in"
	line "the back, there?"

	para "He broke in and"
	line "is trying to take"
	cont "my poor Bagon."

	para "Please, help!"
	done

Route69IlkBrotherHouseSignpost1_Text_188d32:
	ctxt "Hmm, this stove"
	line "needs cleaning."
	done

Route69IlkBrotherHouseSignpost3_Text_188d73:
	ctxt "Blah!"

	para "What a dirty sink!"
	done

Route69IlkBrotherHouseSignpost5_Text_188d9b:
	ctxt "It's an N64!"
	done

Route69IlkBrotherHouseNPC1_Text_Before:
	ctxt "Please, hurry!"
	done

Route69IlkBrotherHouseNPC1_Text_After:
	ctxt "Thanks again for"
	line "trying to stop"
	cont "that crazy kid."

	para "I hope my Bagon is"
	line "safe and sound<...>"
	done

Route69IlkBrotherHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $4, 3, ROUTE_69
	warp_def $9, $5, 3, ROUTE_69

	;xy triggers
	db 0

	;signposts
	db 5
	signpost 1, 0, SIGNPOST_READ, Route69IlkBrotherHouseSignpost1
	signpost 0, 0, SIGNPOST_READ, Route69IlkBrotherHouseSignpost2
	signpost 0, 1, SIGNPOST_READ, Route69IlkBrotherHouseSignpost3
	signpost 1, 1, SIGNPOST_READ, Route69IlkBrotherHouseSignpost4
	signpost 2, 9, SIGNPOST_READ, Route69IlkBrotherHouseSignpost5

	;people-events
	db 3
	person_event SPRITE_SCIENTIST, 6, 3, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, Route69IlkBrotherHouseNPC1, -1
	person_event SPRITE_SILVER, 2, 8, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, IlkBrothersTalkToRival, EVENT_RIVAL_ROUTE_69
	person_event SPRITE_BAGON, 1, 8, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, EVENT_RIVAL_ROUTE_69
