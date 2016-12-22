Route80Nobu_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route80NobuNPC1:
	faceplayer
	opentext
	checkevent EVENT_VARANEOUS_REVIVED
	iffalse Route80Nobu_2e8124
	checkevent EVENT_NOBU_EXPLAINS_PROTECTORS
	iffalse Route80Nobu_2e812a
	jumptext Route80NobuNPC1_Text_2e8156

Route80NobuNPC2:
	checkevent EVENT_RESCUED_NOBU
	iffalse Route80Nobu_2e8034
	faceplayer
	cry AGGRON
	waitsfx
	end

Route80Nobu_2e8124:
	jumptext Route80Nobu_2e8124_Text_2e81a3

Route80Nobu_2e812a:
	writetext Route80Nobu_2e812a_Text_2e820f
	waitbutton
	writetext Route80Nobu_2e812a_Text_2e827a
	waitbutton
	writetext Route80Nobu_2e812a_Text_2e8422
	waitbutton
	writetext Route80Nobu_2e812a_Text_2e84b8
	waitbutton
	writetext Route80Nobu_2e812a_Text_2e85be
	waitbutton
	writetext Route80Nobu_2e812a_Text_2e8677
	waitbutton
	writetext Route80Nobu_2e812a_Text_2e8782
	waitbutton
	writetext Route80Nobu_2e812a_Text_2e8929
	waitbutton
	setevent EVENT_NOBU_EXPLAINS_PROTECTORS
	jumptext Route80Nobu_2e812a_Text_2e8a8f

Route80Nobu_2e8034:
	faceplayer
	cry AGGRON
	waitsfx
	opentext
	writetext Route80Nobu_2e8034_Text_2e8068
	waitbutton
	checkcode VAR_PARTYCOUNT
	if_equal 6, Route80Nobu_2e8062
	special SpecialGiveNobusAggron
	disappear 3
	writetext Route80Nobu_2e8034_Text_2e80be
	playwaitsfx SFX_FANFARE_2
	setevent EVENT_NOBUS_AGGRON_IN_PARTY
	closetext
	end

Route80Nobu_2e8062:
	jumptext Route80Nobu_2e8062_Text_2e80d9

Route80NobuNPC1_Text_2e8156:
	ctxt "At this point, we"
	line "can only hope that"

	para "the Guardians don't"
	line "harm anybody else."
	done

Route80Nobu_2e8124_Text_2e81a3:
	ctxt "Get moving!"

	para "Go back to the"
	line "path where you"
	cont "found me, and"

	para "put a stop to"
	line "the awakening."

	para "There's no time"
	line "for us to lose!"
	done

Route80Nobu_2e812a_Text_2e820f:
	ctxt "We're in a bad"
	line "situation and we"
	cont "need your help."

	para "You see, Lance is"
	line "the reincarnation"
	cont "of the Messenger."
	done

Route80Nobu_2e812a_Text_2e827a:
	ctxt "<...>Hmm, who the"
	line "Messenger was?"

	para "Well<...> allow me"
	line "to start from the"
	cont "very beginning."

	para "Thousands of years"
	line "ago, Naljo was an"

	para "isolated region,"
	line "which was the wish"
	cont "of the Guardians."

	para "Varaneous created"
	line "Naljo as an image"

	para "of its own ideal"
	line "enviroment."

	para "It desired to have"
	line "community with a"
	cont "high value system,"

	para "where all humans"
	line "and #mon were"

	para "free from all the"
	line "troubles brewing"
	cont "outside of Naljo."

	para "Each Guardian was"
	line "handed an island"
	cont "to rule over."

	para "While they ruled"
	line "very differently,"

	para "the agreement was"
	line "that the rest of"

	para "the world was not"
	line "to interfere with"
	cont "the Naljo natives."

	para "Where instead of"
	line "fighting over"
	cont "our differences,"

	para "everyone would now"
	line "work together to"
	cont "solve problems."
	done

Route80Nobu_2e812a_Text_2e8422:
	ctxt "The names of the"
	line "4 Guardians were"

	para "Varaneous,"

	para "Raiwato,"

	para "Libabeel,"

	para "and Fambaco."

	para "Each Guardian held"
	line "their own orb,"

	para "which contained"
	line "the very source"
	cont "of their powers."

	para "Of them, Raiwato"
	line "would watch down"
	cont "upon his area,"

	para "in order to ensure"
	line "everyone was kept"
	cont "out of trouble."
	done

Route80Nobu_2e812a_Text_2e84b8:
	ctxt "Fambaco, who was"
	line "the Guardian of"
	cont "nature itself,"

	para "ensured that areas"
	line "of the region were"

	para "off limits to any"
	line "intervention."

	para "It understood the"
	line "necessity of using"
	cont "domestic #mon,"

	para "and it appreciated"
	line "the bond a human"

	para "could develop with"
	line "its #mon."

	para "Still, it wanted"
	line "nature to run its"

	para "course without any"
	line "needless meddling."
	done

Route80Nobu_2e812a_Text_2e85be:
	ctxt "Libabeel, who was"
	line "the most hostile"
	cont "out of them all,"

	para "controlled the sea"
	line "surrounding Naljo."

	para "Explorers who got"
	line "close to the shore"

	para "of Naljo would be"
	line "unlikely to return"
	cont "home alive again."
	done

Route80Nobu_2e812a_Text_2e8677:
	ctxt "And finally, we"
	line "have Varaneous,"

	para "which you encoun-"
	line "tered earlier."

	para "Back in the days"
	line "when Varaneous was"
	cont "walking the earth,"

	para "outsiders foolish"
	line "enough to come to"

	para "our land ended up"
	line "burned to ash by"

	para "the mighty flames"
	line "of Varaneous."

	para "The ones choosing"
	line "the brave path of"
	cont "fleeing from it,"

	para "would end up with"
	line "charred scars of"

	para "his hateful stare"
	line "upon their backs."

	para "Not even #mon"
	line "were safe from"
	cont "Varaneous' wrath."
	done

Route80Nobu_2e812a_Text_2e8782:
	ctxt "The Messenger had"
	line "the responsibility"

	para "to relay messages"
	line "from the Guardians"
	cont "to the community."

	para "It was the only"
	line "human that these"
	cont "legends trusted,"

	para "but<...> the Guardians"
	line "didn't tell him how"

	para "they were slaying"
	line "anything trying to"
	cont "enter the region."

	para "However<...>"

	para "When he discovered"
	line "this, he stole the"

	para "powerful orbs, and"
	line "hid the orbs all"
	cont "over the region."

	para "Without the orbs,"
	line "the Guardians were"

	para "powerless and fell"
	line "asleep for centur-"
	cont "ies to come."

	para "But once an orb"
	line "gets close enough"

	para "to a guardian, it"
	line "can harness its"
	cont "true power."

	para "Varaneous is now"
	line "awake, and it will"

	para "surely awaken the"
	line "other Guardians."
	done

Route80Nobu_2e812a_Text_2e8929:
	ctxt "The man in Red"
	line "foolishly believed"

	para "that just being a"
	line "descendant would"
	cont "tame the creature."

	para "However!"

	para "You are the last"
	line "known descendant"
	cont "of the Messenger."

	para "Well, besides your"
	line "father, that is."

	para "Your father could"
	line "indeed save us<...>"

	para "However."

	para "Your father doesn't"
	line "realize the power"
	cont "he has over Naljo."

	para "He won't be able"
	line "to handle it."

	para "He's too obsessed"
	line "with his fame and"
	cont "fortune nowadays,"

	para "there's no luring"
	line "him out of that."

	para "As his lone child,"
	line "you are Naljo's one"

	para "hope in taming the"
	line "Guardians for us."
	done

Route80Nobu_2e812a_Text_2e8a8f:
	ctxt "A lighthouse lies"
	line "north, and a good"

	para "friend of mine is"
	line "watching over it."

	para "Perhaps he saw"
	line "where Varaneous"
	cont "went afterwards."

	para "Find a way to"
	line "head up north."
	done

Route80Nobu_2e8034_Text_2e8068:
	ctxt "This #mon"
	line "sounds concerned."

	para "It's tugging your"
	line "foot, expectingly<...>"

	para "I suppose it wants"
	line "to tag along?"
	done

Route80Nobu_2e8034_Text_2e80be:
	ctxt "Aggron joined"
	line "your party!"
	done

Route80Nobu_2e8062_Text_2e80d9:
	ctxt "It can't join you"
	line "if your party is"
	cont "already full."
	done

Route80Nobu_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $3, 3, ROUTE_80
	warp_def $7, $4, 3, ROUTE_80

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_SAGE, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route80NobuNPC1, EVENT_NOBU_NOT_IN_HOUSE
	person_event SPRITE_AGGRON, 2, 5, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_OW_SILVER, 0, 0, Route80NobuNPC2, EVENT_NOBUS_AGGRON_IN_PARTY
