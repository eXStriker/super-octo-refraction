Route86_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 2
	dbw 5, BattleArcade_SetFlyFlag
	dbw MAPCALLBACK_TILES, SetRoute86Block
	
BattleArcade_SetFlyFlag:
	setflag ENGINE_FLYPOINT_BATTLE_ARCADE
	return

Route86HiddenItem_1:
	dw EVENT_ROUTE_86_HIDDENITEM_FULL_RESTORE
	db FULL_RESTORE

Route86Signpost1:
	jumpstd pokecentersign

Route86Signpost2:
	jumptext Route86Signpost2_Text_127147
	
Route86LockedDoor:
	checkevent EVENT_FARAWAY_UNLOCKED
	sif true
		end
	checkitem PRISM_KEY
	sif false
		jumptext PrismDoorLockedText
	opentext
	writetext OpenedPrismDoor
	changeblock 8, 40, $77
	playsound SFX_ENTER_DOOR
	waitbutton
	closetext
	reloadmappart
	setevent EVENT_FARAWAY_UNLOCKED
	end
		
SetRoute86Block:
	checkevent EVENT_FARAWAY_UNLOCKED
	sif true
		return
	changeblock 8, 40, $f4
	return

Route86Signpost2_Text_127147:
	ctxt "Battle Arcade"
	done
	
PrismDoorLockedText:
	ctxt "The door is"
	line "locked."
	done
	
OpenedPrismDoor:
	ctxt "Opened the door"
	line "with the Prism"
	cont "Key!"
	done

Route86_MapEventHeader:: db 0, 0

.Warps: db 5
	warp_def 9, 10, 1, BATTLE_ARCADE_LOBBY
	warp_def 3, 2, 1, ROUTE_86_POKECENTER
	warp_def 21, 9, 1, ROUTE_86_DOCK_EXIT
	warp_def 21, 10, 2, ROUTE_86_DOCK_EXIT
	warp_def 41, 8, 1, ROUTE_86_UNDERGROUND_PATH

.CoordEvents: db 0

.BGEvents: db 4
	signpost 3, 1, SIGNPOST_READ, Route86Signpost1
	signpost 11, 13, SIGNPOST_READ, Route86Signpost2
	signpost 11, 16, SIGNPOST_ITEM, Route86HiddenItem_1
	signpost 41, 8, SIGNPOST_READ, Route86LockedDoor

.ObjectEvents: db 0

