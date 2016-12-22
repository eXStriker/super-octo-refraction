Route77_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route77HiddenItem_1:
	dw EVENT_ROUTE_77_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route77Signpost1:
	opentext
	qrcode 4
	waitbutton
	checkitem QR_READER
	iffalse Route77_12f218
	farwritetext UsingQRScannerText
	playwaitsfx SFX_CALL
	jumptext Route77Signpost1_Text_12f23b

Route77_Trainer_1:
	trainer EVENT_ROUTE_77_TRAINER_1, FISHER, 2, Route77_Trainer_1_Text_12c636, Route77_Trainer_1_Text_12c659, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route77_Trainer_1_Script_Text_12c663

Route77_Trainer_2:

	trainer EVENT_ROUTE_77_TRAINER_2, FISHER, 3, Route77_Trainer_2_Text_12c6a4, Route77_Trainer_2_Text_12c6d3, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route77_Trainer_2_Script_Text_12c6f1

Route77_Trainer_3:
	trainer EVENT_ROUTE_77_TRAINER_3, FISHER, 4, Route77_Trainer_3_Text_12c863, Route77_Trainer_3_Text_12c87d, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route77_Trainer_3_Script_Text_12c886

Route77_Trainer_4:

	trainer EVENT_ROUTE_77_TRAINER_4, YOUNGSTER, 4, Route77_Trainer_4_Text_12c97c, Route77_Trainer_4_Text_12c9bf, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route77_Trainer_4_Script_Text_12c9dd

Route77_Trainer_5:

	trainer EVENT_ROUTE_77_TRAINER_5, CAMPER, 4, Route77_Trainer_5_Text_12ca02, Route77_Trainer_5_Text_12ca20, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route77_Trainer_5_Script_Text_12ca3e

Route77_Trainer_6:

	trainer EVENT_ROUTE_77_TRAINER_6, PICNICKER, 4, Route77_Trainer_6_Text_12ca73, Route77_Trainer_6_Text_12cad2, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route77_Trainer_6_Script_Text_12caed

Route77NPC1:
	jumpstd strengthboulder

Route77NPC2:
	faceplayer
	checkevent EVENT_GOT_HM02

	iftrue Route77_12f97e
	opentext
	writetext Route77NPC2_Text_12f985
	waitbutton
	givetm 98 + RECEIVED_TM
	setevent EVENT_GOT_HM02
	jumptext Route77NPC2_Text_12f9e0

Route77NPC3:
	faceplayer
	checkflag ENGINE_ELECTRONBADGE
	iffalse Route77_12fa59
	checkevent EVENT_GOT_HM02
	iftrue Route77_12fa52
	opentext
	writetext Route77NPC3_Text_12fa60
	waitbutton
	givetm 98 + RECEIVED_TM
	setevent EVENT_GOT_HM02
	jumptext Route77NPC3_Text_12fb22

Route77NPC5:
	fruittree 17

Route77_Item_1:
	db TWISTEDSPOON, 1

Route77_Item_2:
	db HYPER_POTION, 1

Route77_12f218:
	closetext
	end

Route77_12f97e:
	jumptext Route77NPC2_Text_12f9e0

Route77_12fa59:
	jumptext Route77_12fa59_Text_12fbb6

Route77_12fa52:
	jumptext Route77NPC3_Text_12fb22

Route77PokecenterSign:
	jumpstd pokecentersign

Route77Signpost1_Text_12f23b:
	ctxt "Gold Egg - House"
	line "west of Hayward"
	cont "Mart"
	done

Route77_Trainer_1_Text_12c636:
	ctxt "I've been reelin'"
	line "them in today!"
	done

Route77_Trainer_1_Text_12c659:
	ctxt "Sploosh!"
	done

Route77_Trainer_1_Script_Text_12c663:
	ctxt "Time to add to"
	line "my collection."
	done

Route77_Trainer_2_Text_12c6a4:
	ctxt "My catch is HUGE!"

	para "Just LOOK at it!"
	done

Route77_Trainer_2_Text_12c6d3:
	ctxt "Uh<...> What?"
	done

Route77_Trainer_2_Script_Text_12c6f1:
	ctxt "Not big enough?"
	done

Route77_Trainer_3_Text_12c863:
	ctxt "Caught two"
	line "big #mon!"
	done

Route77_Trainer_3_Text_12c87d:
	ctxt "OW!"
	done

Route77_Trainer_3_Script_Text_12c886:
	ctxt "Forget training,"
	line "I'll just catch"
	cont "strong ones!"
	done

Route77_Trainer_4_Text_12c97c:
	ctxt "I just had to"
	line "catch these<...>"
	done

Route77_Trainer_4_Text_12c9bf:
	ctxt "Ugh, no fair."
	done

Route77_Trainer_4_Script_Text_12c9dd:
	ctxt "I released them"
	line "back in the wild."
	done

Route77_Trainer_5_Text_12ca02:
	ctxt "Camping outside,"
	line "gotta love it."
	done

Route77_Trainer_5_Text_12ca20:
	ctxt "Well, who will"
	line "warm me up now?"
	done

Route77_Trainer_5_Script_Text_12ca3e:
	ctxt "Hmm<...> I'll get"
	line "cold with my warm"
	cont "#mon fainted."

	para "<...>"

	para "You're saying I"
	line "should head for"
	cont "a #mon Center?"

	para "No need, I'll heal"
	line "them naturally."
	done

Route77_Trainer_6_Text_12ca73:
	ctxt "I just caught"
	line "three #mon!"

	para "Now, time to"
	line "make them fight!"
	done

Route77_Trainer_6_Text_12cad2:
	ctxt "Well, that was a"
	line "bit fun, at least."
	done

Route77_Trainer_6_Script_Text_12caed:
	ctxt "Guess I should"
	line "have trained them"
	cont "a bit more first<...>"
	done

Route77NPC2_Text_12f985:
	ctxt "Looks like you've"
	line "got clearance to"
	cont "pass."

	para "Next time, use"
	line "this HM to get"
	cont "to Caper City"
	cont "faster!"
	done

Route77NPC2_Text_12f9e0:
	ctxt "Oh, hello again!"

	para "I heard everything"
	line "from Prof. Ilk."

	para "Good luck to you!"
	done

Route77NPC3_Text_12fa60:
	ctxt "I can't let you"
	line "past without a"
	cont "valid clearance."

	para "We suffered a bad"
	line "earthquake here."

	para "If only we could"
	line "get some expert"
	cont "to assist us<...>"

	para "Like that guy<...>"
	line "What's he called,"
	cont "'Prof. Silk'?"

	para "<...>"

	para "What? Oh, he's"
	line "called Prof. Ilk?"

	para "You know that"
	line "crazy professor?"

	para "Maybe he can help"
	line "in this situation."

	para "He knows more"
	line "about this strange"
	cont "region than I do."

	para "<...>"

	para "Very well, you"
	line "got yourself a"
	cont "deal here."

	para "This HM will help"
	line "you get back to"
	cont "Caper City faster."
	done

Route77NPC3_Text_12fb22:
	ctxt "HM02 is Fly."

	para "Your #mon will"
	line "be able to fly"
	cont "you to important"
	cont "places you've"
	cont "already visited!"

	para "Make sure to talk"
	line "to Prof. Ilk and"
	cont "I'll get you a"
	cont "clearance to pass."
	done

Route77_12fa59_Text_12fbb6:
	ctxt "I was instructed"
	line "to just guard this"
	cont "bridge for now."

	para "Maybe if you had"
	line "more badges I"
	cont "would feel more"
	cont "comfortable to"
	cont "let you through."
	done

Route77_MapEventHeader:: db 0, 0

.Warps: db 6
	warp_def 73, 10, 1, MILOS_F1
	warp_def 21, 13, 1, ROUTE_77_JEWELERS
	warp_def 51, 7, 3, ROUTE_77_DAYCARE_HOUSE
	warp_def 69, 5, 1, ROUTE_77_POKECENTER
	warp_def 73, 9, 1, MILOS_F1
	warp_def 5, 11, 3, TORENIA_GATE

.CoordEvents: db 0

.BGEvents: db 3
	signpost 9, 13, SIGNPOST_READ, Route77Signpost1
	signpost 25, 4, SIGNPOST_ITEM, Route77HiddenItem_1
	signpost 69, 6, SIGNPOST_READ, Route77PokecenterSign

.ObjectEvents: db 13
	person_event SPRITE_FISHER, 30, 10, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 2, 1, Route77_Trainer_1, -1
	person_event SPRITE_FISHER, 37, 8, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route77_Trainer_2, -1
	person_event SPRITE_FISHER, 44, 13, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route77_Trainer_3, -1
	person_event SPRITE_YOUNGSTER, 63, 1, SPRITEMOVEDATA_SPINCLOCKWISE, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route77_Trainer_4, -1
	person_event SPRITE_YOUNGSTER, 23, 11, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, Route77_Trainer_5, -1
	person_event SPRITE_PICNICKER, 57, 13, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 5, Route77_Trainer_6, -1
	person_event SPRITE_BOULDER, 69, 9, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route77NPC1, -1
	person_event SPRITE_OFFICER, 50, 17, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 3, Route77NPC2, -1
	person_event SPRITE_OFFICER, 40, 11, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route77NPC3, EVENT_ILK_EARTHQUAKE
	person_event SPRITE_POKE_BALL, 73, 1, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 3, TM_CURSE, 0, EVENT_ROUTE_77_TM03
	person_event SPRITE_FRUIT_TREE, 15, 12, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, Route77NPC5, -1
	person_event SPRITE_POKE_BALL, 13, 1, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, Route77_Item_1, EVENT_ROUTE_77_ITEM_1
	person_event SPRITE_POKE_BALL, 7, 5, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, Route77_Item_2, EVENT_ROUTE_77_ITEM_2

