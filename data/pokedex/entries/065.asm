	ctxt "Psi" ; species name
	done
	dw 411, 1060 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It has an IQ of"
	next "5000. It calcu-"
	next "lates many things"
	done
.page2
	ctxt "in order to gain"
	next "the edge in every"
	next "battle."
	done
