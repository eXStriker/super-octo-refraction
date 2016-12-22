MilosGreenOrb_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MilosGreenOrbNPC1:
	faceplayer
	checkevent EVENT_MILOS_RAYQUAZA
	iftrue .alreadyFaught
	opentext
	checkitem GREEN_ORB
	iftrue MilosGreenOrb_2f6d5c
	jumptext MilosGreenOrbNPC1_Text_2f6da9

.alreadyFaught
	jumptext MilosGreenOrbNPC1Faught

MilosGreenOrb_2f6d5c:
	takeitem GREEN_ORB
	writetext MilosGreenOrb_2f6d5c_Text_2f6e91
	waitbutton
	special Special_BattleTowerFade
	playsound SFX_ENTER_DOOR
	waitsfx
	warpfacing UP, MILOS_RAYQUAZA, 4, 7
	opentext
	writetext MilosGreenOrb_2f6d5c_Text_2f6ead
	waitbutton
	setevent EVENT_MILOS_RAYQUAZA
	cry RAYQUAZA
	waitsfx
	writetext MilosGreenOrb_2f6d5c_Text_2f6ed6
	waitbutton
	cry RAYQUAZA
	waitsfx
	applymovement 3, RayquazaMovement
	writecode VAR_BATTLETYPE, BATTLETYPE_NORMAL
	loadwildmon RAYQUAZA, 50
	startbattle
	reloadmapafterbattle
	special Special_BattleTowerFade
	playsound SFX_ENTER_DOOR
	waitsfx
	warpfacing UP, MILOS_GREEN_ORB, 4, 3
	end

RayquazaMovement:
	step_down
	step_down
	step_down
	step_down
	step_end

MilosGreenOrbNPC1_Text_2f6da9:
	ctxt "There's a #mon"
	line "that ceased the"
	para "war between Groud-"
	line "on and Kyogre."

	para "This sky god now"
	line "resides on this"
	cont "tower."

	para "It is very"
	line "aggressive and"
	para "the only way for"
	line "it to agree to a"
	para "battle is the"
	line "one who holds"
	cont "the Green Orb."
	done

MilosGreenOrb_2f6d5c_Text_2f6e91:
	ctxt "Good, please come"
	line "with me."
	done

MilosGreenOrb_2f6d5c_Text_2f6ead:
	ctxt "Master, a child"
	line "has requested a"
	cont "battle."
	done

MilosGreenOrb_2f6d5c_Text_2f6ed6:
	ctxt "The child has"
	line "also met the"
	cont "requirements."
	done

MilosGreenOrbNPC1Faught:
	ctxt "The challenge has"
	line "ended."
	done

MilosGreenOrb_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $f, $4, 1, MILOS_TOWERCLIMB
	warp_def $f, $5, 1, MILOS_TOWERCLIMB

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_SAGE, 2, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MilosGreenOrbNPC1, EVENT_MILOS_GREEN_ORB_NPC_1
