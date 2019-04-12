/***********************************************************************************************************************

views.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/
 
//************************************************* Countdown Timer ****************************************************

function countdownView(clock as clock_t)
	
	quit		as integer
	items		as integer
	time		as timer_t
	backCol		as color_t[2]
	
	items = setClockItems(clock)	
	setSecondsInClock(clock)
	backCol = setClockBackgroundColors()
	
	placeCountdownStart(clock.hour, clock.min, clock.sec, backCol[0])
	time = setTimer(1000)
		
	repeat
		if GetPointerPressed()
			quit = true
		endif
		testClockRaw(clock)
		if device.isComputer
			// get if new orientation from server
			// if so:
			setScreenTextOrientation(txt.clock)
		else
			getScreenTextOrientation(txt.clock)
		endif
		if getTimer(time)
			updateClockTime(clock)
			getClockBackgroundChange(clock, backCol)
			updateClockText(clock, items)			
		endif
		updateClockBackground()
		sync()
	until quit
	
	clearCountDown()
	
endFunction
