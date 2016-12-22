IlksLab_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

IlksLabBookshelf1:
	jumpstd difficultbookshelf

IlksLabBookshelf2:
	jumpstd difficultbookshelf

IlksLabBookshelf3:
	jumpstd difficultbookshelf

IlksLabBookshelfFortran:
	jumptext IlksLabBookshelfFortran_Text

IlksLabBookshelfKalos:
	jumptext IlksLabBookshelfKalos_Text

IlksLabBookshelfFairyTales:
	jumptext IlksLabBookshelfFairyTales_Text

IlksLabBookshelfSpeakNormally:
	jumptext IlksLabBookshelfSpeakNormally_Text

IlksLabProfIlk:
	checkevent EVENT_MET_ILK_PRE
	iffalse IlkBeforeBrother
	checkevent EVENT_RIVAL_ROUTE_69
	sif false, then
		faceplayer
		jumptext IlkBeforeBrotherAfterText
	sendif
	
	checkevent EVENT_MET_ILK
	iftrue IlksLab_AlreadyMetIlk
	faceplayer
	opentext
	writetext IlksLab_DiscoveredPlayerText
	setflag ENGINE_POKEDEX
	writetext IlksLab_Text_GotPokedex
	playwaitsfx SFX_DEX_FANFARE_230_PLUS
	setevent EVENT_MET_ILK
	clearevent EVENT_GOT_POKEDEX
	jumptext IlksLab_Text_ExplainPokedex

IlksLab_AlreadyMetIlk:
	faceplayer
	checkflag ENGINE_ELECTRONBADGE
	iftrue IlksLab_AfterElectronBadge
	jumptext IlksLab_Text_CheckLarvitar

IlksLab_AfterElectronBadge:
	faceplayer
	opentext
	checkevent EVENT_RIJON_LEAGUE_WON
	iftrue IlkLab_AfterRijonLeague
	checkevent EVENT_ILK_EARTHQUAKE
	iftrue IlksLab_DuringEarthquakes
	setevent EVENT_ILK_EARTHQUAKE
	jumptext IlksLab_Text_EarthquakeExplanation

IlksLab_DuringEarthquakes:
	jumptext IlksLab_DuringEarthquakes_Text

IlkLab_AfterRijonLeague:
	jumptext IlksLab_AfterRijonLeague_Text
	
IlkBeforeBrother:
	setevent EVENT_MET_ILK_PRE
	setevent EVENT_CAPER_SHOVELING_SNOW
	opentext
	writetext IlksLab_Text_InitialSelfSpeech
	waitbutton
	closetext
	pause 16
	showemote EMOTE_SHOCK, $2, 16
	pause 16
	faceplayer
	jumptext IlkBeforeBrotherText
	
IlkBeforeBrotherAfterText:
	ctxt "Please make sure"
	line "my brother is"
	cont "safe."
	
	para "He is on Route 69,"
	line "north of the city."
	done

IlkBeforeBrotherText:
	ctxt "<...>!"

	para "What, what is it?"

	para "Who are you?"

	para "Who am I?"

	para "Why, I am"
	line "Professor Ilk!"

	para "I'm the region's"
	line "leading #mon"
	cont "researcher!"

	para "<...>"

	para "Oh, that's my"
	line "Larvitar!"

	para "I couldn't find"
	line "it anywhere."

	para "Strange, Larvitar"
	line "seems to be very"
	cont "fond of you."

	para "<...>"

	para "<...>I'd hate to"
	line "ask but<...>"

	para "<...>could you do me"
	line "a favor?"
	
	para "Please check on"
	line "my brother."
	
	para "He isn't answering"
	line "his phone, so I'm"
	cont "worried."
	
	para "He lives north of"
	line "the city on"
	cont "Route 69."
	
	para "Bring my Larvitar"
	line "with you just to"
	cont "be safe."
	done
	

IlksLab_AfterRijonLeague_Text:
	ctxt "<PLAYER>!"

	para "I heard the good"
	line "news!"

	para "You're the new"
	line "champion of the"
	cont "Rijon League!"

	para "I'm not surprised"
	line "at all."

	para "Like I said,"
	line "#mon training"
	para "talent resides in"
	line "your bloodline!"

	para "If you're looking"
	line "for more battles,"

	para "you should try"            
	line "visiting Rijon."

	para "There's a tunnel"
	line "north of here that"
	cont "leads to Rijon."

	para "Best of luck my"
	line "friend!"
	done

IlksLabBookshelfFortran_Text:
	ctxt "<PLAYER> opened a"
	line "book on the very"
	cont "top shelf<...>"

	para "'Best Fortran"
	line "Practices'"
	done

IlksLabBookshelfKalos_Text:
	ctxt "<PLAYER> opened a"
	line "random book<...>"

	para "'Why not study"
	line "abroad in Kalos?'"
	done

IlksLabBookshelfFairyTales_Text:
	ctxt "<PLAYER> found an"
	line "old book, covered"
	cont "thick in dust<...>"

	para "'Naljo Fairy"
	line "Tales - featuring"
	cont "Varaneous'"
	done

IlksLabBookshelfSpeakNormally_Text:
	ctxt "<PLAYER> opened a"
	line "book that looked"
	cont "well used<...>"

	para "'How to speak"
	line "normally and"
	cont "not annoy others'"
	done

IlksLab_Text_InitialSelfSpeech:
	ctxt "<...>"

	para "<...>Hm, yes<...>"

	para "<...>Yes, that"
	line "makes sense<...>"

	para "I should have a"
	line "book about Naljo"
	cont "lore somewhere<...>"
	done

IlksLab_DiscoveredPlayerText:
	ctxt "<PLAYER>!"
	
	para "Thank you for"
	line "saving my brother!"
	
	para "He called me and"
	line "couldn't stop"
	
	para "talking about how"
	line "you used my"
	
	para "Larvitar to defeat"
	line "that crazy kid!"

	para "You know what?"

	para "Keep my Larvitar."

	para "In fact, you"
	line "should take this"
	cont "handy invention."
	prompt

IlksLab_Text_GotPokedex:
	ctxt "<PLAYER> got"
	line "a #dex!"
	done

IlksLab_Text_ExplainPokedex:
	ctxt "This is a #dex."

	para "It records all the"
	line "#mon you've seen"
	cont "or caught!"

	para "Build a team and"
	line "see if you can"

	para "continue your"
	line "father's legacy!"
	done

IlksLab_Text_CheckLarvitar:
	ctxt "How is my old"
	line "Larvitar doing?"

	para "I hope it's well!"
	done

IlksLab_Text_EarthquakeExplanation:
	ctxt "Oh, <PLAYER>!"

	para "It's been a while"
	line "since we first"
	cont "met, hasn't it?"

	para "There's something"
	line "I do need to talk"
	cont "to you about."

	para "There's been a"
	line "recent surge of"
	cont "bad earthquakes."

	para "According to the"
	line "'Hayward Lab of"
	cont "Paleoseismology',"

	para "these earthquakes"
	line "aren't authentic."

	para "The first strange"
	line "earthquake hit the"
	cont "Johto location of"
	cont "Goldenrod City,"

	para "wasn't it around"
	line "five years ago?"

	para "This is the same"
	line "kind of quake"
	cont "that trapped you"
	cont "in Naljo<...>"

	para "My only lead is an"
	line "underground city,"

	para "full of miners"
	line "and geologists."

	para "It might be linked"
	line "to the earthquakes"
	cont "terrorising Naljo."

	para "You can find the"
	line "underground city"
	para "somewhere south of"
	line "Torenia City."

	para "I need you to go"
	line "down there, and"

	para "investigate these"
	line "artificial quakes."

	para "<...>"

	para "Oh, you went to"
	line "Torenia City"
	cont "very recently?"

	para "<...>"

	para "I see."

	para "I'll let the guard"
	line "know the plan and"
	cont "he'll clear you."
	done

IlksLab_DuringEarthquakes_Text:
	ctxt "Please look into"
	line "the disturbances"
	para "going on in the"
	line "underground city."
	done

IlksLab_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $b, $4, 5, CAPER_CITY
	warp_def $b, $5, 5, CAPER_CITY

	;xy triggers
	db 0

	;signposts
	db 7
	signpost 1, 6, SIGNPOST_READ, IlksLabBookshelf1
	signpost 1, 7, SIGNPOST_READ, IlksLabBookshelf2
	signpost 1, 8, SIGNPOST_READ, IlksLabBookshelf3
	signpost 9, 6, SIGNPOST_READ, IlksLabBookshelfFortran
	signpost 9, 7, SIGNPOST_READ, IlksLabBookshelfKalos
	signpost 9, 8, SIGNPOST_READ, IlksLabBookshelfFairyTales
	signpost 9, 9, SIGNPOST_READ, IlksLabBookshelfSpeakNormally

	;people-events
	db 2
	person_event SPRITE_ELM, 2, 6, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, IlksLabProfIlk, EVENT_MET_ILK
	person_event SPRITE_ELM, 3, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, IlksLab_AlreadyMetIlk, EVENT_GOT_POKEDEX
