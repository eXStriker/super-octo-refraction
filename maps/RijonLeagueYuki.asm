RijonLeagueYuki_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

RijonLeagueYukiNPC1:
	faceplayer
	opentext
	writetext RijonLeagueYuki_2f4535_Text_2f4556
	waitbutton
	winlosstext RijonLeagueYuki_2f4535Text_2f45bc, 0
	setlasttalked 255
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	checkcode VAR_BADGES
	if_greater_than 19, .rematch
	loadtrainer YUKI, 1
.battle
	startbattle
	reloadmapafterbattle
	playmapmusic
	closetext
	opentext
	writetext RijonLeagueYuki_2f5603_Text_2f45d3
	waitbutton
	closetext
	applymovement 2, RijonLeagueYuki_2f5603_Movement1
	disappear 2
	end

.rematch
	loadtrainer YUKI, 2
	jump .battle


RijonLeagueYuki_2f5603_Movement1:
	teleport_from
	remove_person
	step_end

RijonLeagueYuki_2f4535_Text_2f4556:
	ctxt "Welcome Trainer!"

	para "What you've"
	line "experienced on"

	para "your journey is"
	line "unique."

	para "Anyone could"
	line "conquer the gyms"

	para "and traverse"
	line "Seneca Caverns,"

	para "but no one would"
	line "have done it as"
	cont "you have."

	para "You're as unique"
	line "as a crystalized"
	;******************
	para "snowflake flutter-"
	line "ing and tumbling"

	para "through the cold"
	line "mountain air on a"
	cont "winter's morning."

	para "I am Yuki, the"
	line "Master Ice Trainer"

	para "of Naljo and your"
	line "first opponent in"
	cont "the Rijon League."

	para "Put your best foot"
	line "forward!"

	done

RijonLeagueYuki_2f4535Text_2f45bc:
	ctxt "What a way to"
	line "break the ice!"
	done

RijonLeagueYuki_2f5603_Text_2f45d3:
	ctxt "By outlasting and"
	line "overcoming my icy"

	para "onslaught, you've"
	line "proven that you"

	para "and your #mon"
	line "can withstand"
	cont "anything!"

	para "Go onto the next"
	line "room, your next"
	cont "challenge awaits."
	done

RijonLeagueYuki_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $11, $2, 1, CAPER_CITY
	warp_def $5, $d, 1, RIJON_LEAGUE_SORA

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_YUKI, 8, 12, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, RijonLeagueYukiNPC1, -1
