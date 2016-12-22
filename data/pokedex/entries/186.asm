	ctxt "Eruption" ; species name
	done
	dw 603, 4850 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It has volcanoes"
	next "on its back. If"
	next "magma builds up in"
	done
.page2
	ctxt "its body, it"
	next "shudders, then"
	next "erupts violently."
	done
