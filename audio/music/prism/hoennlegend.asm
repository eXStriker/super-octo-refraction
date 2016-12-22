Music_HoennLegend:
	channelcount 3
	channel 1, Music_HoennLegend_Ch1
	channel 2, Music_HoennLegend_Ch2
	channel 3, Music_HoennLegend_Ch3

Music_HoennLegend_Ch1:
	tempo $61
	dutycycle $0
	notetype $c, $a6
	octave 3
Music_HoennLegend_L1:
	callchannel Music_HoennLegend_P2
	intensity $a8
	vibrato $10, $14
	callchannel Music_HoennLegend_P1
	note D#, 12
	callchannel Music_HoennLegend_P1
	note E_, 12
	dutycycle $1
	note F_, 2
	note __, 6
	note F_, 4
	note F#, 2
	note __, 6
	note C_, 12
	note F_, 2
	note __, 6
	note F_, 4
	note F#, 2
	note __, 6
	note G#, 12
Music_HoennLegend_L2:
	octave 3
	note G_, 8
	octave 4
	note C_, 8
	octave 3
	note G#, 16
	note G_, 8
	octave 4
	note C_, 8
	note G#, 16
	loopchannel 2, Music_HoennLegend_L2
	dutycycle $2
	intensity $98
	note D#, 8
	octave 3
	note A#, 8
	note B_, 16
	note A#, 8
	octave 4
	note D#, 8
	note B_, 16
	dutycycle $0
	intensity $a6
	vibrato $0, $0
	loopchannel 0, Music_HoennLegend_L1

Music_HoennLegend_Ch2:
	dutycycle $0
	notetype $c, $a6
	octave 3
	tone $0002
	callchannel Music_HoennLegend_P2
Music_HoennLegend_L3:
	intensity $a8
	vibrato $10, $14
	tone $0000
	octave 4
	callchannel Music_HoennLegend_P3
	note A#, 12
	callchannel Music_HoennLegend_P3
	note B_, 12
	dutycycle $1
	octave 5
	note C_, 2
	note __, 6
	note C_, 4
	note C#, 2
	note __, 6
	octave 4
	note G_, 12
	octave 5
	note C_, 2
	note __, 6
	note C_, 4
	note C#, 2
	note __, 6
	note D#, 12
	dutycycle $2
	intensity $98
	callchannel Music_HoennLegend_P4
	dutycycle $0
	intensity $a8
	callchannel Music_HoennLegend_P4
	dutycycle $1
	octave 4
	note G_, 6
	note A#, 6
	octave 5
	note D#, 4
	note E_, 16
	note D#, 6
	octave 4
	note A#, 6
	note G#, 4
	octave 5
	note E_, 16
	dutycycle $3
	intensity $a7
	vibrato $0, $0
	octave 2
	callchannel Music_HoennLegend_P5
	note G#, 6
	note G_, 1
	note F_, 1
	callchannel Music_HoennLegend_P5
	octave 1
	note G_, 2
	note G#, 2
	note G_, 2
	note F_, 2
	loopchannel 0, Music_HoennLegend_L3

Music_HoennLegend_Ch3:
	notetype $c, $1f
	callchannel Music_HoennLegend_P6
	octave 1
	note G_, 4
	note __, 12
	note G_, 4
	note __, 12
	note G_, 4
	note __, 12
	note C_, 4
	note __, 12
	notetype $6, $1f
Music_HoennLegend_L4:
	callchannel Music_HoennLegend_P7
	loopchannel 5, Music_HoennLegend_L4
	intensity $19
	octave 3
Music_HoennLegend_L5:
	note C_, 4
	note G_, 4
	note C_, 4
	note G_, 4
	note C_, 4
	note G_, 4
	note C_, 4
	note G_, 4
	note C#, 4
	note G#, 4
	note C#, 4
	note G#, 4
	note C#, 4
	note G#, 4
	note C#, 4
	note G#, 4
	loopchannel 2, Music_HoennLegend_L5
Music_HoennLegend_L6:
	note D#, 4
	note A#, 4
	note D#, 4
	note A#, 4
	note D#, 4
	note A#, 4
	note D#, 4
	note A#, 4
	note E_, 4
	note B_, 4
	note E_, 4
	note B_, 4
	note E_, 4
	note B_, 4
	note E_, 4
	note B_, 4
	loopchannel 2, Music_HoennLegend_L6
	callchannel Music_HoennLegend_P6
	callchannel Music_HoennLegend_P7
	loopchannel 0, Music_HoennLegend_L4

Music_HoennLegend_P1:
	octave 4
	note C_, 2
	note __, 6
	note C_, 4
	note C#, 2
	note __, 6
	octave 3
	note G_, 12
	octave 4
	note C_, 2
	note __, 6
	note C_, 4
	note C#, 2
	note __, 6
	endchannel

Music_HoennLegend_P2:
	note C_, 16
	note C_, 16
	note C_, 16
	note C_, 16
	note __, 16
	note __, 16
	note __, 16
	note __, 16
	endchannel

Music_HoennLegend_P3:
	note G_, 2
	note __, 6
	note G_, 4
	note G#, 2
	note __, 6
	note D_, 12
	note G_, 2
	note __, 6
	note G_, 4
	note G#, 2
	note __, 6
	endchannel

Music_HoennLegend_P4:
	note C_, 6
	octave 4
	note G_, 6
	note F#, 4
	note C#, 16
	octave 5
	note C_, 6
	octave 4
	note G_, 6
	note F_, 4
	octave 5
	note C#, 16
	endchannel

Music_HoennLegend_P5:
	note C_, 2
	note __, 6
	note C_, 2
	note __, 6
	note C_, 2
	note __, 6
	octave 1
	note B_, 8
	octave 2
	note C_, 2
	note __, 6
	note C_, 2
	note __, 6
	note C_, 2
	note __, 6
	endchannel

Music_HoennLegend_P6:
	customwave $0045add8, $a9ba7766, $520499ab, $fdf96431
	endchannel

Music_HoennLegend_P7:
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	octave 1
	note G_, 3
	note __, 1
	note G_, 3
	note __, 1
	octave 2
	note C_, 3
	note __, 1
	endchannel
