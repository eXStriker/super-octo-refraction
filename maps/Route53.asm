Route53_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route53HiddenItem_1:
	dw EVENT_ROUTE_53_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route53Signpost1:
	ctxt "<UP> Seashore City"
	next "<DOWN> Gravel Town"
	done

Route53NPC1:
	faceplayer
	opentext
	checkevent EVENT_ROUTE_53_ELIXIR_GUY
	sif true
		jumptext Route53_331cb5_Text_331d5c
	writetext Route53NPC1_Text_331cbb
	verbosegiveitem ELIXIR, 1
	sif false
		jumptext Route53_331cb2_Text_331d2e
	setevent EVENT_ROUTE_53_ELIXIR_GUY
	closetext
	end

Route53NPC2:
	fruittree 7

Route53NPC1_Text_331cbb:
	ctxt "Hi there!"

	para "Gravel Town mart"
	line "is giving out free"
	cont "samples today!"

	para "Don't hesitate and"
	line "enjoy your gift!"
	sdone

Route53_331cb5_Text_331d5c:
	ctxt "Sorry, no more"
	line "free samples!"
	done

Route53_331cb2_Text_331d2e:
	ctxt "Actually, come"
	line "back when you"
	cont "have more room."
	done

Route53_MapEventHeader ;filler
	db 0, 0

;warps
	db 0

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 27, 9, SIGNPOST_LOAD, Route53Signpost1
	signpost 4, 16, SIGNPOST_ITEM, Route53HiddenItem_1

	;people-events
	db 2
	person_event SPRITE_SUPER_NERD, 17, 11, SPRITEMOVEDATA_00, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 0, 0, Route53NPC1, -1
	person_event SPRITE_FRUIT_TREE, 2, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, Route53NPC2, -1
