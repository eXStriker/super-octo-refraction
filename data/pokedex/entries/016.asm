	ctxt "Tiny Bird" ; species name
	done
	dw 100, 40 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It rapidly flaps"
	next "its wings in the"
	next "grass, stirring up"
	done
.page2
	ctxt "a dust cloud that"
	next "drives insect prey"
	next "out into the open."
	done
