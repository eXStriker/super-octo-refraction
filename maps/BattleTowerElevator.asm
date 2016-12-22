BattleTowerElevator_MapScriptHeader:
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
	follow $2, $0
	applymovement $2, BattleTowerMovement_ReceptionistEntersElevator
	stopfollow
	spriteface $0, DOWN
	playsound SFX_ELEVATOR
	earthquake 60
	waitsfx
	follow $2, $0
	applymovement $2, BattleTowerMovement_ReceptionistExitsElevator
	stopfollow
	disappear $2
	warpsound
	applymovement $0, BattleTowerMovement_PlayerStepsDown
	dotrigger $1
	warpsound
	warp BATTLE_TOWER_HALLWAY, 6, 0
	end

BattleTowerMovement_ReceptionistEntersElevator:
	step_right
	turn_head_down
	step_end

BattleTowerMovement_ReceptionistExitsElevator:
BattleTowerMovement_PlayerStepsDown:
	step_down
	step_end

BattleTowerElevator_MapEventHeader:: db 0, 0

.Warps: db 2
	warp_def 3, 1, 3, BATTLE_TOWER_ENTRANCE
	warp_def 3, 2, 1, BATTLE_TOWER_HALLWAY

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 1
	person_event SPRITE_RECEPTIONIST, 2, 1, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, -1
