UnknownText_0x1c0222::
	ctxt "It might look the"
	line "same as before,"

	para "but this new name"
	line "is much better!"

	para "Well done!"
	done

UnknownText_0x1c0272::
	ctxt "All right. This"
	line "#mon is now"
	cont "named <STRBF1>."
	prompt

_IsThisOkayText::
	ctxt "Is this the look"
	line "you want?"
	prompt

_IntroTextDescribeAppearance::
	ctxt ""
	prompt

_IntroTextFinallyPleaseTellMeYourName::
	ctxt "Finally, could you"
	line "please tell me"
	cont "your name?"
	prompt

_IntroTextEnding::
	ctxt "<PLAYER>, are you"
	line "ready?"

	para "Your very own"
	line "#mon story is"
	cont "about to unfold."

	para "You'll face fun"
	line "times and tough"
	cont "challenges."

	para "A world of dreams"
	line "and adventures"

	para "with #mon"
	line "awaits! Let's go!"

	para "I'm sure I'll see"
	line "you later!"
	done

UnknownText_0x1c40e6::
	ctxt "The clock's time"
	line "may be wrong."

	para "Please reset the"
	line "time."
	prompt

UnknownText_0x1c411c::
	ctxt "Set with the"
	line "Control Pad."

	para "Confirm: A Button"
	line "Cancel:  B Button"
	done

_AreYouSureYouWantToCancelText::
	ctxt "Are you sure you"
	line "want to cancel?"
	done

UnknownText_0x1bc7c3::
	ctxt "Take good care of"
	line "@"
	text_from_ram wOTTrademonSpeciesName
	ctxt "."
	done

UnknownText_0x1bc7dd::
	text_from_ram wPlayerTrademonSenderName
	ctxt "'s"
	line "@"
	text_from_ram wPlayerTrademonSpeciesName
	ctxt " trade…"
	done

UnknownText_0x1bc7f0::
	ctxt "Take good care of"
	line "@"
	text_from_ram wOTTrademonSpeciesName
	ctxt "."
	done

UnknownText_0x1bc80a::
	text_from_ram wOTTrademonSpeciesName
	ctxt " came"
	line "back!"
	done

Text_EnemyWithdrew::
	ctxt "<ENEMY>"
	line "withdrew"
	cont "<EMON>!"
	prompt

Text_EnemyUsedOn::
	ctxt "<ENEMY>"
	line "used <MINB>"
	cont "on <EMON>!"
	prompt

Text_ThatCantBeUsedRightNow::
	ctxt "That can't be used"
	line "right now."
	prompt

Text_ThatItemCantBePutInThePack::
	ctxt "That item can't be"
	line "put in the pack."
	done

Text_TheItemWasPutInThePack::
	ctxt "The <STRBF1>"
	line "was put in the"
	cont "pack."
	done
