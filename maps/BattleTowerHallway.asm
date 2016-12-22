BattleTowerHallway_MapScriptHeader:
	; triggers
	db 2
	maptrigger .Trigger0
	maptrigger .Trigger1

	; callbacks
	db 0

.Trigger0:
	priorityjump .Script
.Trigger1:
	end

.Script:
	applymovement $0, BattleTowerMovement_PlayerStepsDown
	follow $2, $0
	applymovement $2, BattleTowerMovement_ReceptionistGuidesPlayerToBattleRoom
	stopfollow
	callasm BattleTower_CheckCurrentStreak
	sif false, then
		opentext
		writetext HereIsYourBattleRoomText
		waitbutton
		closetext
	sendif
	applymovement $0, BattleTowerMovement_PlayerStepsUp
	dotrigger $1
	warpcheck
	end

BattleTowerMovement_ReceptionistGuidesPlayerToBattleRoom:
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	step_right
	turn_head_left
	step_end

HereIsYourBattleRoomText:
	ctxt "Here is your"
	line "Battle Room."

	para "Best of luck!"
	done

BattleTowerHallway_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 0, 6, 3, BATTLE_TOWER_ELEVATOR
	warp_def 0, 18, 1, BATTLE_TOWER_BATTLE_ROOM

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 1
	person_event SPRITE_RECEPTIONIST, 1, 7, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, -1
