ClathriteKyogre_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ClathriteKyogreSignpost1:
	opentext
	checkitem BLUE_ORB
	if_equal 0, ClathriteKyogre_1660f7
	writetext ClathriteKyogreSignpost1_Text_16625e
	yesorno
	if_equal 0, ClathriteKyogre_1660f5
	musicfadeout MUSIC_NONE, 47
	closetext
	playsound SFX_EMBER
	earthquake 31
	playsound SFX_EMBER
	earthquake 31
	special ClearBGPalettes
	playsound SFX_EMBER
	earthquake 31
	special Special_ReloadSpritesNoPalettes
	pause 48
	closetext
	takeitem BLUE_ORB, 1
	scall ClathriteKyogre_166210
	scall ClathriteKyogre_166210
	scall ClathriteKyogre_166210
	special Special_FadeInQuickly
	cry KYOGRE
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon KYOGRE, 50
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	disappear 2
	playmapmusic
	closetext
	end

ClathriteKyogre_1660f7:
	writetext ClathriteKyogre_1660f7_Text_166230
	endtext

ClathriteKyogre_1660f5:
	closetext
	end

ClathriteKyogre_166210:
	applymovement 2, ClathriteKyogre_166210_Movement1
	playsound SFX_THUNDER
	special ClearBGPalettes
	pause 8
	special Special_ReloadSpritesNoPalettes
	pause 32
	end

ClathriteKyogre_166210_Movement1:
	slow_step_down
	step_end

ClathriteKyogreSignpost1_Text_16625e:
	ctxt "It looks like your"
	line "Blue Orb will fit"
	cont "here."

	para "Will you place it?"
	done

ClathriteKyogre_1660f7_Text_166230:
	ctxt "It looks like"
	line "a sphere can be"
	cont "placed here<...>"
	done

ClathriteKyogre_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $25, $2, 9, CLATHRITE_B2F

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 8, 10, SIGNPOST_READ, ClathriteKyogreSignpost1

	;people-events
	db 1
	person_event SPRITE_KYOGRE, 4, 10, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, -1
