GoldenrodMagnetTrain_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

GoldenrodMagnetTrainNPC1:
	checkitem MAGNET_PASS
	iffalse .noMagnetPass
	opentext
	writetext GoldenrodMagnetTrainNPC1_Text_1610ba
	loadmenudata GoldenrodMagnetTrainMenu
	verticalmenu
	closewindow
	if_equal 1, GoldenrodMagnetTrain_161430
	if_equal 2, GoldenrodMagnetTrain_161460
	if_equal 3, GoldenrodMagnetTrain_1614c0
	closetext
	end

.noMagnetPass
	jumptext GoldenrodMagnetTrainNoPassText

GoldenrodMagnetTrainMenu:
	db $40 ; flags
	db 01, 10 ; start coords
	db 11, 19 ; end coords
	dw GoldenrodMagnetTrainOptions
	db 1 ; default option

GoldenrodMagnetTrainOptions:
	db $80
	db $4
	db "Naljo@"
	db "Rijon@"
	db "Kanto@"
	db "Cancel@"

GoldenrodMagnetTrainNPC2:
	jumptextfaceplayer GoldenrodMagnetTrainNPC2_Text_163557

GoldenrodMagnetTrain_161430:
	writetext GoldenrodMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, GoldenrodMagnetTrain_161430_Movement1
	applymovement 0, GoldenrodMagnetTrain_161430_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 1
	special Special_MagnetTrain
	wait 14
	warp TORENIA_MAGNET_TRAIN, 11, 6
	applymovement 2, GoldenrodMagnetTrain_161430_Movement3
	applymovement 0, GoldenrodMagnetTrain_161430_Movement4
	applymovement 2, GoldenrodMagnetTrain_161430_Movement5
	jumptext GoldenrodMagnetTrain_161430_Text_1615c0

GoldenrodMagnetTrain_161430_Movement1:
	step_up
	step_up
	step_left
	step_end

GoldenrodMagnetTrain_161430_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

GoldenrodMagnetTrain_161430_Movement3:
	step_down
	step_left
	step_end

GoldenrodMagnetTrain_161430_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

GoldenrodMagnetTrain_161430_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

GoldenrodMagnetTrain_161460:
	writetext GoldenrodMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, GoldenrodMagnetTrain_161460_Movement1
	applymovement 0, GoldenrodMagnetTrain_161460_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 1
	special Special_MagnetTrain
	wait 14
	warp BOTAN_MAGNET_TRAIN, 11, 6
	applymovement 2, GoldenrodMagnetTrain_161460_Movement3
	applymovement 0, GoldenrodMagnetTrain_161460_Movement4
	applymovement 2, GoldenrodMagnetTrain_161460_Movement5
	jumptext GoldenrodMagnetTrain_161460_Text_161410

GoldenrodMagnetTrain_161460_Movement1:
	step_up
	step_up
	step_left
	step_end

GoldenrodMagnetTrain_161460_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

GoldenrodMagnetTrain_161460_Movement3:
	step_down
	step_left
	step_end

GoldenrodMagnetTrain_161460_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

GoldenrodMagnetTrain_161460_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

GoldenrodMagnetTrain_1614c0:
	checkitem MAGNET_PASS
	if_equal 0, GoldenrodMagnetTrain_1613e0
	writetext GoldenrodMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, GoldenrodMagnetTrain_1614c0_Movement1
	applymovement 0, GoldenrodMagnetTrain_1614c0_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 0
	special Special_MagnetTrain
	wait 14
	warp SAFFRON_MAGNET_TRAIN, 11, 6
	applymovement 2, GoldenrodMagnetTrain_1614c0_Movement3
	applymovement 0, GoldenrodMagnetTrain_1614c0_Movement4
	applymovement 2, GoldenrodMagnetTrain_1614c0_Movement5
	jumptext GoldenrodMagnetTrain_1614c0_Text_161620

GoldenrodMagnetTrain_1614c0_Movement1:
	step_up
	step_up
	step_left
	step_end

GoldenrodMagnetTrain_1614c0_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

GoldenrodMagnetTrain_1614c0_Movement3:
	step_down
	step_left
	step_end

GoldenrodMagnetTrain_1614c0_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

GoldenrodMagnetTrain_1614c0_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

GoldenrodMagnetTrain_1613e0:
	writetext GoldenrodMagnetTrain_1613e0_Text_161650
	endtext

GoldenrodMagnetTrainNoPassText:
	ctxt "Hello."

	para "Unfortunately, you"
	line "can't use this"

	para "station without a"
	line "Magnet Pass."

	para "Come back when you"
	line "get one."
	done

GoldenrodMagnetTrainNPC1_Text_1610ba:
	ctxt "Hello."

	para "Where do you want"
	line "to go?"
	done

GoldenrodMagnetTrainNPC2_Text_163557:
	ctxt "I'm the"
	line "President."

	para "This train is"
	line "faster than any"
	cont "#mon, and"
	cont "will take you to"
	cont "Rijon or Naljo"
	cont "in a flash!"

	para "If you have a"
	line "special pass, it"
	cont "can also be"
	cont "taken to Kanto."

	para "We have plans to"
	line "expand to other"
	cont "regions in the"
	cont "future."
	done

GoldenrodMagnetTrain_161430_Text_1611bf:
	ctxt "OK, please enter"
	line "the magnet train."
	done

GoldenrodMagnetTrain_161430_Text_1615c0:
	text_jump MagnetTrainReachedTorenia

GoldenrodMagnetTrain_161460_Text_161410:
	text_jump MagnetTrainReachedBotan

GoldenrodMagnetTrain_1614c0_Text_161620:
	text_jump MagnetTrainReachedSaffron

GoldenrodMagnetTrain_1613e0_Text_161650:
	ctxt "You need a Magnet"
	line "Pass to go there."
	done

GoldenrodMagnetTrain_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $11, $8, 5, GOLDENROD_CITY
	warp_def $11, $9, 5, GOLDENROD_CITY
	warp_def $5, $6, 4, CAPER_CITY
	warp_def $5, $b, 5, GOLDENROD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 9, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodMagnetTrainNPC1, -1
	person_event SPRITE_GENTLEMAN, 14, 6, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, GoldenrodMagnetTrainNPC2, -1
