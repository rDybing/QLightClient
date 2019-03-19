/***********************************************************************************************************************

views.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/
 
//************************************************* Countdown Timer ****************************************************

function countdownView(time as clock_t)
	
	quit	as integer
	items	as integer
	clock	as timer_t
	
	if time.hour <> 0
		items = 3
	endif
	if time.hour = 0 and time.min <> 0
		items = 2
	endif
	if items = 0
		items = 1
	endif
	 
	placeCountDownStart(time.hour, time.min, time.sec)
	clock = setTimer(1000)
	
	repeat
		testClockRaw(time)
		if getTimer(clock)
			time = updateClockTime(time)
			updateClockText(time, items)			
		endif
		if GetPointerPressed()
			quit = true
		endif
		sync()
	until quit
	
	clearCountDown()
	
endFunction
