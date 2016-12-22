Music_DreamSequence:
	channelcount 2
	channel 1, Music_DreamSequence_Ch1
	channel 2, Music_DreamSequence_Ch2

Music_DreamSequence_Ch1:
	tempo $72
	dutycycle $0
	notetype $c, $38
	tone $0003
	note __, 6
	octave 4
	note F_, 1
	note __, 1
Music_DreamSequence_L1:
	callchannel Music_DreamSequence_P1
	intensity $38
	octave 4
	note D_, 1
	intensity $18
	note A#, 1
	callchannel Music_DreamSequence_P2
	intensity $38
	octave 4
	note F_, 1
	intensity $18
	note G_, 1
	loopchannel 0, Music_DreamSequence_L1

Music_DreamSequence_Ch2:
	dutycycle $0
	notetype $c, $c6
	tone $0003
	octave 4
	note F_, 1
	note __, 1
Music_DreamSequence_L4:
	callchannel Music_DreamSequence_P3
	intensity $c6
	octave 4
	note D_, 1
	intensity $67
	note A#, 1
	callchannel Music_DreamSequence_P4
	intensity $c6
	octave 4
	note F_, 1
	intensity $67
	note G_, 1
	loopchannel 0, Music_DreamSequence_L4

Music_DreamSequence_L2:
	intensity $38
	octave 4
	note F_, 1
	intensity $18
	note A#, 1
Music_DreamSequence_P1:
	intensity $38
	note A#, 1
	intensity $18
	note F_, 1
	intensity $38
	octave 5
	note C_, 1
	intensity $18
	octave 4
	note A#, 1
	intensity $38
	octave 5
	note F_, 1
	intensity $18
	note C_, 1
	intensity $38
	note A#, 1
	intensity $18
	note F_, 1
	intensity $38
	note F_, 1
	intensity $18
	note A#, 1
	intensity $38
	note D_, 1
	intensity $18
	note F_, 1
	intensity $38
	octave 4
	note A#, 1
	intensity $18
	octave 5
	note D_, 1
	loopchannel 4, Music_DreamSequence_L2
	endchannel

Music_DreamSequence_L3:
	intensity $38
	note D_, 1
	intensity $18
	note G_, 1
Music_DreamSequence_P2:
	intensity $38
	note G_, 1
	intensity $18
	note D_, 1
	intensity $38
	note A_, 1
	intensity $18
	note G_, 1
	intensity $38
	octave 5
	note D_, 1
	intensity $18
	octave 4
	note A_, 1
	intensity $38
	octave 5
	note G_, 1
	intensity $18
	note D_, 1
	intensity $38
	note D_, 1
	intensity $18
	note G_, 1
	intensity $38
	octave 4
	note A#, 1
	intensity $18
	octave 5
	note D_, 1
	intensity $38
	octave 4
	note G_, 1
	intensity $18
	note A#, 1
	loopchannel 4, Music_DreamSequence_L3
	endchannel

Music_DreamSequence_L5:
	intensity $c6
	octave 4
	note F_, 1
	intensity $67
	note A#, 1
Music_DreamSequence_P3:
	intensity $c6
	note A#, 1
	intensity $67
	note F_, 1
	intensity $c6
	octave 5
	note C_, 1
	intensity $67
	octave 4
	note A#, 1
	intensity $c6
	octave 5
	note F_, 1
	intensity $67
	note C_, 1
	intensity $c6
	note A#, 1
	intensity $67
	note F_, 1
	intensity $c6
	note F_, 1
	intensity $67
	note A#, 1
	intensity $c6
	note D_, 1
	intensity $67
	note F_, 1
	intensity $c6
	octave 4
	note A#, 1
	intensity $67
	octave 5
	note D_, 1
	loopchannel 4, Music_DreamSequence_L5
	endchannel

Music_DreamSequence_L6:
	intensity $c6
	note D_, 1
	intensity $67
	note G_, 1
Music_DreamSequence_P4:
	intensity $c6
	note G_, 1
	intensity $67
	note D_, 1
	intensity $c6
	note A_, 1
	intensity $67
	note G_, 1
	intensity $c6
	octave 5
	note D_, 1
	intensity $67
	octave 4
	note A_, 1
	intensity $c6
	octave 5
	note G_, 1
	intensity $67
	note D_, 1
	intensity $c6
	note D_, 1
	intensity $67
	note G_, 1
	intensity $c6
	octave 4
	note A#, 1
	intensity $67
	octave 5
	note D_, 1
	intensity $c6
	octave 4
	note G_, 1
	intensity $67
	note A#, 1
	loopchannel 4, Music_DreamSequence_L6
	endchannel
