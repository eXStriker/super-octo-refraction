PhanceroRoom_MapScriptHeader ;trigger count
	db 0
 ;callback count
	db 0


PhanceroNPC:
	faceplayer
	opentext
	writetext PhanceroEncounterText
	cry PHANCERO
	waitbutton
	closetext
	setlasttalked 255
	loadwildmon PHANCERO, 70
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	startbattle
	dontrestartmapmusic
	reloadmap
;stream only changes to force capture
	writebyte PHANCERO
	special SpecialMonCheck
	iffalse .dontkillphancero
	setevent EVENT_PHANCERO
	disappear 7
	playsound SFX_WARP_TO
	applymovement 0, PhanceroWarpAfterBattle
	warp HAUNTED_MANSION_BASEMENT, 12, 10
	playsound SFX_WARP_FROM
	applymovement 0, PhanceroWarpEnterBasement
	jump .skipwarp
.dontkillphancero
	warp PHANCERO_ROOM, 35, 2
.skipwarp
	special HealParty
	opentext
	writetext PhanceroBallsText
	waitbutton
	closetext
	giveitem GREAT_BALL, 7
.done
	end

PhanceroEncounter1:
	faceplayer
	opentext
	writetext PhanceroEncounter1Text
	cry PHANCERO
	waitsfx
	waitbutton
	closetext
	;teleport
	;SFX_GIVE_TRADEMON
	special FadeOutPalettes
	playsound SFX_FLASH
	disappear 2
	special FadeInPalettes
	setevent EVENT_PHANCERO_ENCOUNTER_1
	end

PhanceroEncounter2:
	faceplayer
	opentext
	writetext PhanceroEncounter2Text
	cry PHANCERO
	waitsfx
	waitbutton
	closetext
	special FadeOutPalettes
	playsound SFX_FLASH
	disappear 3
	special FadeInPalettes
	setevent EVENT_PHANCERO_ENCOUNTER_2
	end
PhanceroEncounter3:
	faceplayer
	opentext
	writetext PhanceroEncounter3Text
	cry PHANCERO
	waitsfx
	waitbutton
	closetext
	special FadeOutPalettes
	playsound SFX_FLASH
	disappear 4
	special FadeInPalettes
	setevent EVENT_PHANCERO_ENCOUNTER_3
	end
PhanceroEncounter4:
	faceplayer
	opentext
	writetext PhanceroEncounter4Text
	cry PHANCERO
	waitsfx
	waitbutton
	closetext
	special FadeOutPalettes
	playsound SFX_FLASH
	disappear 5
	special FadeInPalettes
	setevent EVENT_PHANCERO_ENCOUNTER_4
	end
PhanceroEncounter5:
	faceplayer
	opentext
	writetext PhanceroEncounter5Text
	cry PHANCERO
	waitsfx
	waitbutton
	closetext
	special FadeOutPalettes
	playsound SFX_FLASH
	disappear 6
	special FadeInPalettes
	setevent EVENT_PHANCERO_ENCOUNTER_5
	end

PhanceroBallsText:
	ctxt "You find your bag"
	line "slightly heavier<...>"
	done

PhanceroEncounter1Text:
	text $7d, "]", $f0, $61, $7e, "GyM", $f5
	done

PhanceroEncounter2Text:
	text $f5, "!", $7c, $ef, "+'M", $74, $f0, $f5
	done

PhanceroEncounter3Text:
	text $7d, "]F", $61, "!!!T3", $f0, $f5
	done

PhanceroEncounter4Text:
	text $7d, $f0, $79, $7c, $7e, "D5", $ed, "'M", $74, $f0, $7d, $f5
	done

PhanceroEncounter5Text:
	text $7c, $7a, $7c, $7c, $7c, $7c, $7c, $f0, "R", $f0, $7d, $f0, $f5, $ee, $ee, $ee, $61, $61
	done

PhanceroEncounterText:
	text $7d, $61, $7e, "Gyaaa!!!!", $7c, "+'M", $74, $f0
	done

GlitchCitySignpost1:
	jumptext GlitchCitySignpost1_Text

GlitchCitySignpost2:
	jumptext GlitchCitySignpost2_Text

GlitchCitySignpost3:
	jumptext GlitchCitySignpost3_Text

GlitchCitySignpostBurned:
	jumptext GlitchCitySignpostBurned_Text

GlitchCitySignpost1_Text:
	text "5r!k№RVbNUX/Vma▲Fu2fVa│¥Zu5y2108│-DOsd3x│#×Z│¥│3]♀pjBTL'M'Mekk¥h│M│V"
	cont "wY#a│#×│H'M_Tk_#<RIGHT>4&'r./<MN>♀'d<LEFT>"
	para "r&CAtDIS70_<CUP>IF|||iFYouH4V3AsPec1ALCODE<DOWN>[<No.>0┌s<CLEFT>│└<YEN>"
	done

GlitchCitySignpost2_Text:
	text "┐▼│¥┐└--┌-♂♀_┐♀¥└▼┐¥+¥│]┌¥¥[¥#-│┐¥┘!┘┘♂×♀│¥¥└-♀"
	cont "<RIGHT><RIGHT><RIGHT><RIGHT><RIGHT><RIGHT>FA<RIGHT><RIGHT><RIGHT><RIGHT><RIGHT>T<RIGHT><RIGHT><RIGHT><RIGHT>E<RIGHT><RIGHT>4&'r./<MN>♀'d<LEFT>"
	para "+ENDsr└¥♀r×│_└♀№♀<MN><MN><MN><MN><MN><MN><MN><MN>HERE┘¥┐│r┘♀×♀¥┐└¥♀№]◀r-×└└┐_│#♀_#♂×CODE<DOWN>[№0┌s◀│└¥"
	done

GlitchCitySignpost3_Text:
	text "M│5U││0;2f┐D×D♀XZ#k№Ts#j♀8└!┌№5U¥│2Lx№MZhZrU!h│bu│!mhrjVj┌│BZV┐¥-k!sZr│jFj┌"
	cont "wY#a│#×│H'M_Tk_#<RIGHT>4&'r./<MN>♀'d<LEFT>"
	para "r&CAt0fI4lc_uF+t-+wdVCIFYOUH444V3A5Pec1ALCODE<DOWN>[№0┌s◀│└¥"
	done

GlitchCitySignpostBurned_Text:
	text "M│5U││0;2f┐<...>YOUh|r▼!¥│__│!mh<...>tRY|┌│haRd┐¥-k!sZr│jFj┌"
	line "wY#a│#×│H'aRD<RIGHT>./<MN>to_READ"
	line "r&CAt0f<...>thEE┘SIGN<DOWN>[№0┌s◀│└¥"
	para "YOUh|rU!h│but│▼│¥it'sss¥┐└¥♀too▼│¥<...>ChArrrrrrrEd|toREad<DOWN>[№0┌s◀│└¥"
	done

PhanceroWarpAfterBattle:
	teleport_from
	step_end

PhanceroWarpEnterBasement:
	teleport_to
	step_end

PhanceroRoom_MapEventHeader:: db 0, 0

.Warps: db 0

.CoordEvents: db 0

.BGEvents: db 6
	signpost 9, 73, SIGNPOST_READ, GlitchCitySignpost1
	signpost 9, 61, SIGNPOST_READ, GlitchCitySignpost2
	signpost 9, 45, SIGNPOST_READ, GlitchCitySignpost2
	signpost 9, 49, SIGNPOST_READ, GlitchCitySignpost1
	signpost 13, 41, SIGNPOST_READ, GlitchCitySignpost3
	signpost 3, 1, SIGNPOST_READ, GlitchCitySignpostBurned

.ObjectEvents: db 6
	person_event SPRITE_PHANCERO, 4, 79, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, PhanceroEncounter1, EVENT_PHANCERO_ENCOUNTER_1
	person_event SPRITE_PHANCERO, 11, 55, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, PhanceroEncounter2, EVENT_PHANCERO_ENCOUNTER_2
	person_event SPRITE_PHANCERO, 5, 43, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, PhanceroEncounter3, EVENT_PHANCERO_ENCOUNTER_3
	person_event SPRITE_PHANCERO, 5, 34, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, PhanceroEncounter4, EVENT_PHANCERO_ENCOUNTER_4
	person_event SPRITE_PHANCERO, 7, 16, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, PhanceroEncounter5, EVENT_PHANCERO_ENCOUNTER_5
	person_event SPRITE_PHANCERO, 1, 6, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_PURPLE, 0, 0, PhanceroNPC, -1

