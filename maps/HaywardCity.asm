HaywardCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, HaywardCity_SetFlyFlag

HaywardCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_HAYWARD_CITY
	return

HaywardCityHiddenItem_1:
	dw EVENT_HAYWARD_CITY_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

HaywardCityHiddenItem_2:
	dw EVENT_HIDDEN_GOLD_EGG
	db GOLD_EGG

HaywardCitySignpost1:
	jumpstd martsign

HaywardCitySignpost2:
	ctxt "Paleoseismology"
	next "lab."
	done

HaywardCitySignpost3:
	jumptext HaywardCitySignpost3_Text_3317ab

HaywardCitySignpost4:
	jumpstd pokecentersign

HaywardCityNPC1:
	jumptextfaceplayer HaywardCityNPC1_Text_3329fb

HaywardCityNPC2:
	jumptextfaceplayer HaywardCityNPC2_Text_332acb

HaywardCity_Trainer_1:
	trainer EVENT_HAYWARD_CITY_TRAINER_1, PATROLLER, 19, HaywardCity_Trainer_1_Text_33270b, HaywardCity_Trainer_1_Text_332909, $0000, .Script

.Script:
	callasm CheckIfWearingSuit
	sif true
		jumptext HaywardCityAfterSuit
	opentext
	writetext HaywardCityBlueAfterText
	yesorno
	sif false 
		jumptext HaywardCityBlueSayNo
	callasm GivePaletteSuit
	jumptext HaywardCityAcceptSuit

GivePaletteSuit:
	ld a, [wPlayerGender]
	and $f1
	add $c
	ld [wPlayerGender], a
	jp ReplaceKrisSprite

HaywardCity_Item_1:
	db KINGS_ROCK, 1

CheckIfWearingSuit:
	ld a, [wPlayerGender]
	and $e
	cp $c
	jr nc, .insuit
	xor a
	ld [hScriptVar], a
	ret

.insuit
	ld a, 1
	ld [hScriptVar], a
	ret

HaywardCityBlueAfterText:
	ctxt "Now that you're"
	line "an Honorary"
	cont "Palette Patroller<...>"

	para "Would you like"
	line "to wear our gear?"

	para "You'll certainly"
	line "look spiffy in"
	cont "the span<...>"

	para "I mean garb."

	para "Interested?"
	done

HaywardCityBlueSayNo:
	ctxt "No big deal."

	para "I'll keep it handy"
	line "in case you change"
	cont "your mind later."
	done

HaywardCityAcceptSuit:
	ctxt "Lookin' good!"

	para "The suit's on"
	line "tight, so if you"

	para "want to take it"
	line "off, you'll have"

	para "to visit the salon"
	line "in Oxalis City."

	para "However, I don't"
	line "see why you'd want"
	cont "take it off!"
	done

HaywardCityAfterSuit:
	ctxt "Lookin' good!"

	para "It's like looking"
	line "into a mirror!"
	done

HaywardCitySignpost3_Text_3317ab:
	ctxt "The amount of"
	line "graffiti on this"
	para "sign has made"
	line "this illegible."
	done

HaywardCityNPC1_Text_3329fb:
	ctxt "I'm so mad that I"
	line "can't read that"
	cont "sign!"
	done

HaywardCityNPC2_Text_332acb:
	ctxt "This city sure"
	line "has changed."

	para "I don't feel safe"
	line "walking around"
	para "town without a"
	line "#mon to protect"
	cont "me."
	done

HaywardCity_Trainer_1_Text_33270b:
	ctxt "Oh, it's you."

	para "I'm just reflecting"
	line "on our failed"
	cont "history."

	para "To think it all"
	line "started here<...>"

	para "Before I came"
	line "along, the mighty"
	para "Red patroller"
	line "temporary took "
	para "over Team Rocket,"
	line "until some kid"

	para "named Brown put a"
	line "stop to that."

	para "For the last half"
	line "decade, he was"

	para "trying to pick up"
	line "the pieces, and"

	para "now that I guess"
	line "the rest of the"

	para "Pallet Patrollers"
	line "want nothing to"

	para "do with our"
	line "ambitions, then"
	cont "it's up to me."

	para "Let me see if"
	line "you're good"
	para "enough to become"
	line "an honorary"
	cont "patroller."

	para "My team has grown"
	line "since last time."
	done

HaywardCity_Trainer_1_Text_332909:
	ctxt "Hey now, you have"
	line "my respect."
	done

HaywardCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 9
	warp_def $f, $d, 1, HAYWARD_MART_F1
	warp_def $f, $10, 5, HAYWARD_MART_F1
	warp_def $17, $20, 1, HAYWARD_EARTHQUAKE_LAB
	warp_def $d, $1d, 1, HAYWARD_MAWILE
	warp_def $21, $10, 1, ROUTE_52_GATE
	warp_def $17, $1b, 1, HAYWARD_POKECENTER
	warp_def $b, $4, 1, RIJON_HIDDEN_BASEMENT
	warp_def $d, $1, 1, HAYWARD_HOUSE
	warp_def $21, $11, 1, ROUTE_52_GATE

	;xy triggers
	db 0

	;signposts
	db 6
	signpost 15, 18, SIGNPOST_READ, HaywardCitySignpost1
	signpost 25, 35, SIGNPOST_LOAD, HaywardCitySignpost2
	signpost 19, 23, SIGNPOST_READ, HaywardCitySignpost3
	signpost 23, 28, SIGNPOST_READ, HaywardCitySignpost4
	signpost 22, 10, SIGNPOST_ITEM, HaywardCityHiddenItem_1
	signpost 11, 8, SIGNPOST_ITEM, HaywardCityHiddenItem_2

	;people-events
	db 4
	person_event SPRITE_LASS, 19, 20, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, HaywardCityNPC1, -1
	person_event SPRITE_FISHER, 16, 32, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, HaywardCityNPC2, -1
	person_event SPRITE_PALETTE_PATROLLER, 12, 9, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 2, 0, HaywardCity_Trainer_1, -1
	person_event SPRITE_POKE_BALL, 8, 31, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, HaywardCity_Item_1, EVENT_HAYWARD_CITY_ITEM_1
