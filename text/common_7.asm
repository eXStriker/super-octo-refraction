UnknownText_0x1c415b::
	ctxt "Is this OK?"
	done

UnknownText_0x1c4168::
	ctxt "The clock has been"
	line "reset."
	done

UnknownText_0x1c4183::
	ctxt "Too much time has"
	line "elapsed. Please"
	cont "try again."
	prompt

UnknownText_0x1c41b1::
	ctxt "If you trade that"
	line "#mon, you won't"
	cont "be able to battle."
	prompt

UnknownText_0x1c41e6::
	ctxt "Your friend's"
	line "<STRBF1> appears"
	cont "to be abnormal!"
	prompt

UnknownText_0x1c4212::
	ctxt "Trade @"
	text_from_ram wd004
	ctxt ""
	line "for <STRBF1>?"
	done

UnknownText_0x1c454b::
	ctxt "Would you like to"
	line "save the game?"
	done

UnknownText_0x1c4590::
	ctxt "<PLAYER> saved"
	line "the game."
	done

UnknownText_0x1c45a3::
	ctxt "There is already a"
	line "save file. Is it"
	cont "OK to overwrite?"
	done

UnknownText_0x1c45d9::
	ctxt "There is another"
	line "save file. Is it"
	cont "OK to overwrite?"
	done

UnknownText_0x1c460d::
	ctxt "The save file is"
	line "corrupted!"
	prompt

UnknownText_0x1c462a::
	ctxt "When you change a"
	line "#mon Box, data"
	cont "will be saved. OK?"
	done

UnknownText_0x1c465f::
	ctxt "Each time you move"
	line "a #mon, data"
	cont "will be saved. OK?"
	done

UnknownText_0x1c46b7::
	ctxt "No windows avail-"
	line "able for popping."
	done

UnknownText_0x1c46dc::
	ctxt "Corrupted event!"
	prompt

_ObjectEventText::
	ctxt "Object event"
	done

UnknownText_0x1c46fc::
	ctxt "BG event"
	done

UnknownText_0x1c4706::
	ctxt "Coordinates event"
	done

_AddSignpostText::
	ctxt "TBA."
	done

UnknownText_0x1c4719::
	ctxt "<PLAYER> received"
	line "<STRBF4>."
	done

UnknownText_0x1c1b2c::
	ctxt "Took <MINB>'s"
	line "<STRBF1> and"

	para "made it hold"
	line "<STRBF2>."
	prompt

UnknownText_0x1c1b57::
	ctxt "Made <MINB>"
	line "hold <STRBF2>."
	prompt

MonIsntHoldingAnythingText::
	ctxt "<MINB> isn't"
	line "holding anything."
	prompt

ConfirmThrowAwayItemText::
	ctxt "Throw away"
	line "<STRBF2>?"
	done

ThrewAwaySingularItemText::
	ctxt "Threw away"
	line "<STRBF2>."
	prompt

UnknownText_0x1c1a90::
	ctxt "Toss out how many"
	line "<STRBF2>(s)?"
	done

UnknownText_0x1c1aad::
	ctxt "Throw away @"
	deciram wItemQuantityChangeBuffer, 1, 2
	ctxt ""
	line "<STRBF2>(s)?"
	done

UnknownText_0x1c1aca::
	ctxt "Discarded"
	line "<STRBF1>(s)."
	prompt
