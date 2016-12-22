	ctxt "Lizard" ; species name
	done
	dw 200, 190 ; height, weight

	db .page2 - .page1
.page1
	ctxt "If it's healthy,"
	next "the flame on the"
	next "tip of its tail"
	done
.page2
	ctxt "will burn vigor-"
	next "ously, even if it"
	next "gets a bit wet."
	done
