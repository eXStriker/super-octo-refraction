	ctxt "Seed" ; species name
	done
	dw 303, 290 ; height, weight

	db .page2 - .page1
.page1
	ctxt "The bulb on its"
	next "back grows as it"
	next "absorbs nutrients."
	done
.page2
	ctxt "The bulb gives off"
	next "a pleasant aroma"
	next "when it blooms."
	done
