Route47_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1
	dbw MAPCALLBACK_NEWMAP, Route47BikeCheck

Route47BikeCheck:
	checkcode VAR_XCOORD
	if_equal 25, Route47PutOnBike
	clearflag ENGINE_ALWAYS_ON_BIKE
	return

Route47PutOnBike:
	setflag ENGINE_ALWAYS_ON_BIKE
	return

Route47HiddenItem_1:
	dw EVENT_ROUTE_47_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route47Signpost2:
	ctxt "<RIGHT><UP> Route 34"
	next "<RIGHT><DOWN> Ilex Forest"
	next "<DOWN> Route 48-B"
	done

Route47_Trainer_1:
	trainer EVENT_ROUTE_47_TRAINER_1, BIKER, 8, Route47_Trainer_1_Text_2f13c0, Route47_Trainer_1_Text_2f13dd, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route47_Trainer_1_Script_Text_2f13f0

Route47_Trainer_2:
	trainer EVENT_ROUTE_47_TRAINER_2, BIKER, 7, Route47_Trainer_2_Text_2f1375, Route47_Trainer_2_Text_2f138e, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route47_Trainer_2_Script_Text_2f1399

Route47_Trainer_1_Text_2f13c0:
	ctxt "You cannot enter"
	line "this gate."
	done

Route47_Trainer_1_Text_2f13dd:
	ctxt "Well now you can."
	done

Route47_Trainer_1_Script_Text_2f13f0:
	ctxt "Don't push it."
	done

Route47_Trainer_2_Text_2f1375:
	ctxt "I'm about to"
	line "coast down."
	done

Route47_Trainer_2_Text_2f138e:
	ctxt "Screw it."
	done

Route47_Trainer_2_Script_Text_2f1399:
	ctxt "Just gonna chill."
	done

Route47_MapEventHeader ;filler
	db 0, 0

;warps
	db 8
	warp_def $2, $f, 10, CAPER_CITY
	warp_def $9, $25, 8, SILK_TUNNEL_1F
	warp_def $2, $12, 10, CAPER_CITY
	warp_def $2, $12, 4, CAPER_CITY
	warp_def $4, $19, 5, CAPER_CITY
	warp_def $5, $19, 2, ROUTE_34_GATE
	warp_def $1, $13, 2, CAPER_CITY
	warp_def $3, $15, 10, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 9, 11, SIGNPOST_ITEM, Route47HiddenItem_1
	signpost 15, 5, SIGNPOST_LOAD, Route47Signpost2

	;people-events
	db 2
	person_event SPRITE_BIKER, 6, 22, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 3, Route47_Trainer_1, -1
	person_event SPRITE_BIKER, 11, 5, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 2, Route47_Trainer_2, -1
