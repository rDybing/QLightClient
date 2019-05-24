/***********************************************************************************************************************

views.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Cue Light Functions ************************************************

function cueLightView()
	
	quit		as integer
	cue			as cueLight_t
	backCol		as color_t[2]
	time		as timer_t
	pulseIn		as integer = false
	
	time = setTimer(1000)
	backCol = setCueBackgroundColors()
	placeCueLightStart(backCol[0])	
	
	repeat
		// change to get quit-order from controller
		if GetRawKeyReleased(escKey)
			quit = true
		endif
		testCueRaw(cue)
		// if new message from server
		if getCueUpdate(cue)
			// set background
			if cue.fadeOn
				setSpriteTweenColor(tween.back, sprite.back, backCol[cue.colorStep], cue.fadeDuration, 3)
			else
				setBackgroundColor(backCol[cue.colorStep])
			endif
			// set readybutton
			if cue.responseUpd
				if cue.responseReq
					placeReadyButton(backCol[2])
				endif
				if cue.responseAck
					clearSpriteSingle(sprite.bReady)
				endif
			endif
		endif
		// get if ready button is pressed
		if cue.responseReq
			// pulse
			if getTimer(time)
				pulseIn = setButtonPulse(pulseIn, tween.ready, sprite.bReady, backCol[1], backCol[2])
			endif
			updateTweenSpriteReady()
		endif
		updateTweenBackground()
		sync()
	until quit
	
	clearCueLight()
	
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
		if GetRawKeyReleased(escKey)
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
				pulseIn = setClockBackgroundPulse(pulseIn, backCol[2], prop)
			else
				updateClockTime(clock)
				getClockBackgroundChange(clock, backCol)
				updateClockText(clock, items)			
			endif
		endif
		updateTweenBackground()
		sync()
	until quit
	
	clearCountDown()
	
endFunction
