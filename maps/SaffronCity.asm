SaffronCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaffronCitySignpost1:
	ctxt "Shining, Golden"
	next "Land of Commerce"
	done

SaffronCitySignpost2:
	ctxt "#mon Gym"
	next "Leader: Sabrina"
	done

SaffronCitySignpost3:
	ctxt "Fighting Dojo"
	nl   ""
	next "Everybody"
	next "welcome!"
	done

SaffronCitySignpost4:
	ctxt "Silph Co."
	nl   ""
	next "Central"
	next "Headquarters"
	done

SaffronCitySignpost5:
	ctxt "Mr. Psychic's"
	next "House"
	done

SaffronCitySignpost6:
	ctxt "Magnet Train"
	done

SaffronCitySignpost7:
	jumpstd pokecentersign

SaffronCitySignpost8:
	jumpstd martsign

SaffronCityNPC1:
	jumptextfaceplayer SaffronCityNPC1_Text_1ddf47

SaffronCityNPC2:
	jumptextfaceplayer SaffronCityNPC2_Text_1dda94

SaffronCityNPC3:
	jumptextfaceplayer SaffronCityNPC3_Text_1ddb24

SaffronCityNPC4:
	jumptextfaceplayer SaffronCityNPC4_Text_1dd008

SaffronCityNPC6:
	jumptextfaceplayer SaffronCityNPC6_Text_1ddc7b

SaffronCityNPC5:
	faceplayer
	opentext
	writetext SaffronCityNPC5_Text_1ddc3b
	closetext
	checkevent EVENT_SEEKING_OUT_SILPH_WORKER
	sif false
		end
	showemote 0, 6, 32
	opentext
	writetext SaffronCity_1def0f_Text_1defff
	closetext
	setevent EVENT_APPROACHED_SILPH_WORKER
	clearevent EVENT_SILPH_WORKER_NOT_UPSTAIRS
	warp SILPH_CO, 8, 41
	spriteface 0, 1
	spriteface 4, 3
	;playmusic MUSIC_BLUE
	opentext
	writetext SaffronCity_1def21_Text_1df053
	closetext

	applymovement 4, SaffronCity_BlueApproachWorker
	spriteface 4, 3

	playwaitsfx SFX_SPIDER_WEB
	playwaitsfx SFX_MORNING_SUN
	playwaitsfx SFX_BALL_POOF
	playwaitsfx SFX_RAGE
	playwaitsfx SFX_GIGA_DRAIN
	playwaitsfx SFX_MILK_DRINK
	playwaitsfx SFX_TITLE_SCREEN_ENTRANCE

	spriteface 4, 3
	spriteface 2, 2
	playsound SFX_MASTER_BALL
	opentext
	writetext SaffronCity_1def21_Text_1df092
	closetext
	spriteface 0, 2
	applymovement 4, SaffronCity_1def21_Movement1
	spriteface 4, 3
	opentext
	verbosegiveitem MASTER_BALL, 1
	writetext SaffronCity_1def21_Text_1df16d
	setevent EVENT_CREATED_MASTERBALL
	closetext
	end

SaffronCity_BlueApproachWorker:
	slow_step_right
	step_end

SaffronCity_1def21_Movement1:
	slow_step_down
	slow_step_down
	step_end

SaffronCityNPC1_Text_1ddf47:
	ctxt "People from Naljo"
	line "are so wild and"
	cont "exciting."
	done

SaffronCityNPC2_Text_1dda94:
	ctxt "A famous #mon"
	line "Trainer recently"
	cont "moved into town."

	para "He used to be the"
	line "Viridian City Gym"
	cont "leader."
	done

SaffronCityNPC3_Text_1ddb24:
	ctxt "Silph Co. has"
	line "grown on me ever"

	para "since they star-"
	line "ted being more"

	para "environmentally"
	line "friendly."
	done

SaffronCityNPC4_Text_1dd008:
	ctxt "It's exciting"
	line "living in a big"
	cont "city like this!"
	done

SaffronCityNPC5_Text_1ddc3b:
	ctxt "Nice to get some"
	line "fresh air!"
	sdone

SaffronCityNPC6_Text_1ddc7b:
	ctxt "For security"
	line "reasons, they"

	para "dont allow people"
	line "who are from out-"

	para "side Kanto to"
	line "leave the city."
	done

SaffronCityNPC7_Text_1dd92d:
	ctxt "You want to"
	line "battle my"
	cont "fiancee?"

	para "Well, OK, I'll"
	line "let you in."
	done

SaffronCity_1def0f_Text_1defff:
	ctxt "What, Mr. Oak"
	line "wants me back on"
	cont "the clock?!"

	para "I'm sorry, let's"
	line "run before it's"
	cont "too late!"
	sdone

SaffronCity_1def21_Text_1df053:
	ctxt "I'm so sorry boss!"

	para "Mr. Oak: Yes yes,"
	line "well finish up"
	cont "your task."
	sdone

SaffronCity_1def21_Text_1df092:
	ctxt "Mr. Oak: Good job!"

	para "<PLAYER>!"

	para "Thank you for"
	line "witnessing a"

	para "very important"
	line "event in Silph"
	cont "Co. history!"

	para "The Master Ball,"
	line "it will catch any"

	para "#mon without"
	line "fail!"

	para "Since I like you"
	line "<PLAYER>, I'll let"

	para "you have our very"
	line "first retail"
	cont "Master Ball!"
	sdone

SaffronCity_1def21_Text_1df16d:
	ctxt "Are you also"
	line "interested in a"
	cont "#mon battle?"

	para "I guess I could,"
	line "I'm kind of rusty"

	para "but I suppose I"
	line "could."

	para "Talk to me when-"
	line "ever you want a"
	cont "battle."
	sdone

SaffronCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 16
	warp_def $b, $20, 1, SAFFRON_FIGHTING_DOJO
	warp_def $b, $28, 31, SAFFRON_GYM
	warp_def $25, $23, 1, SAFFRON_MR_PSYCHIC
	warp_def $15, $f, 1, CAPER_CITY
	warp_def $13, $1f, 1, SAFFRON_MART
	warp_def $d, $e, 2, SAFFRON_MAGNET_TRAIN
	warp_def $1d, $18, 1, SILPH_CO
	warp_def $25, $f, 1, SAFFRON_POKECENTER
	warp_def $5, $1a, 1, SAFFRON_GATES
	warp_def $1a, $4, 7, SAFFRON_GATES
	warp_def $1b, $4, 8, SAFFRON_GATES
	warp_def $2d, $1a, 3, SAFFRON_GATES
	warp_def $2d, $1b, 4, SAFFRON_GATES
	warp_def $1a, $2f, 5, SAFFRON_GATES
	warp_def $1b, $2f, 1, SAFFRON_GATES
	warp_def 19, 15, 1, SAFFRON_COPYCATS_HOUSE

	;xy triggers
	db 0

	;signposts
	db 8
	signpost 13, 25, SIGNPOST_LOAD, SaffronCitySignpost1
	signpost 13, 41, SIGNPOST_LOAD, SaffronCitySignpost2
	signpost 13, 33, SIGNPOST_LOAD, SaffronCitySignpost3
	signpost 29, 21, SIGNPOST_LOAD, SaffronCitySignpost4
	signpost 37, 33, SIGNPOST_LOAD, SaffronCitySignpost5
	signpost 13, 19, SIGNPOST_LOAD, SaffronCitySignpost6
	signpost 37, 16, SIGNPOST_READ, SaffronCitySignpost7
	signpost 19, 32, SIGNPOST_READ, SaffronCitySignpost8

	;people-events
	db 6
	person_event SPRITE_POKEFAN_M, 30, 19, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 0, 0, SaffronCityNPC1, -1
	person_event SPRITE_FISHER, 39, 29, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, SaffronCityNPC2, -1
	person_event SPRITE_COOLTRAINER_F, 32, 36, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 0, -1, -1, 0, 0, 0, SaffronCityNPC3, -1
	person_event SPRITE_FISHER, 15, 25, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, SaffronCityNPC4, -1
	person_event SPRITE_YOUNGSTER, 27, 21, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 0, -1, -1, 8 + PAL_OW_RED, 0, 0, SaffronCityNPC5, EVENT_APPROACHED_SILPH_WORKER
	person_event SPRITE_YOUNGSTER, 22, 35, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronCityNPC6, -1
