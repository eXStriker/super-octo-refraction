PowerPlant_MapScriptHeader;trigger count
	db 2
	maptrigger .Trigger0
	maptrigger .Trigger1
 ;callback count
	db 0
	
.Trigger0
	priorityjump PowerPlantWalkToLance
	end
	
.Trigger1
	end
	
PowerPlantWalkToLance:
	applymovement 0, PowerPlantWalkLance
	spriteface 11, LEFT
	dotrigger 1
PowerPlantLanceNPC:
	jumptextfaceplayer PowerPlantLanceTextTemp
	
PowerPlantNPC4:
	jumptextfaceplayer PowerPlantNPC4Text
	
PowerPlantWalkLance:
	step_up
	step_up
	step_up
	step_up
	step_up
	step_up
	step_up
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_end
	
	
PowerPlantHiddenItem_1:
	dw EVENT_POWER_PLANT_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

PowerPlantNPC1:
	jumptextfaceplayer PowerPlantNPC1_Text_201ea0

PowerPlantNPC2:
	jumptextfaceplayer PowerPlantNPC2_Text_201f00

PowerPlantNPC3:
	jumptextfaceplayer PowerPlantNPC3_Text_201f5f

PowerPlant_Item_1:
	db FAST_BALL, 2

PowerPlant_Item_2:
	db THUNDER_RING, 1

PowerPlant_Item_3:
	db X_SPECIAL, 2

PowerPlant_Item_4:
	db ELECTRIZER, 1
	
PowerPlantMeetLance:
	ctxt ""
	done
	
PowerPlantNPC4Text:
	ctxt "I will help your"
	line "father in a later"
	cont "version of Prism!"
	done
	
PowerPlantLanceTextTemp:
	ctxt "My child!"

	para "I will have a"
	line "mission for you"
	
	para "in a later version"
	line "of Prism."
	
	para "Keep an eye on the"
	line "Facebook Page and"
	
	para "Rijon.com for"
	line "newer versions!"
	done

PowerPlantNPC1_Text_201ea0:
	ctxt "We're almost done"
	line "renovating this"
	cont "place."

	para "We need a way to"
	line "get rid of all"
	cont "the #mon later."
	done

PowerPlantNPC2_Text_201f00:
	ctxt "Glad this equip-"
	line "ment is still"
	cont "functional."

	para "Practically runs"
	line "itself."
	done

PowerPlantNPC3_Text_201f5f:
	ctxt "There's an Ice"
	line "Gym that uses"

	para "way too many"
	line "air conditioners."

	para "That's one of the"
	line "reasons why this"

	para "place is being"
	line "maintained again."
	done

PowerPlant_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $27, $6, 1, ROUTE_60
	warp_def $27, $7, 1, ROUTE_60

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 16, 10, SIGNPOST_ITEM, PowerPlantHiddenItem_1

	;people-events
	db 10
	person_event SPRITE_FISHING_GURU, 12, 19, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PowerPlantNPC1, -1
	person_event SPRITE_POKEFAN_M, 17, 2, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PowerPlantNPC2, -1
	person_event SPRITE_SUPER_NERD, 37, 47, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PowerPlantNPC3, -1
	person_event SPRITE_POKE_BALL, 35, 1, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, PowerPlant_Item_1, EVENT_POWER_PLANT_ITEM_1
	person_event SPRITE_POKE_BALL, 35, 26, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, PowerPlant_Item_2, EVENT_POWER_PLANT_ITEM_2
	person_event SPRITE_POKE_BALL, 5, 38, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, PowerPlant_Item_3, EVENT_POWER_PLANT_ITEM_3
	person_event SPRITE_POKE_BALL, 4, 5, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, PowerPlant_Item_4, EVENT_POWER_PLANT_ITEM_4
	person_event SPRITE_POKE_BALL, 13, 25, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 3, TM_CRYSTAL_BOLT, 0, EVENT_POWER_PLANT_NPC_4
	person_event SPRITE_SUPER_NERD, 35, 15, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PowerPlantNPC4, -1
	person_event SPRITE_LANCE, 32, 15, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PowerPlantLanceNPC, -1
	