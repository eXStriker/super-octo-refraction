const_value set 2
	const POKECENTER2F_TRADE_RECEPTIONIST
	const POKECENTER2F_BATTLE_RECEPTIONIST
	const POKECENTER2F_TIME_CAPSULE_RECEPTIONIST
	const POKECENTER2F_OFFICER

PokecenterBackroom_MapScriptHeader:
.MapTriggers:
	db 4

	; triggers
	maptrigger .Trigger0
	maptrigger .Trigger1
	maptrigger .Trigger2
	maptrigger .Trigger3

.MapCallbacks:
	db 0

.Trigger0:
	end

.Trigger1:
	priorityjump Script_LeftCableTradeCenter
	end

.Trigger2:
	priorityjump Script_LeftCableColosseum
	end

.Trigger3:
	priorityjump Script_LeftTimeCapsule
	end

Script_TradeCenterClosed:
	jumptextfaceplayer Text_TradeRoomClosed

Script_BattleRoomClosed:
	jumptextfaceplayer Text_BattleRoomClosed

LinkReceptionistScript_Trade:
	checkevent EVENT_LINK_OPEN
	iftrue Script_TradeCenterClosed
	checkevent EVENT_NOBUS_AGGRON_IN_PARTY
	iftrue Script_BattleRoomClosed
	opentext
	writetext Text_TradeReceptionistIntro
	yesorno
	iffalse .Cancel
	special Special_SetBitsForLinkTradeRequest
	writetext Text_PleaseWait
	special Special_WaitForLinkedFriend
	iffalse .FriendNotReady
	writetext Text_MustSaveGame
	yesorno
	iffalse .DidNotSave
	special Special_TryQuickSave
	iffalse .DidNotSave
	writetext Text_PleaseWait
	special Special_CheckLinkTimeout
	iffalse .LinkTimedOut
	copybytetovar wOtherPlayerLinkMode
	iffalse .LinkedToFirstGen
	special Special_CheckBothSelectedSameRoom
	iffalse .IncompatibleRooms
	writetext Text_PleaseComeIn
	waitbutton
	closetext
	scall PokeCenter2F_CheckGender
	warpcheck
	end

.FriendNotReady:
	special WaitForOtherPlayerToExit
	jumptext Text_FriendNotReady

.LinkedToFirstGen:
	special Special_FailedLinkToPast
	writetext Text_CantLinkToThePast
	special Special_CloseLink
	closetext
	end

.IncompatibleRooms:
	writetext Text_IncompatibleRooms
	special Special_CloseLink
	closetext
	end

.LinkTimedOut:
	writetext Text_LinkTimedOut
	jump .AbortLink

.DidNotSave:
	writetext Text_PleaseComeAgain
.AbortLink:
	special WaitForOtherPlayerToExit
.Cancel:
	closetext
	end

LinkReceptionistScript_Battle:
	checkevent EVENT_LINK_OPEN
	iffalse Script_BattleRoomClosed
	checkevent EVENT_NOBUS_AGGRON_IN_PARTY
	iftrue Script_BattleRoomClosed
	opentext
	writetext Text_BattleReceptionistIntro
	yesorno
	iffalse .Cancel
	special Special_SetBitsForBattleRequest
	writetext Text_PleaseWait
	special Special_WaitForLinkedFriend
	iffalse .FriendNotReady
	writetext Text_MustSaveGame
	yesorno
	iffalse .DidNotSave
	special Special_TryQuickSave
	iffalse .DidNotSave
	writetext Text_PleaseWait
	special Special_CheckLinkTimeout
	iffalse .LinkTimedOut
	copybytetovar wOtherPlayerLinkMode
	iffalse .LinkedToFirstGen
	special Special_CheckBothSelectedSameRoom
	iffalse .IncompatibleRooms
	writetext Text_PleaseComeIn
	waitbutton
	closetext
	scall PokeCenter2F_CheckGender
	warpcheck
	end

.FriendNotReady:
	special WaitForOtherPlayerToExit
	jumptext Text_FriendNotReady

.LinkedToFirstGen:
	special Special_FailedLinkToPast
	writetext Text_CantLinkToThePast
	special Special_CloseLink
	closetext
	end

.IncompatibleRooms:
	writetext Text_IncompatibleRooms
	special Special_CloseLink
	closetext
	end

.LinkTimedOut:
	writetext Text_LinkTimedOut
	jump .AbortLink

.DidNotSave:
	writetext Text_PleaseComeAgain
.AbortLink:
	special WaitForOtherPlayerToExit
.Cancel:
	closetext
	end

Script_TimeCapsuleClosed:
	jumptextfaceplayer Text_TimeCapsuleClosed

LinkReceptionistScript_TimeCapsule:
	checkflag ENGINE_TIME_CAPSULE
	iffalse Script_TimeCapsuleClosed
	special Special_SetBitsForTimeCapsuleRequest
	faceplayer
	opentext
	writetext Text_TimeCapsuleReceptionistIntro
	yesorno
	iffalse .Cancel
	special Special_CheckTimeCapsuleCompatibility
	if_equal $1, .MonTooNew
	if_equal $2, .MonMoveTooNew
	writetext Text_PleaseWait
	special Special_WaitForLinkedFriend
	iffalse .FriendNotReady
	writetext Text_MustSaveGame
	yesorno
	iffalse .DidNotSave
	special Special_TryQuickSave
	iffalse .DidNotSave
	writetext Text_PleaseWait
	special Special_CheckLinkTimeout
	iffalse .LinkTimedOut
	copybytetovar wOtherPlayerLinkMode
	iffalse .OK
	special Special_CheckBothSelectedSameRoom
	writetext Text_IncompatibleRooms
	special Special_CloseLink
	closetext
	end

.OK:
	special Special_EnterTimeCapsule
	writetext Text_PleaseComeIn
	waitbutton
	closetext
	scall TimeCapsuleScript_CheckPlayerGender
	warpcheck
	end

.FriendNotReady:
	special WaitForOtherPlayerToExit
	jumptext Text_FriendNotReady

.LinkTimedOut:
	writetext Text_LinkTimedOut
	jump .Cancel

.DidNotSave:
	writetext Text_PleaseComeAgain
.Cancel:
	special WaitForOtherPlayerToExit
	closetext
	end

.MonTooNew:
	jumptext Text_RejectNewMon

.MonMoveTooNew:
	jumptext Text_RejectMonWithNewMove

Script_LeftCableTradeCenter:
	special WaitForOtherPlayerToExit
	scall Script_WalkOutOfLinkTradeRoom
	dotrigger $0
	domaptrigger TRADE_CENTER, $0
	end

Script_LeftCableColosseum:
	special WaitForOtherPlayerToExit
	scall Script_WalkOutOfLinkBattleRoom
	dotrigger $0
	domaptrigger BATTLE_CENTER, $0
	end

PokeCenter2F_CheckGender:
	applymovement2 PokeCenter2FMovementData_ReceptionistWalksUpAndLeft_LookRight
	applymovement PLAYER, PokeCenter2FMovementData_PlayerTakesThreeStepsUp
	end

Script_WalkOutOfLinkTradeRoom:
	applymovement POKECENTER2F_TRADE_RECEPTIONIST, PokeCenter2FMovementData_ReceptionistStepsRightLooksDown_3
	applymovement PLAYER, PokeCenter2FMovementData_PlayerTakesThreeStepsDown
	applymovement POKECENTER2F_TRADE_RECEPTIONIST, PokeCenter2FMovementData_ReceptionistStepsRightAndDown
	end

Script_WalkOutOfLinkBattleRoom:
	applymovement POKECENTER2F_BATTLE_RECEPTIONIST, PokeCenter2FMovementData_ReceptionistStepsRightLooksDown_3
	applymovement PLAYER, PokeCenter2FMovementData_PlayerTakesThreeStepsDown
	applymovement POKECENTER2F_BATTLE_RECEPTIONIST, PokeCenter2FMovementData_ReceptionistStepsRightAndDown
	end

TimeCapsuleScript_CheckPlayerGender:
	checkcode VAR_FACING
	if_equal LEFT, .MaleFacingLeft
	if_equal RIGHT, .MaleFacingRight
	applymovement2 PokeCenter2FMovementData_ReceptionistStepsLeftLooksDown
	applymovement PLAYER, PokeCenter2FMovementData_PlayerTakesTwoStepsUp_2
	end

.MaleFacingLeft:
	applymovement2 PokeCenter2FMovementData_ReceptionistStepsLeftLooksDown
	applymovement PLAYER, PokeCenter2FMovementData_PlayerWalksLeftAndUp
	end

.MaleFacingRight:
	applymovement2 PokeCenter2FMovementData_ReceptionistStepsRightLooksDown
	applymovement PLAYER, PokeCenter2FMovementData_PlayerWalksRightAndUp
	end

Script_LeftTimeCapsule:
	special WaitForOtherPlayerToExit
	checkflag ENGINE_KRIS_IN_CABLE_CLUB
	applymovement POKECENTER2F_TIME_CAPSULE_RECEPTIONIST, PokeCenter2FMovementData_ReceptionistStepsLeftLooksRight
	applymovement PLAYER, PokeCenter2FMovementData_PlayerTakesTwoStepsDown
	applymovement POKECENTER2F_TIME_CAPSULE_RECEPTIONIST, PokeCenter2FMovementData_ReceptionistStepsRightLooksDown_2
	dotrigger $0
	domaptrigger TIME_CAPSULE, $0
	end

MapPokeCenter2FSignpost0Script:
	refreshscreen $0
	special Special_DisplayLinkRecord
	closetext
	end

PokeCenter2FMovementData_ReceptionistWalksUpAndLeft_LookRight:
	slow_step_up
	slow_step_left
	turn_head_right
	step_end

PokeCenter2FMovementData_ReceptionistStepsLeftLooksDown:
	slow_step_left
	turn_head_down
	step_end

PokeCenter2FMovementData_ReceptionistStepsRightLooksDown:
	slow_step_right
	turn_head_down
	step_end

PokeCenter2FMovementData_ReceptionistWalksUpAndLeft_LookRight_2:
	slow_step_up
	slow_step_left
	turn_head_right
	step_end

PokeCenter2FMovementData_ReceptionistLooksRight:
	turn_head_right
	step_end

PokeCenter2FMovementData_PlayerTakesThreeStepsUp:
	step_up
	step_up
	step_up
	step_end

PokeCenter2FMovementData_PlayerTakesTwoStepsUp:
	step_up
	step_up
	step_end

PokeCenter2FMovementData_PlayerTakesOneStepUp:
	step_up
	step_end

PokeCenter2FMovementData_PlayerTakesTwoStepsUp_2:
	step_up
	step_up
	step_end

PokeCenter2FMovementData_PlayerWalksLeftAndUp:
	step_left
	step_up
	step_end

PokeCenter2FMovementData_PlayerWalksRightAndUp:
	step_right
	step_up
	step_end

PokeCenter2FMovementData_PlayerTakesThreeStepsDown:
	step_down
	step_down
	step_down
	step_end

PokeCenter2FMovementData_PlayerTakesTwoStepsDown:
	step_down
	step_down
	step_end

PokeCenter2FMovementData_PlayerTakesOneStepDown:
	step_down
	step_end

PokeCenter2FMovementData_ReceptionistStepsRightAndDown:
	slow_step_right
	slow_step_down
	step_end

PokeCenter2FMovementData_ReceptionistStepsRightLooksDown_2:
	slow_step_right
	turn_head_down
	step_end

PokeCenter2FMovementData_ReceptionistStepsRightLooksDown_3:
	slow_step_up
	slow_step_left
	turn_head_right
	step_end

PokeCenter2FMovementData_ReceptionistStepsLeftLooksRight:
	slow_step_left
	turn_head_right
	step_end

PokeCenter2FMovementData_PlayerSpinsClockwiseEndsFacingRight:
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	step_end

PokeCenter2FMovementData_PlayerSpinsClockwiseEndsFacingLeft:
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_left
	step_end

PokeCenter2FMovementData_PlayerSpinsClockwiseEndsFacingDown:
	turn_head_down
	turn_head_left
	turn_head_up
	turn_head_right
	turn_head_down
	step_end

PokeCenter2FMovementData_PlayerTakesOneStepDown_2:
	step_down
	step_end

PokeCenter2FMovementData_PlayerTakesTwoStepsDown_2:
	step_down
	step_down
	step_end

PokeCenter2FMovementData_PlayerTakesOneStepUp_2:
	step_up
	step_end

PokeCenter2FMovementData_PlayerTakesOneStepRight:
	step_right
	step_end

PokeCenter2FMovementData_PlayerTakesOneStepLeft:
	step_left
	step_end

PokeCenter2FMovementData_ReceptionistStepsLeftLooksRight_2:
	slow_step_left
	turn_head_right
	step_end

PokeCenter2FMovementData_ReceptionistStepsRightLooksLeft_2:
	slow_step_right
	turn_head_left
	step_end

Text_BattleReceptionistIntro:
	ctxt "Welcome to Cable"
	line "Club Colosseum."

	para "You may battle a"
	line "friend here."

	para "Would you like to"
	line "battle?"
	done

Text_TradeReceptionistIntro:
	ctxt "Welcome to Cable"
	line "Trade Center."

	para "You may trade your"
	line "#mon here with"
	cont "a friend."

	para "Would you like to"
	line "trade?"
	done

Text_TimeCapsuleReceptionistIntro:
	ctxt "Welcome to Cable"
	line "Club Time Capsule."

	para "You can travel to"
	line "the past and trade"
	cont "your #mon."

	para "Would you like to"
	line "trade across time?"
	done

Text_FriendNotReady:
	ctxt "Your friend is not"
	line "ready."
	prompt

Text_MustSaveGame:
	ctxt "Before opening the"
	line "link, you must"
	cont "save your game."
	done

Text_PleaseWait:
	ctxt "Please wait."
	done

Text_LinkTimedOut:
	ctxt "The link has been"
	line "closed because of"
	cont "inactivity."

	para "Please contact"
	line "your friend and"
	cont "come again."
	prompt

Text_PleaseComeAgain:
	ctxt "Please come again."
	prompt

Text_PleaseComeIn:
	ctxt "Please come in."
	prompt

Text_TemporaryStagingInLinkRoom:
	ctxt "We'll put you in"
	line "the link room for"
	cont "the time being."
	done

Text_CantLinkToThePast:
	ctxt "You can't link to"
	line "the past here."
	prompt

Text_IncompatibleRooms:
	ctxt "Incompatible rooms"
	line "were chosen."
	prompt

Text_PleaseEnter:
	ctxt "Please enter."
	prompt

Text_RejectNewMon:
	ctxt "Sorry - <STRBF1>"
	line "can't be taken."
	done

Text_RejectMonWithNewMove:
	ctxt "You can't take the"
	line "<STRBF1> with a"
	cont "<STRBF2>."
	done

Text_TimeCapsuleClosed:
	ctxt "I'm sorry - the"
	line "Time Capsule is"
	cont "being adjusted."
	done

Text_TradeRoomClosed:
	ctxt "I'm sorry - the"
	line "Trade Machine is"
	cont "being adjusted."
	done

Text_BattleRoomClosed:
	ctxt "I'm sorry - the"
	line "Battle Machine is"
	cont "being adjusted."
	done

Text_OhPleaseWait:
	ctxt "Oh, please wait."
	done

Text_ChangeTheLook:
	ctxt "We need to change"
	line "the look here…"
	done

Text_LikeTheLook:
	ctxt "How does this"
	line "style look to you?"
	done

PokecenterBackroom_MapEventHeader:: db 0, 0

.Warps: db 5
	warp_def 7, 7, -1, POKECENTER_BACKROOM
	warp_def 0, 3, 1, TRADE_CENTER
	warp_def 0, 11, 1, BATTLE_CENTER
	warp_def 2, 7, 1, TIME_CAPSULE
	warp_def 7, 8, -1, POKECENTER_BACKROOM

.CoordEvents: db 0

.BGEvents: db 1
	signpost 3, 7, SIGNPOST_READ, MapPokeCenter2FSignpost0Script

.ObjectEvents: db 3
	person_event SPRITE_LINK_RECEPTIONIST, 2, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, LinkReceptionistScript_Trade, -1
	person_event SPRITE_LINK_RECEPTIONIST, 2, 11, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, LinkReceptionistScript_Battle, -1
	person_event SPRITE_LINK_RECEPTIONIST, 3, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, LinkReceptionistScript_TimeCapsule, -1

