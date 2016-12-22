ToreniaCelebrity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ToreniaCelebrityNPC:
	faceplayer
	opentext
	checkevent EVENT_TORENIA_CITY_CELEB
	sif true
		jumptext ToreniaCelebrity_Text_AfterItem
	writetext ToreniaCelebrity_Text_BeforeItem
	buttonsound
	verbosegiveitem SHNYAPRICORN, 1
	sif true
		setevent EVENT_TORENIA_CITY_CELEB
	closetext
	end

ToreniaCelebrityFearow:
	opentext
	writetext ToreniaCelebrity_Text_FearowCry
	cry FEAROW
	endtext

ToreniaCelebrity_Text_BeforeItem:
	ctxt "<...>"

	para "I hate being a"
	line "celebrity."

	para "If you get out of"
	line "my house I'll"
	cont "give you this."
	done

ToreniaCelebrity_Text_FearowCry:
	ctxt "FEAROW: Feero!"
	done

ToreniaCelebrity_Text_AfterItem:
	ctxt "Why do people"
	line "think it's OK to"

	para "just walk into my"
	line "house without my"
	cont "permission?"
	done

ToreniaCelebrity_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 10, TORENIA_CITY
	warp_def $7, $3, 10, TORENIA_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_COOLTRAINER_F, 3, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, ToreniaCelebrityNPC, -1
	person_event SPRITE_DAISY, 8, 28, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, 8 + PAL_OW_BROWN, 0, 0, ToreniaCelebrityFearow, -1
