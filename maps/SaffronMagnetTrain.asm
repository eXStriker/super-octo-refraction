SaffronMagnetTrain_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaffronMagnetTrainNPC1:
	opentext
	writetext SaffronMagnetTrainNPC1_Text_1610ba
	loadmenudata SaffronMagnetTrainMenu
	verticalmenu
	closewindow
	if_equal 1, SaffronMagnetTrain_161430
	if_equal 2, SaffronMagnetTrain_161460
	if_equal 3, SaffronMagnetTrain_161490
	closetext
	end

SaffronMagnetTrainMenu:
	db $40 ; flags
	db 01, 10 ; start coords
	db 11, 19 ; end coords
	dw SaffronMagnetTrainOptions
	db 1 ; default option

SaffronMagnetTrainOptions:
	db $80
	db $4
	db "Naljo@"
	db "Rijon@"
	db "Johto@"
	db "Cancel@"

SaffronMagnetTrainNPC2:
	jumptextfaceplayer SaffronMagnetTrainNPC2_Text_163639

SaffronMagnetTrain_161430:
	writetext SaffronMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, SaffronMagnetTrain_161430_Movement1
	applymovement 0, SaffronMagnetTrain_161430_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 1
	special Special_MagnetTrain
	wait 14
	warp TORENIA_MAGNET_TRAIN, 11, 6
	applymovement 2, SaffronMagnetTrain_161430_Movement3
	applymovement 0, SaffronMagnetTrain_161430_Movement4
	applymovement 2, SaffronMagnetTrain_161430_Movement5
	jumptext SaffronMagnetTrain_161430_Text_1615c0

SaffronMagnetTrain_161430_Movement1:
	step_up
	step_up
	step_left
	step_end

SaffronMagnetTrain_161430_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

SaffronMagnetTrain_161430_Movement3:
	step_down
	step_left
	step_end

SaffronMagnetTrain_161430_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

SaffronMagnetTrain_161430_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

SaffronMagnetTrain_161460:
	writetext SaffronMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, SaffronMagnetTrain_161460_Movement1
	applymovement 0, SaffronMagnetTrain_161460_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 1
	special Special_MagnetTrain
	wait 14
	warp BOTAN_MAGNET_TRAIN, 11, 6
	applymovement 2, SaffronMagnetTrain_161460_Movement3
	applymovement 0, SaffronMagnetTrain_161460_Movement4
	applymovement 2, SaffronMagnetTrain_161460_Movement5
	jumptext SaffronMagnetTrain_161460_Text_161410

SaffronMagnetTrain_161460_Movement1:
	step_up
	step_up
	step_left
	step_end

SaffronMagnetTrain_161460_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

SaffronMagnetTrain_161460_Movement3:
	step_down
	step_left
	step_end

SaffronMagnetTrain_161460_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

SaffronMagnetTrain_161460_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

SaffronMagnetTrain_161490:
	checkitem MAGNET_PASS
	if_equal 0, SaffronMagnetTrain_1613e0
	writetext SaffronMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, SaffronMagnetTrain_161490_Movement1
	applymovement 0, SaffronMagnetTrain_161490_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 1
	special Special_MagnetTrain
	wait 14
	warp GOLDENROD_MAGNET_TRAIN, 11, 6
	applymovement 2, SaffronMagnetTrain_161490_Movement3
	applymovement 0, SaffronMagnetTrain_161490_Movement4
	applymovement 2, SaffronMagnetTrain_161490_Movement5
	jumptext SaffronMagnetTrain_161490_Text_1615f0

SaffronMagnetTrain_161490_Movement1:
	step_up
	step_up
	step_left
	step_end

SaffronMagnetTrain_161490_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

SaffronMagnetTrain_161490_Movement3:
	step_down
	step_left
	step_end

SaffronMagnetTrain_161490_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

SaffronMagnetTrain_161490_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

SaffronMagnetTrain_1613e0:
	writetext SaffronMagnetTrain_1613e0_Text_161650
	endtext

SaffronMagnetTrainNPC1_Text_1610ba:
	ctxt "Hello."

	para "Where do you want"
	line "to go?"
	done

SaffronMagnetTrainNPC2_Text_163639:
	ctxt "Just riding on"
	line "the train is a"
	cont "nice way to relax."
	done

SaffronMagnetTrain_161430_Text_1611bf:
	ctxt "OK, please enter"
	line "the magnet train."
	done

SaffronMagnetTrain_161430_Text_1615c0:
	text_jump MagnetTrainReachedTorenia

SaffronMagnetTrain_161460_Text_161410:
	text_jump MagnetTrainReachedBotan

SaffronMagnetTrain_161490_Text_1615f0:
	text_jump MagnetTrainReachedGoldenrod

SaffronMagnetTrain_1613e0_Text_161650:
	ctxt "You need a Magnet"
	line "Pass to go there."
	done

SaffronMagnetTrain_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $11, $8, 6, SAFFRON_CITY
	warp_def $11, $9, 6, SAFFRON_CITY
	warp_def $5, $6, 4, CAPER_CITY
	warp_def $5, $b, 6, GOLDENROD_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 9, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronMagnetTrainNPC1, -1
	person_event SPRITE_ROCKER, 14, 11, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_YELLOW, 0, 0, SaffronMagnetTrainNPC2, -1
