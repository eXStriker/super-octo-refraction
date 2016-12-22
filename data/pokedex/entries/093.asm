	ctxt "Gas" ; species name
	done
	dw 503, 2 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It hides in the"
	next "dark, planning to"
	next "take the life of"
	done
.page2
	ctxt "the next living"
	next "thing that wanders"
	next "close by."
	done
