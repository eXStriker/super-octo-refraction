	ctxt "Balloon" ; species name
	done
	dw 108, 120 ; height, weight

	db .page2 - .page1
.page1
	ctxt "It rolls its cute"
	next "eyes as it sings a"
	next "soothing lullaby."
	done
.page2
	ctxt "Its gentle song"
	next "puts anyone who"
	next "hears it to sleep."
	done
