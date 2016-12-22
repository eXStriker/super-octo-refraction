DreamNewBark_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

DreamNewBarkSignpost1:
	jumpstd magazinebookshelf

DreamNewBarkSignpost2:
	jumpstd magazinebookshelf

DreamNewBarkNPC1:
	faceplayer
	opentext
	writetext DreamNewBarkNPC1_Text_183b00
	waitbutton
	playsound SFX_PERISH_SONG
	showFX 67, 255
	setevent EVENT_HAUNTED_FOREST_GENGAR
	warp HAUNTED_MANSION, 49, 24
	jumptext DreamNewBarkNPC1_Text_183f26

DreamNewBarkNPC1_Text_183b00:
	ctxt "Greetings."

	para "What?"

	para "No, I'm not a"
	line "Pallet Patroller."

	para "In fact, I don't"
	line "even exist!"

	para "You are merely"
	line "lucid dreaming."

	para "You subconsciously"
	line "created me a mere"
	cont "few minutes ago."

	para "<...>"

	para "What role I have"
	line "in your dream<...>?"

	para "Well<...> Do you"
	line "understand the"
	para "main problems"
	line "facing the region"
	cont "known as Naljo?"

	para "You, with your"
	line "#mon, have the"
	para "power to restore"
	line "this nation to"
	para "it's now somewhat"
	line "former glory."

	para "<...>"

	para "How I know that?"

	para "You made me, so."

	para "Don't you know that"
	line "somewhere in you?"

	para "The region which"
	line "you came from<...>"

	para "It is without any"
	line "problems, right?"

	para "Naljo was that way"
	line "too in the past -"
	cont "free of problems."

	para "<...>"

	para "What happened?"

	para "Corruption."

	para "Greed."

	para "Depression."

	para "<...>"

	para "Be more specific?"

	para "But that's all"
	line "you know, you"
	cont "told me this."

	para "Your region could"
	line "be next, together"
	para "with all the other"
	line "regions that lie"
	cont "in proximity<...>"

	para "<...>"

	para "What do you mean"
	line "'greed ruined"
	cont "the Naljo Region?'"

	para "<...>"

	para "Gengar: Mmmm!"
	line "Very tasty!"

	para "Lots of delicious"
	line "conflict in this"
	para "area, I'm going to"
	line "enjoy this meal!"

	para "<...>"

	para "Looks like I'm"
	line "dinner for Gengar."

	para "Don't forget what"
	line "I've told you. "

	para "You can turn out"
	line "to be a hero<...>"

	para "You will find out"
	line "everything, and"
	para "grow to understand"
	line "it, soon enough."

	para "Trust me<...>"

	para "As in<...>"

	para "Trust yourself<...>"
	done

DreamNewBarkNPC1_Text_183f26:
	ctxt "-BELCH-"

	para "That was yummy!"

	para "I need to watch"
	line "my belly's weight."

	para "No more dreams"
	line "for me for at"
	cont "least a week!"
	done

DreamNewBark_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $1, $15, 4, ACANIA_LIGHTHOUSE_F1
	warp_def $3, $5, 14, HEATH_GYM_GATE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 0, 0, SIGNPOST_READ, DreamNewBarkSignpost1
	signpost 0, 0, SIGNPOST_READ, DreamNewBarkSignpost2

	;people-events
	db 1
	person_event SPRITE_PALETTE_PATROLLER, 14, 10, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_PLAYER + 8, 0, 0, DreamNewBarkNPC1, -1
