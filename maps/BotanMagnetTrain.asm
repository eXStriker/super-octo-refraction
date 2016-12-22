BotanMagnetTrain_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

BotanMagnetTrainNPC1:
	opentext
	writetext BotanMagnetTrainNPC1_Text_1610ba
	loadmenudata BotanMagnetTrainMenu
	verticalmenu
	closewindow
	if_equal 1, BotanMagnetTrain_161430
	if_equal 2, BotanMagnetTrain_161490
	if_equal 3, BotanMagnetTrain_1614c0
	closetext
	end

BotanMagnetTrainMenu:
	db $40 ; flags
	db 01, 10 ; start coords
	db 11, 19 ; end coords
	dw BotanMagnetTrainOptions
	db 1 ; default option

BotanMagnetTrainOptions:
	db $80
	db $4
	db "Naljo@"
	db "Johto@"
	db "Kanto@"
	db "Cancel@"

BotanMagnetTrainNPC2:
	jumptextfaceplayer BotanMagnetTrainNPC2_Text_16369d

BotanMagnetTrain_161430:
	writetext BotanMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, BotanMagnetTrain_161430_Movement1
	applymovement 0, BotanMagnetTrain_161430_Movement2
	writebyte 1
	playmusic MUSIC_MAGNET_TRAIN
	special Special_MagnetTrain
	wait 14
	warp TORENIA_MAGNET_TRAIN, 11, 6
	applymovement 2, BotanMagnetTrain_161430_Movement3
	applymovement 0, BotanMagnetTrain_161430_Movement4
	applymovement 2, BotanMagnetTrain_161430_Movement5
	jumptext BotanMagnetTrain_161430_Text_1615c0

BotanMagnetTrain_161430_Movement1:
	step_up
	step_up
	step_left
	step_end

BotanMagnetTrain_161430_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

BotanMagnetTrain_161430_Movement3:
	step_down
	step_left
	step_end

BotanMagnetTrain_161430_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

BotanMagnetTrain_161430_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

BotanMagnetTrain_161490:
	checkitem MAGNET_PASS
	if_equal 0, BotanMagnetTrain_1613e0
	writetext BotanMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, BotanMagnetTrain_161490_Movement1
	applymovement 0, BotanMagnetTrain_161490_Movement2
	writebyte 0
	playmusic MUSIC_MAGNET_TRAIN
	special Special_MagnetTrain
	wait 14
	warp GOLDENROD_MAGNET_TRAIN, 11, 6
	applymovement 2, BotanMagnetTrain_161490_Movement3
	applymovement 0, BotanMagnetTrain_161490_Movement4
	applymovement 2, BotanMagnetTrain_161490_Movement5
	jumptext BotanMagnetTrain_161490_Text_1615f0

BotanMagnetTrain_161490_Movement1:
	step_up
	step_up
	step_left
	step_end

BotanMagnetTrain_161490_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

BotanMagnetTrain_161490_Movement3:
	step_down
	step_left
	step_end

BotanMagnetTrain_161490_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

BotanMagnetTrain_161490_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

BotanMagnetTrain_1614c0:
	checkitem MAGNET_PASS
	if_equal 0, BotanMagnetTrain_1613e0
	writetext BotanMagnetTrain_161430_Text_1611bf
	waitbutton
	closetext
	applymovement 2, BotanMagnetTrain_1614c0_Movement1
	applymovement 0, BotanMagnetTrain_1614c0_Movement2
	writebyte 0
	playmusic MUSIC_MAGNET_TRAIN
	special Special_MagnetTrain
	wait 14
	warp SAFFRON_MAGNET_TRAIN, 11, 6
	applymovement 2, BotanMagnetTrain_1614c0_Movement3
	applymovement 0, BotanMagnetTrain_1614c0_Movement4
	applymovement 2, BotanMagnetTrain_1614c0_Movement5
	jumptext BotanMagnetTrain_1614c0_Text_161620

BotanMagnetTrain_1614c0_Movement1:
	step_up
	step_up
	step_left
	step_end

BotanMagnetTrain_1614c0_Movement2:
	step_up
	step_up
	step_up
	step_up
	step_left
	step_left
	step_left
	step_up
	step_end

BotanMagnetTrain_1614c0_Movement3:
	step_down
	step_left
	step_end

BotanMagnetTrain_1614c0_Movement4:
	step_left
	step_left
	step_down
	step_down
	step_down
	step_down
	step_down
	turn_head_up
	step_end

BotanMagnetTrain_1614c0_Movement5:
	step_right
	step_up
	turn_head_down
	step_end

BotanMagnetTrain_1613e0:
	writetext BotanMagnetTrain_1613e0_Text_161650
	endtext

BotanMagnetTrainNPC1_Text_1610ba:
	ctxt "Hello."

	para "Where do you want"
	line "to go?"
	done

BotanMagnetTrainNPC2_Text_16369d:
	ctxt "A cave used to"
	line "stand here, but"

	para "they demolished"
	line "it to make way"

	para "for this very"
	line "train station."
	done

BotanMagnetTrain_161430_Text_1611bf:
	ctxt "OK, please enter"
	line "the magnet train."
	done

BotanMagnetTrain_161430_Text_1615c0:
	text_jump MagnetTrainReachedTorenia

BotanMagnetTrain_161490_Text_1615f0:
	text_jump MagnetTrainReachedGoldenrod

BotanMagnetTrain_1614c0_Text_161620:
	text_jump MagnetTrainReachedSaffron

BotanMagnetTrain_1613e0_Text_161650:
	ctxt "You need a Magnet"
	line "Pass to go there."
	done

BotanMagnetTrain_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $11, $8, 7, BOTAN_CITY
	warp_def $11, $9, 7, BOTAN_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 9, 9, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, BotanMagnetTrainNPC1, -1
	person_event SPRITE_GENTLEMAN, 14, 6, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, BotanMagnetTrainNPC2, -1
