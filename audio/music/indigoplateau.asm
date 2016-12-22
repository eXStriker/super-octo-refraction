Music_IndigoPlateau:
	channelcount 4
	channel 1, Music_IndigoPlateau_Ch1
	channel 2, Music_IndigoPlateau_Ch2
	channel 3, Music_IndigoPlateau_Ch3
	channel 4, Music_IndigoPlateau_Ch4

Music_IndigoPlateau_Ch1:
	tempo $67
Music_IndigoPlateau_L1:
	sound_duty 1, 1, 1, 1
	notetype $c, $b4
	vibrato $9, $11
	octave 4
	note F_, 16
	note __, 8
	note F_, 16
	note __, 8
	note F_, 12
	note F_, 12
	note F_, 12
	note F#, 6
	octave 2
	note F#, 2
	note G#, 2
	note A_, 2
	callchannel Music_IndigoPlateau_P1
	octave 3
	callchannel Music_IndigoPlateau_P1
	sound_duty 0, 1, 1, 0
	intensity $c7
	vibrato $0, $0
	note A_, 16
	note __, 8
	note B_, 16
	note __, 8
	octave 4
	note C_, 16
	note __, 8
	octave 3
	note B_, 16
	note __, 8
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_, 2
	octave 3
	note A_, 2
	note F_, 2
	note A_, 2
	note B_, 2
	octave 4
	note D_, 2
	octave 3
	note B_, 2
	note G#, 2
	note E_, 2
	note B_, 2
	note G#, 2
	note E_, 2
	note B_, 2
	note G#, 2
	note E_, 2
	note G#, 2
	note B_, 2
	octave 4
	note E_, 2
	note F_, 2
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	note F_, 2
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	note F_, 2
	note C_, 2
	octave 3
	note A_, 2
	octave 4
	note C_, 2
	note E_, 2
	note G_, 2
	note E_, 2
	octave 3
	note B_, 2
	note G#, 2
	octave 4
	note E_, 2
	octave 3
	note B_, 2
	note G#, 2
	octave 4
	note E_, 2
	octave 3
	note B_, 2
	note G#, 2
	note B_, 2
	octave 4
	note E_, 2
	note G#, 2
	sound_duty 0, 1, 2, 3
	intensity $d1
	callchannel Music_IndigoPlateau_P2
	forceoctave $2
	callchannel Music_IndigoPlateau_P2
	forceoctave $5
	callchannel Music_IndigoPlateau_P2
	forceoctave $0
Music_IndigoPlateau_L2:
	octave 3
	note F_, 2
	note A#, 2
	octave 4
	note F_, 2
	note A#, 6
	loopchannel 3, Music_IndigoPlateau_L2
	note G#, 2
	note D#, 2
	octave 3
	note G#, 2
	note D#, 2
	sound_duty 1, 1, 1, 1
	octave 4
	callchannel Music_IndigoPlateau_P3
	forceoctave $2
	callchannel Music_IndigoPlateau_P3
	forceoctave $5
	callchannel Music_IndigoPlateau_P3
	forceoctave $0
	intensity $f
	vibrato $10, $23
	note A#, 16
	intensity $c8
	vibrato $1, $23
	note A#, 12
	intensity $c7
	note A#, 16
	intensity $b4
	vibrato $9, $11
	note F_, 16
	note __, 8
	note F_, 12
	note F#, 4
	note C#, 4
	note F#, 4
	note F_, 16
	note __, 8
	note F_, 12
	note F#, 6
	intensity $a7
	vibrato $0, $0
	octave 3
	note C_, 2
	note D_, 2
	note D#, 2
	forceoctave $17
	callchannel Music_IndigoPlateau_P1
	octave 4
	callchannel Music_IndigoPlateau_P1
	forceoctave $0
	sound_duty 0, 1, 1, 0
	intensity $c7
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	note C_, 6
	octave 3
	note F_, 6
	octave 4
	note C_, 4
	note C#, 3
	note __, 1
	note C#, 3
	note __, 1
	note C#, 3
	note __, 1
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	note C_, 6
	octave 3
	note F_, 6
	octave 4
	note F_, 4
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	octave 3
	note G#, 6
	octave 4
	note D#, 6
	note G#, 4
	octave 3
	note G#, 6
	octave 4
	note D#, 6
	note G#, 4
	note D#, 6
	octave 3
	note G#, 6
	octave 4
	note D#, 4
	note D_, 3
	note __, 1
	note D_, 3
	note __, 1
	note D_, 3
	note __, 1
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	octave 3
	note F_, 6
	octave 4
	note C_, 6
	note F_, 4
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note G#, 12
	note F#, 16
	loopchannel 0, Music_IndigoPlateau_L1

Music_IndigoPlateau_Ch2:
	dutycycle $2
	notetype $c, $b6
	octave 1
Music_IndigoPlateau_L3:
	callchannel Music_IndigoPlateau_P5
	loopchannel 8, Music_IndigoPlateau_L3
Music_IndigoPlateau_L4:
	callchannel Music_IndigoPlateau_P4
	forceoctave $2
	callchannel Music_IndigoPlateau_P4
	forceoctave $5
	callchannel Music_IndigoPlateau_P4
	forceoctave $0
	octave 1
	note A#, 2
	note __, 4
	octave 2
	note A#, 2
	note __, 4
	octave 1
	note A#, 2
	note __, 4
	octave 2
	note A#, 2
	note __, 4
	octave 1
	note A#, 2
	note __, 4
	octave 2
	note A#, 2
	note __, 4
	octave 1
	note G#, 2
	note __, 2
	octave 2
	note G#, 2
	note __, 2
	loopchannel 2, Music_IndigoPlateau_L4
	octave 1
Music_IndigoPlateau_L5:
	callchannel Music_IndigoPlateau_P5
	loopchannel 4, Music_IndigoPlateau_L5
	callchannel Music_IndigoPlateau_P6
	callchannel Music_IndigoPlateau_P6
Music_IndigoPlateau_L6:
	octave 2
	note G#, 2
	note E_, 2
	note F#, 2
	note D#, 2
	note E_, 2
	note C#, 2
	note D#, 2
	octave 1
	note G#, 2
	loopchannel 3, Music_IndigoPlateau_L6
	octave 2
	note G_, 2
	note __, 2
	octave 1
	note G_, 2
	note __, 2
	octave 2
	note G_, 2
	note __, 2
	callchannel Music_IndigoPlateau_P6
	note G#, 12
	note F#, 8
	octave 1
	note F#, 8
	loopchannel 0, Music_IndigoPlateau_L3

Music_IndigoPlateau_Ch3:
	notetype $c, $1f
	callchannel Music_IndigoPlateau_W1
	setcondition $0
	octave 2
Music_IndigoPlateau_L7:
	rept 3
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	callchannel Music_IndigoPlateau_W2
	note F_, 1
	note __, 1
	callchannel Music_IndigoPlateau_W1
	note F_, 2
	note __, 4
	endr
	note F#, 3
	note __, 1
	callchannel Music_IndigoPlateau_W2
	note F#, 3
	note __, 1
	callchannel Music_IndigoPlateau_W1
	note F#, 3
	note __, 1
	loopchannel 8, Music_IndigoPlateau_L7
	setcondition $1
	rept 2
	callchannel Music_IndigoPlateau_P7
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	forceoctave $2
	callchannel Music_IndigoPlateau_P7
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	forceoctave $5
	callchannel Music_IndigoPlateau_P7
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	callchannel Music_IndigoPlateau_P7
	note D#, 3
	note __, 1
	note D#, 3
	note __, 1
	forceoctave $0
	endr
	setcondition $0
Music_IndigoPlateau_L8:
	rept 3
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	callchannel Music_IndigoPlateau_W2
	note F_, 1
	note __, 1
	callchannel Music_IndigoPlateau_W1
	note F_, 2
	note __, 4
	endr
	note F#, 3
	note __, 1
	callchannel Music_IndigoPlateau_W2
	note F#, 3
	note __, 1
	callchannel Music_IndigoPlateau_W1
	note F#, 3
	note __, 1
	loopchannel 4, Music_IndigoPlateau_L8
	setcondition $2
	rept 2
	callchannel Music_IndigoPlateau_P8
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	endr
	forceoctave $3
	callchannel Music_IndigoPlateau_P8
	forceoctave $0
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	callchannel Music_IndigoPlateau_P8
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	note F#, 3
	note __, 1
	setcondition $0
	note G#, 12
	note F#, 8
	callchannel Music_IndigoPlateau_W2
	note F#, 8
	callchannel Music_IndigoPlateau_W1
	loopchannel 0, Music_IndigoPlateau_L7

Music_IndigoPlateau_Ch4:
	notetype $c
	togglenoise $0
Music_IndigoPlateau_L9:
	note D_, 2
	note D#, 2
	note D#, 2
	note D#, 6
	note D_, 2
	note D#, 2
	note D#, 2
	note D#, 4
	note D#, 1
	note D#, 1
	note D_, 2
	note D#, 2
	note D#, 2
	note D#, 6
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	loopchannel 8, Music_IndigoPlateau_L9
Music_IndigoPlateau_L10:
	note D#, 4
	note G_, 2
	note C#, 4
	note G_, 2
	note D#, 4
	note G_, 2
	note C#, 4
	note G_, 2
	note D#, 4
	note G_, 2
	note C#, 4
	note G_, 2
	note D#, 2
	note G_, 1
	note G_, 1
	note C#, 2
	note G_, 1
	note G_, 1
	loopchannel 8, Music_IndigoPlateau_L10
	togglenoise
	togglenoise $3
	note B_, 16
	note __, 16
	note __, 16
	note B_, 16
	note __, 8
	note B_, 12
	note G_, 1
	note G_, 1
	note G_, 1
	note G_, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G#, 1
	note G_, 1
	note G_, 1
	note B_, 1
	note B_, 1
Music_IndigoPlateau_L11:
	note B_, 2
	note G_, 2
	note G_, 2
	note G#, 2
	note G_, 2
	note G_, 2
	loopchannel 3, Music_IndigoPlateau_L11
	note B_, 2
	note G_, 2
	note D#, 2
	note G#, 1
	note G#, 1
	note C_, 2
	note C_, 1
	note C_, 1
Music_IndigoPlateau_L12:
	note D#, 2
	note G#, 2
	note C_, 2
	note G#, 2
	note C_, 2
	note G#, 1
	note G#, 1
	loopchannel 3, Music_IndigoPlateau_L12
	note D#, 2
	note C_, 2
	note D#, 2
	note C_, 2
	note C_, 1
	note C_, 1
	note C_, 1
	note C_, 1
Music_IndigoPlateau_L13:
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 2
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 2
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 2
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 1
	note G#, 1
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 2
	note D#, 2
	note G_, 2
	note C_, 2
	note G#, 2
	note D#, 2
	note G_, 1
	note G#, 1
	note C_, 2
	note G_, 1
	note G#, 1
	note C_, 2
	note G_, 1
	note G#, 1
	loopchannel 4, Music_IndigoPlateau_L13
	note B_, 12
	note D#, 8
	togglenoise
	togglenoise $0
	note D#, 1
	note D#, 1
	note D#, 1
	note D#, 1
	note D_, 1
	note D_, 1
	note D_, 1
	note D_, 1
	loopchannel 0, Music_IndigoPlateau_L9

Music_IndigoPlateau_P1:
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	note A#, 2
	note __, 4
	loopchannel 3, Music_IndigoPlateau_P1
	note B_, 3
	note __, 1
	note B_, 3
	note __, 1
	note B_, 3
	note __, 1
	endchannel

Music_IndigoPlateau_P2:
	octave 3
	note C_, 2
	note F_, 2
	octave 4
	note C_, 2
	note F_, 6
	loopchannel 3, Music_IndigoPlateau_P2
	note F#, 2
	note C#, 2
	octave 3
	note F#, 2
	note C#, 2
	endchannel

Music_IndigoPlateau_P3:
	intensity $f
	vibrato $10, $23
	note F_, 16
	intensity $c8
	vibrato $1, $23
	note F_, 8
	note F_, 12
	note F#, 8
	endchannel

Music_IndigoPlateau_P4:
	octave 1
	note F_, 2
	note __, 4
	octave 2
	note F_, 2
	note __, 4
	octave 1
	note F_, 2
	note __, 4
	octave 2
	note F_, 2
	note __, 4
	octave 1
	note F_, 2
	note __, 4
	octave 2
	note F_, 2
	note __, 4
	octave 1
	note F#, 2
	note __, 2
	octave 2
	note F#, 2
	note __, 2
	endchannel

Music_IndigoPlateau_P5:
	note F_, 2
	note __, 4
	octave 2
	note F_, 2
	note __, 4
	octave 1
	note F_, 2
	note __, 4
	octave 2
	note F_, 2
	note __, 4
	octave 1
	note F_, 2
	note __, 4
	octave 2
	note F_, 2
	note __, 4
	octave 1
	note F#, 2
	note __, 2
	octave 2
	note F#, 2
	note __, 2
	octave 1
	note F#, 2
	note __, 2
	endchannel

Music_IndigoPlateau_P6:
	octave 2
	note F_, 2
	note C#, 2
	note D#, 2
	note C_, 2
	note C#, 2
	octave 1
	note A#, 2
	octave 2
	note C_, 2
	octave 1
	note F_, 2
	loopchannel 3, Music_IndigoPlateau_P6
	octave 2
	note F#, 2
	note __, 2
	octave 1
	note F#, 2
	note __, 2
	octave 2
	note F#, 2
	note __, 2
	endchannel

Music_IndigoPlateau_P7:
	note F_, 1
	note __, 1
	jumpchannel Music_IndigoPlateau_W2
Music_IndigoPlateau_P7_2:
	intensity $2f
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	jumpchannel Music_IndigoPlateau_W1
Music_IndigoPlateau_P7_3:
	intensity $1f
	loopchannel 6, Music_IndigoPlateau_P7
	endchannel

Music_IndigoPlateau_P8:
	note F_, 2
	jumpchannel Music_IndigoPlateau_W2
Music_IndigoPlateau_P8_2:
	note F_, 2
	jumpchannel Music_IndigoPlateau_W1
Music_IndigoPlateau_P8_3:
	octave 1
	note F_, 2
	note __, 2
	octave 2
	loopchannel 6, Music_IndigoPlateau_P8
	endchannel

Music_IndigoPlateau_W1:
	customwave $ffffffb7, $878effb6, $dff97ac6, $dffffe20
	jumpif $1, Music_IndigoPlateau_P7_3
	jumpif $2, Music_IndigoPlateau_P8_3
	endchannel

Music_IndigoPlateau_W2:
	customwave $ffffffff, $a78fb686, $dff97aff, $ffffb500
	jumpif $1, Music_IndigoPlateau_P7_2
	jumpif $2, Music_IndigoPlateau_P8_2
	endchannel
