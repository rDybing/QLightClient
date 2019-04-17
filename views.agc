/***********************************************************************************************************************

views.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Cue Light Functions ************************************************

function cueLightView()
	
	quit as integer
	
	repeat
		// change to get quit-order from controller
		if GetPointerPressed()
			quit = true
		endif
		
		sync()
	until quit
	
endFunction
 
//************************************************* Countdown Timer ****************************************************

function countdownView(clock as clock_t, prop as property_t)
	
	quit		as integer
	items		as integer
	time		as timer_t
	backCol		as color_t[2]
	pulseIn		as integer
	
	pulseIn = false	
	items = setClockItems(clock)	
	setSecondsInClock(clock)
	backCol = setClockBackgroundColors()
	
	placeCountdownStart(clock.hour, clock.min, clock.sec, backCol[0], prop)
	time = setTimer(1000)
		
	repeat
		// change to get quit-order from controller
		if GetPointerPressed()
			quit = true
		endif
		testClockRaw(clock)
		if device.isComputer
			// get if new orientation from controller
			// if so:
			setScreenTextOrientation(txt.clock, prop.orientation, prop.padVertical)
		else
			getScreenTextOrientation(txt.clock, prop.padVertical)
		endif
		if getTimer(time)
			if clock.secCurrent = 0
				pulseIn = setClockBackgroundPulse(pulseIn, backCol[2])
			else
				updateClockTime(clock)
				getClockBackgroundChange(clock, backCol)
				updateClockText(clock, items)			
			endif
		endif
		updateClockBackground()
		sync()
	until quit
	
	clearCountDown()
	
endFunction
