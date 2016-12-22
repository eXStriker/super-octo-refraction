Route80_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route80Signpost1:
	jumptext Route80Signpost1_Text_132605

Route80Signpost2:
	opentext
	qrcode 5
	waitbutton
	checkitem QR_READER
	iffalse Route80_133949
	farwritetext UsingQRScannerText
	playwaitsfx SFX_CALL
	jumptext Route80Signpost2_Text_13396c

Route80_Trainer_1:
	trainer EVENT_ROUTE_80_TRAINER_1, SWIMMERM, 2, Route80_Trainer_1_Text_1336cc, Route80_Trainer_1_Text_1336df, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route80_Trainer_1_Script_Text_1336fe

Route80_Trainer_2:
	trainer EVENT_ROUTE_80_TRAINER_2, SWIMMERM, 1, Route80_Trainer_2_Text_133612, Route80_Trainer_2_Text_133640, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route80_Trainer_2_Script_Text_133658

Route80_Trainer_3:
	trainer EVENT_ROUTE_80_TRAINER_3, SWIMMERF, 2, Route80_Trainer_3_Text_132311, Route80_Trainer_3_Text_132351, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route80_Trainer_3_Script_Text_132371

Route80_Item_1:
	db DRAGON_SCALE, 1

Route80_Trainer_4:
	trainer EVENT_ROUTE_80_TRAINER_4, FISHER, 5, Route80_Trainer_4_Text_132401, Route80_Trainer_4_Text_13242e, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route80_Trainer_4_Script_Text_132469

Route80_Trainer_5:
	trainer EVENT_ROUTE_80_TRAINER_5, SWIMMERF, 1, Route80_Trainer_5_Text_133556, Route80_Trainer_5_Text_13358e, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route80_Trainer_5_Script_Text_1335ae

Route80_Trainer_6:
	trainer EVENT_ROUTE_80_TRAINER_6, FISHER, 6, Route80_Trainer_6_Text_133752, Route80_Trainer_6_Text_13376c, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route80_Trainer_6_Script_Text_133775

Route80NPC2:
	jumpstd strengthboulder

Route80_133949:
	closetext
	end

Route80Signpost1_Text_132605:
	ctxt "The Naljo Prophet"
	done

Route80Signpost2_Text_13396c:
	ctxt "Silver Egg -"
	line "Route 56 on a"
	cont "sea rock"
	done

Route80_Trainer_1_Text_1336cc:
	ctxt "I'm all pumped up!"
	done

Route80_Trainer_1_Text_1336df:
	ctxt "Wait, I'm already"
	line "out of #mon?"
	done

Route80_Trainer_1_Script_Text_1336fe:
	ctxt "I can swim pretty"
	line "far away from the"
	cont "coast, once I even"
	cont "went half a mile!"
	done

Route80_Trainer_2_Text_133612:
	ctxt "My 100th lap for"
	line "the day!"

	para "Time for a break"
	line "with a battle!"
	done

Route80_Trainer_2_Text_133640:
	ctxt "Well, back to"
	line "swimming!"
	done

Route80_Trainer_2_Script_Text_133658:
	ctxt "All these laps"
	line "continue to tone"
	cont "my muscles."

	para "I'll be able to"
	line "get any girl I"
	cont "want with this"
	cont "body, baby!"
	done

Route80_Trainer_3_Text_132311:
	ctxt "I'm trying to"
	line "escape from that"
	cont "dreadful prison."

	para "You're not gonna"
	line "stop me, never."
	done

Route80_Trainer_3_Text_132351:
	ctxt "Don't swim when"
	line "there's a storm!"
	done

Route80_Trainer_3_Script_Text_132371:
	ctxt "The harsh storms"
	line "that have occurred"
	cont "here killed other"
	cont "fugitives."

	para "We need to be"
	line "careful when"
	cont "we travel on"
	cont "this route."
	done

Route80_Trainer_4_Text_132401:
	ctxt "I caught these"
	line "#mon with a"
	cont "pretty good rod!"
	done

Route80_Trainer_4_Text_13242e:
	ctxt "Well, if the rod's"
	line "name is 'good'<...>"

	para "Does that make it"
	line "false labeling?"
	done

Route80_Trainer_4_Script_Text_132469:
	ctxt "That fisherman"
	line "was a distant"
	cont "relative to the"
	cont "fishing guru."
	done

Route80_Trainer_5_Text_133556:
	ctxt "This route has"
	line "some very strange"
	cont "weather patterns."
	done

Route80_Trainer_5_Text_13358e:
	ctxt "Don't swim when"
	line "there's a storm!"
	done

Route80_Trainer_5_Script_Text_1335ae:
	ctxt "This part of"
	line "Naljo often has"
	cont "thunder storms."

	para "I'm not sure how"
	line "that makes sense."
	done

Route80_Trainer_6_Text_133752:
	ctxt "Hey, you. This is"
	line "my fishing spot."
	done

Route80_Trainer_6_Text_13376c:
	ctxt "Well<...>"
	done

Route80_Trainer_6_Script_Text_133775:
	ctxt "Nobody's allowed"
	line "in this spot but"
	cont "me, understood?"
	done

Route80_MapEventHeader:: db 0, 0

.Warps: db 5
	warp_def 6, 6, 3, ROUTE_81_EASTGATE
	warp_def 7, 6, 4, ROUTE_81_EASTGATE
	warp_def 5, 9, 1, ROUTE_80_NOBU
	warp_def 43, 48, 1, CAPER_CITY
	warp_def 37, 6, 2, SAXIFRAGE_EXITS

.CoordEvents: db 0

.BGEvents: db 2
	signpost 6, 14, SIGNPOST_READ, Route80Signpost1
	signpost 8, 8, SIGNPOST_READ, Route80Signpost2

.ObjectEvents: db 9
	person_event SPRITE_POKE_BALL, 22, 36, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 3, TM_THUNDER, 0, EVENT_ROUTE_80_NPC_1
	person_event SPRITE_SWIMMER_GUY, 22, 21, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 5, Route80_Trainer_1, -1
	person_event SPRITE_SWIMMER_GUY, 41, 28, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 2, 4, Route80_Trainer_2, -1
	person_event SPRITE_SWIMMER_GIRL, 45, 11, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 2, Route80_Trainer_3, -1
	person_event SPRITE_POKE_BALL, 19, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, Route80_Item_1, EVENT_ROUTE_80_ITEM_1
	person_event SPRITE_FISHER, 18, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 1, Route80_Trainer_4, -1
	person_event SPRITE_SWIMMER_GIRL, 9, 23, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 2, 5, Route80_Trainer_5, -1
	person_event SPRITE_FISHER, 14, 22, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 2, 1, Route80_Trainer_6, -1
	person_event SPRITE_BOULDER, 41, 7, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route80NPC2, -1

