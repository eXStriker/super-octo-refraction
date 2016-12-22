Music_PrismTrainerEncounter:
	dbw $C0, PrismTrainerEncounter_Ch1
	dbw $01, PrismTrainerEncounter_Ch2
	dbw $02, PrismTrainerEncounter_Ch3
	dbw $03, PrismTrainerEncounter_Ch4

PrismTrainerEncounter_Ch1::
	tempo 134
	volume $77
	vibrato $12, $25
	dutycycle $1
	tone $0002
	octave 5
	notetype $6, $c3
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 4
	note B_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	note E_, 1
PrismTrainerEncounter_Ch1_sub_0:
	notetype $c, $c1
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 1
	note C_, 1
	note C_, 1
	note __, 1
	loopchannel 0, PrismTrainerEncounter_Ch1_sub_0

PrismTrainerEncounter_Ch2::
	vibrato $10, $23
	dutycycle $1
	notetype $c, $c7
	tone $0003
	octave 5
	notetype $6, $c3
	note C_, 1
	octave 4
	note B_, 1
	note A#, 1
	note A_, 1
	note G#, 1
	note G_, 1
	note F#, 1
	note F_, 1
	octave 4
	note E_, 1
	note D#, 1
	note D_, 1
	note C#, 1
	note C_, 1
	octave 3
	note B_, 1
	note A#, 1
	note A_, 1
PrismTrainerEncounter_Ch2_sub_0:
	notetype $c, $c1
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	note __, 1
	note F_, 1
	note F_, 1
	note __, 1
	loopchannel 0, PrismTrainerEncounter_Ch2_sub_0

PrismTrainerEncounter_Ch3::
	stereopanning $ff
	vibrato $8, $23
	notetype $c, $12
	intensity $10
	note __, 8
PrismTrainerEncounter_Ch3_sub_0:
	octave 5
	note F_, 12
	note G#, 4
	note G_, 4
	note E_, 12
	note F_, 12
	note G#, 4
	note G_, 4
	note A#, 12
	loopchannel 0, PrismTrainerEncounter_Ch3_sub_0

PrismTrainerEncounter_Ch4:
	togglenoise $3
	notetype $c
	note __, 8
PrismTrainerEncounter_Ch4_sub_0:
	note E_, 1
	note E_, 1
	note E_, 2
	note B_, 4
	loopchannel 0, PrismTrainerEncounter_Ch4_sub_0
