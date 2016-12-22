Music_PrismFemaleTrainer:
	dbw $80, Ch1
	dbw $01, Ch2
	dbw $02, Ch3
	dbw $02, Ch4

Ch1_sub_0:
	rest 1
	octave 4
	C_ 1
	rest 3
	octave 3
	A# 1
	rest 3
	octave 4
	C_ 1
	rest 1
	octave 3
	B_ 1
	rest 1
	A_ 1
	rest 1
	B_ 1
	rest 1
	G_ 1
	rest 3
	G_ 1
	rest 3
	E_ 1
	rest 1
	F_ 1
	rest 1
	F# 1
	rest 1
	G_ 1
	rest 1
	D_ 1
	rest 3
	D_ 1
	rest 3
	F_ 1
	rest 1
	G_ 1
	rest 1
	G# 1
	rest 1
	A_ 1
	rest 1
	E_ 1
	rest 3
	E_ 1
	endchannel
Ch1::
	vibrato 0, 0, 0
	duty 0
	notetype 12, 12, 0
	octave 3
	G_ 1
	rest 1
	G# 1
	rest 1
	A_ 1
	rest 1
	A# 1
	callchannel Ch1_sub_0
	rest 3
	G_ 1
	rest 1
	G# 1
	rest 1
	A_ 1
	rest 1
	B_ 1
	callchannel Ch1_sub_0
	endchannel
Ch2::
	endchannel
Ch3_sub_0:
	E_ 1
	rest 1
	G_ 1
	rest 1
	octave 4
	C_ 1
	rest 1
	octave 3
	A_ 1
	rest 1
	octave 4
	C_ 1
	rest 3
	octave 3
	G_ 1
	rest 1
	A_ 1
	rest 1
	octave 4
	C_ 1
	rest 3
	octave 3
	C_ 1
	rest 1
	D_ 1
	rest 1
	E_ 1
	rest 3
	G_ 1
	rest 3
	octave 4
	C_ 1
	rest 3
	octave 3
	F_ 1
	rest 3
	D_ 1
	rest 3
	D_ 1
	rest 1
	E_ 1
	rest 1
	D_ 1
	rest 3
	D_ 1
	rest 3
	E_ 1
	rest 3
	E_ 1
	rest 1
	G_ 1
	endchannel
Ch3::
	vibrato 0, 0, 0
	notetype 12, 12, 0
	octave 3
	callchannel Ch3_sub_0
	rest 1
	callchannel Ch3_sub_0
	endchannel
Ch4_sub_0:
	snare1 1
	rest 7
	snare1 1
	rest 7
	snare1 1
	rest 7
	snare1 1
	rest 7
	snare1 1
	rest 7
	endchannel
Ch4::
	dspeed 12
	rest 4
	callchannel Ch4_sub_0
	callchannel Ch4_sub_0
	callchannel Ch4_sub_0
	snare1 1
	endchannel
