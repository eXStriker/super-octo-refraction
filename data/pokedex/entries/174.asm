	ctxt "Balloon" ; species name
	done
	dw 100, 20 ; height, weight

	db .page2 - .page1
.page1
	ctxt "Instead of walking"
	next "with its short"
	next "legs, it moves"
	done
.page2
	ctxt "around by bouncing"
	next "on its soft,"
	next "tender body."
	done
