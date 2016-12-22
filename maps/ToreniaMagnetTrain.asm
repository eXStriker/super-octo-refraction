ToreniaMagnetTrain_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ToreniaMagnetTrainNPC1:
	opentext
	writetext ToreniaMagnetTrainNPC1_Text_1610ba
	loadmenudata ToreniaMagnetTrainMenu
	verticalmenu
	closewindow
	if_equal 1, ToreniaMagnetTrain_161460
	if_equal 2, ToreniaMagnetTrain_161490
	if_equal 3, ToreniaMagnetTrain_1614c0
	closetext
	end

ToreniaMagnetTrainMenu:
	db $40 ; flags
	db 01, 10 ; start coords
	db 11, 19 ; end coords
	dw ToreniaMagnetTrainOptions
	db 1 ; default option

ToreniaMagnetTrainOptions:
	db $80
	db $4
	db "Rijon@"
	db "Johto@"
	db "Kanto@"
	db "Cancel@"

ToreniaMagnetTrainNPC2:
	jumptextfaceplayer ToreniaMagnetTrainNPC2_Text_161129

ToreniaMagnetTrain_161460:
	writetext ToreniaMagnetTrain_161460_Text_1611bf
	waitbutton
	closetext
	applymovement 2, ToreniaMagnetTrain_161460_Movement1
	applymovement 0, ToreniaMagnetTrain_161460_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 0
	special Special_MagnetTrain
	wait 14
	warp BOTAN_MAGNET_TRAIN, 11, 6
	applymovement 2, ToreniaMagnetTrain_161460_Movement3
	applymovement 0, ToreniaMagnetTrain_161460_Movement4
	applymovement 2, ToreniaMagnetTrain_161460_Movement5
	jumptext ToreniaMagnetTrain_161460_Text_161410

ToreniaMagnetTrain_161460_Movement1:
	step_up
	step_up
	step_left
	step_end

ToreniaMagnetTrain_161460_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

ToreniaMagnetTrain_161460_Movement3:
	step_down
	step_left
	step_end

ToreniaMagnetTrain_161460_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

ToreniaMagnetTrain_161460_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

ToreniaMagnetTrain_161490:
	checkitem MAGNET_PASS
	if_equal 0, ToreniaMagnetTrain_1613e0
	writetext ToreniaMagnetTrain_161460_Text_1611bf
	waitbutton
	closetext
	applymovement 2, ToreniaMagnetTrain_161490_Movement1
	applymovement 0, ToreniaMagnetTrain_161490_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 0
	special Special_MagnetTrain
	wait 14
	warp GOLDENROD_MAGNET_TRAIN, 11, 6
	applymovement 2, ToreniaMagnetTrain_161460_Movement3
	applymovement 0, ToreniaMagnetTrain_161460_Movement4
	applymovement 2, ToreniaMagnetTrain_161460_Movement5
	jumptext ToreniaMagnetTrain_161490_Text_1615f0

ToreniaMagnetTrain_161490_Movement1:
	step_up
	step_up
	step_left
	step_end

ToreniaMagnetTrain_161490_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

ToreniaMagnetTrain_161490_Movement3:
	step_down
	step_left
	step_end

ToreniaMagnetTrain_161490_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

ToreniaMagnetTrain_161490_Movement5:
	step_right
	step_up
	turn_head_down
	step_end


ToreniaMagnetTrain_1614c0:
	checkitem MAGNET_PASS
	if_equal 0, ToreniaMagnetTrain_1613e0
	writetext ToreniaMagnetTrain_161460_Text_1611bf
	waitbutton
	closetext
	applymovement 2, ToreniaMagnetTrain_161460_Movement1
	applymovement 0, ToreniaMagnetTrain_161460_Movement2
	playmusic MUSIC_MAGNET_TRAIN
	writebyte 0
	special Special_MagnetTrain
	wait 14
	warp SAFFRON_MAGNET_TRAIN, 11, 6
	applymovement 2, ToreniaMagnetTrain_161460_Movement3
	applymovement 0, ToreniaMagnetTrain_161460_Movement4
	applymovement 2, ToreniaMagnetTrain_161460_Movement5
	jumptext ToreniaMagnetTrain_1614c0_Text_161620

ToreniaMagnetTrain_1614c0_Movement1:
	step_up
	step_up
	step_left
	step_end

ToreniaMagnetTrain_1614c0_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

ToreniaMagnetTrain_1614c0_Movement3:
	step_down
	step_left
	step_end

ToreniaMagnetTrain_1614c0_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

ToreniaMagnetTrain_1614c0_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

ToreniaMagnetTrain_1613e0:
	jumptext ToreniaMagnetTrain_1613e0_Text_161650

ToreniaMagnetTrainNPC1_Text_1610ba:
	ctxt "Hello."

	para "Where do you want"
	line "to go?"
	done

ToreniaMagnetTrainNPC2_Text_161129:
	ctxt "I'm stuck in Naljo."

	para "Botan City is"
	line "quarantined and"
	cont "I don't have a"
	cont "pass to get to"
	cont "Johto or Kanto."
	done

ToreniaMagnetTrain_161460_Text_1611bf:
	ctxt "OK, please enter"
	line "the magnet train."
	done

ToreniaMagnetTrain_161460_Text_161410:
	text_jump MagnetTrainReachedBotan

ToreniaMagnetTrain_161490_Text_1615f0:
	text_jump MagnetTrainReachedGoldenrod

ToreniaMagnetTrain_1614c0_Text_161620:
	text_jump MagnetTrainReachedSaffron

ToreniaMagnetTrain_1613e0_Text_161650:
	ctxt "You need a Magnet"
	line "Pass to go there."
	done

ToreniaMagnetTrain_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $11, $8, 4, TORENIA_CITY
	warp_def $11, $9, 4, TORENIA_CITY
	warp_def $1, $4, 4, CAPER_CITY
	warp_def $1, $a, 3, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 9, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ToreniaMagnetTrainNPC1, -1
	person_event SPRITE_GENTLEMAN, 14, 6, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, ToreniaMagnetTrainNPC2, -1
