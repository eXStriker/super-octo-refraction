	ctxt "Balloon" ; species name
	done
	dw 303, 260 ; height, weight

	db .page2 - .page1
.page1
	ctxt "The rich, fluffy"
	next "fur that covers"
	next "its body feels so"
	done
.page2
	ctxt "good that anyone"
	next "who feels it can't"
	next "stop touching it."
	done
