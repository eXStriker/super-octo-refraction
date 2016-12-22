Music_HoennWildBattle:
	channelcount 3
	channel 1, Music_HoennWildBattle_Ch1
	channel 2, Music_HoennWildBattle_Ch2
	channel 3, Music_HoennWildBattle_Ch3

Music_HoennWildBattle_Ch1:
	tempo $61
	dutycycle $2
	notetype $c, $b2
	callchannel Music_LibHoennBattle_1
	dutycycle $3
	intensity $c7
	octave 3
	callchannel Music_HoennWildBattle_P4
	dutycycle $0
	vibrato $9, $12
	octave 4
	callchannel Music_HoennWildBattle_P4
Music_HoennWildBattle_L1:
	callchannel Music_HoennWildBattle_P1
	note F_, 2
	note E_, 2
	note F_, 2
	note G_, 4
	note E_, 2
	note C_, 2
	note E_, 2
	callchannel Music_HoennWildBattle_P2
	note F_, 2
	note E_, 2
	note C_, 2
	callchannel Music_HoennWildBattle_P1
	note C_, 2
	note D_, 2
	note E_, 2
	note F_, 4
	note G_, 2
	note A_, 2
	note F_, 2
	callchannel Music_HoennWildBattle_P2
	note E_, 2
	note D_, 2
	octave 3
	note B_, 2
	dutycycle $3
	vibrato $11, $12
	octave 4
	note C_, 6
	octave 3
	note G_, 6
	note E_, 4
	octave 4
	note E_, 6
	note D_, 6
	note C_, 4
	octave 3
	note A#, 6
	note F_, 6
	note D_, 4
	octave 4
	note D_, 6
	note C_, 6
	octave 3
	note A#, 4
	octave 4
	note C_, 6
	octave 3
	note G_, 6
	note E_, 4
	octave 4
	note E_, 16
	note C_, 12
	octave 3
	note G_, 4
	octave 4
	note E_, 10
	dutycycle $0
	vibrato $9, $12
	note E_, 2
	note F_, 2
	note __, 2
	dutycycle $3
	vibrato $11, $12
	octave 3
	note A#, 8
	octave 4
	note D_, 8
	octave 3
	note A#, 4
	octave 4
	note C_, 4
	note D_, 4
	octave 3
	note B_, 4
	octave 4
	note C_, 12
	octave 3
	note G_, 4
	octave 4
	note E_, 10
	note E_, 2
	note G_, 2
	note __, 2
	note G#, 10
	note C#, 2
	note G_, 4
	note G#, 4
	note G_, 4
	note F_, 4
	note C#, 4
	note C_, 10
	note __, 14
	note E_, 8
	dutycycle $2
	intensity $b2
	vibrato $0, $0
	note C_, 6
	octave 3
	note G_, 6
	octave 4
	note C_, 4
	note C#, 4
	note C_, 4
	octave 3
	note A#, 4
	octave 4
	note C#, 4
	note C_, 6
	octave 3
	note G_, 6
	octave 4
	note C_, 4
	note E_, 6
	note C_, 4
	note C#, 2
	octave 3
	note B_, 4
	callchannel Music_HoennWildBattle_P3
	callchannel Music_HoennWildBattle_P3
	intensity $c7
	loopchannel 0, Music_HoennWildBattle_L1

Music_HoennWildBattle_Ch2:
	callchannel Music_LibHoennBattle_2
	note G#, 1
	note G_, 1
	forceoctave $10
Music_HoennWildBattle_L2:
	callchannel Music_HoennWildBattle_P5
	dutycycle $0
	vibrato $9, $12
	forceoctave $0
	callchannel Music_HoennWildBattle_P5
; Pat 3 Row 0
	octave 4
	note C_, 6
	note D_, 6
	note G_, 4
	note F_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	note E_, 2
	note D_, 2
	note C_, 2
	octave 3
	note G_, 2
	note A#, 8
	octave 4
	note D_, 8
	note F_, 6
	note A_, 4
	note A_, 2
	note G_, 2
	note E_, 2
	note C_, 6
	note D_, 6
	note G_, 4
	note F_, 2
	note E_, 2
	note D_, 2
	note F_, 4
	note E_, 2
	note D_, 2
	note C_, 2
	octave 3
	note A#, 8
	octave 4
	note D_, 8
	note F_, 6
	note A#, 4
	note A_, 2
	note G_, 2
	note F_, 2
	dutycycle $1
	vibrato $11, $12
	note E_, 12
	note C_, 4
	note G_, 16
	note D_, 12
	octave 3
	note A#, 4
	octave 4
	note F_, 16
	note E_, 12
	note C_, 4
	intensity $c8
	vibrato $0, $0
	note G_, 16
	intensity $c7
	vibrato $11, $12
	note G_, 16
	note __, 10
	dutycycle $0
	vibrato $9, $12
	note G_, 2
	note A_, 2
	note __, 2
	note A#, 16
	note A#, 4
	note A_, 4
	note G_, 4
	note F_, 4
	note E_, 12
	note C_, 4
	note G_, 10
	note G_, 2
	octave 5
	note C_, 2
	note __, 2
	dutycycle $1
	vibrato $11, $12
	note C#, 14
	note C_, 2
	note C#, 4
	note C_, 4
	octave 4
	note A#, 4
	note G#, 2
	note A#, 2
	note G#, 10
	note A#, 2
	note G#, 2
	note F_, 2
	note G_, 8
	note C_, 8
	vibrato $0, $0
	forceoctave $20
	loopchannel 0, Music_HoennWildBattle_L2

Music_HoennWildBattle_Ch3:
	notetype $c, $19
	octave 2
	note G_, 16
	note A#, 8
	note B_, 8
	forceoctave $10
	callchannel Music_HoennWildBattle_P3
	callchannel Music_HoennWildBattle_P3
	callchannel Music_HoennWildBattle_P3
	forceoctave 0
	octave 3
	note C_, 2
	octave 2
	note G_, 2
	octave 3
	note C_, 2
	note C#, 4
	note C_, 2
	octave 2
	note A#, 2
	octave 3
	note C#, 2
	note C_, 2
	note F_, 2
	note C_, 2
	note F_, 4
	octave 2
	note G_, 2
	note A#, 2
	note B_, 2
	octave 3
Music_HoennWildBattle_L3:
	callchannel Music_LibHoennBattle_5th_5
	note C_, 2
	note G_, 4
	note C_, 2
	note E_, 2
	note G_, 2
	forceoctave A# + $f
	callchannel Music_LibHoennBattle_5th_5
	note C_, 2
	note G_, 4
	note G_, 2
	note C_, 2
	note G_, 2
	forceoctave C_ - 1
	callchannel Music_LibHoennBattle_5th_5
	note C_, 2
	note G_, 4
	note C_, 2
	note G_, 2
	note C_, 2
	forceoctave A# + $f
	callchannel Music_LibHoennBattle_5th_5
	note C_, 2
	note G_, 4
	note G_, 2
	note C_, 2
	note G_, 2
	forceoctave C_ - 1
	note E_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note E_, 2
	note G_, 2
	callchannel Music_LibHoennBattle_5th_5
	note D_, 2
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	note D_, 2
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 2
	octave 2
	note A#, 2
	octave 3
	note F_, 4
	note D#, 2
	octave 2
	note A#, 2
	note B_, 2
	callchannel Music_HoennWildBattle_P6
	note C_, 2
	note G_, 2
	note C_, 2
	note G_, 2
	note C_, 2
	note E_, 2
	note __, 4
	callchannel Music_HoennWildBattle_P6
	note C_, 2
	octave 2
	note G_, 2
	octave 3
	note C_, 2
	note G_, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	note G_, 2
	note A_, 2
	octave 3
	forceoctave F_ - 1
	callchannel Music_LibHoennBattle_4th_7
	note E_, 2
	note F_, 2
	forceoctave G_ - 1
	callchannel Music_LibHoennBattle_4th_8
	forceoctave G# - 1
	callchannel Music_LibHoennBattle_4th_8
	forceoctave G_ - 1
	callchannel Music_LibHoennBattle_4th_6
	forceoctave C_ - 1
	octave 3
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	callchannel Music_LibHoennBattle_5th_6
	callchannel Music_LibHoennBattle_5th_6
	note C_, 2
	note D#, 2
	note F#, 2
	note G_, 4
	note C#, 2
	note D#, 2
	octave 2
	note B_, 2
	octave 3
	callchannel Music_LibHoennBattle_5th_6
	callchannel Music_LibHoennBattle_5th_6
	note C_, 2
	note D#, 2
	note F#, 2
	note G_, 4
	note C#, 2
	note D#, 2
	note G_, 2
	loopchannel 0, Music_HoennWildBattle_L3

Music_HoennWildBattle_P1:
	dutycycle $3
	vibrato $11, $12
	octave 3
	note C_, 2
	note D_, 2
	note E_, 2
	note F_, 4
	note G_, 2
	note E_, 4
	endchannel

Music_HoennWildBattle_P2:
	dutycycle $0
	vibrato $9, $12
	note F_, 8
	note A#, 8
	octave 4
	note D_, 6
	note F_, 4
	endchannel

Music_HoennWildBattle_P3:
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	note C#, 4
	note C_, 2
	octave 3
	note A#, 2
	octave 4
	note C#, 2
	note C_, 2
	octave 3
	note G_, 2
	octave 4
	note C_, 2
	note E_, 4
	note C_, 2
	note C#, 2
	octave 3
	note B_, 2
	endchannel

Music_HoennWildBattle_P4:
	note G_, 2
	note __, 4
	note C_, 2
	note __, 4
	note G_, 2
	note __, 2
	note G#, 2
	note __, 4
	note F_, 2
	note __, 4
	note G#, 2
	note __, 2
	note G_, 2
	note __, 4
	note C_, 2
	note __, 4
	note G_, 2
	note __, 2
	note G#, 2
	note __, 4
	note A#, 2
	note __, 4
	note B_, 4
	endchannel

Music_HoennWildBattle_P5:
	octave 5
	note C_, 2
	note __, 4
	octave 4
	note G_, 2
	note __, 4
	octave 5
	note C_, 2
	note __, 2
	note C#, 2
	note __, 4
	note D#, 2
	note __, 4
	note C#, 2
	note __, 2
	note C_, 2
	note __, 4
	octave 4
	note G_, 2
	note __, 4
	octave 5
	note C_, 2
	note __, 2
	note C#, 2
	note __, 4
	note D#, 2
	note __, 4
	note F_, 4
	endchannel

Music_HoennWildBattle_P6:
	octave 3
	note C_, 2
	note E_, 2
	octave 2
	note G_, 2
	octave 3
	note E_, 2
	note C_, 2
	note E_, 2
	octave 2
	note G_, 2
	octave 3
	note E_, 2
	endchannel
