/***********************************************************************************************************************

views.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Menu Functions *****************************************************

function modeSelectView()
	
	quit		as integer = false
	keyTimer	as timer_t
	mouse		as mouse_t
	spriteID	as integer
	button		as button_t[]
	
	state.buttonHit = false
	
	clearCueLight()
	clearFrame()
	setBackgroundColor(color[10])
	placeLogo()
	placeMenuButton(color[0])
	placeMenuText()
	button = placeModeButtons(color[11])	
	
	repeat
		mouse = updateMouse()		
		if mouse.hit
			mouse = getMouseHit(mouse)
			spriteID = mouse.spriteID
			select spriteID
			case sprite.bMenu
				dropDownView()
			endCase
			case sprite.bModeClient
				keyTimer = keyPressed(sprite.bModeClient)
			endCase
			case sprite.bModeCtrl
				keyTimer = keyPressed(sprite.bModeCtrl)
			endCase
			endSelect
		endif	
		
		if getTimer(keyTimer) and state.buttonHit
			state.buttonHit = false
			SetSpriteColorAlpha(spriteID, color[11].a)
		endif
		
		sync()
	until quit
	
endFunction

function dropDownView()
	
	quit		as integer = false
	mouse		as mouse_t
	options		as string[2] = ["setLang", "setName"]
	button		as button_t[2]
	langBtn		as button_t[3]
	spriteID	as integer
	ddHeight 	as float
	offset		as integer = 12
	
	button = placeDropDownMenu(options)
	ddHeight = GetSpriteHeight(sprite.dropBack)
	sync()
	click()
	
	repeat 
		mouse = updateMouse()
		if mouse.hit
			mouse = getMouseHit(mouse)
			spriteID = mouse.spriteID
			select spriteID
			case sprite.bMenu
				clearDropDownMenu(button)
				clearSelectLanguage(langBtn)
				quit = true
			endCase
			case button[0].sprID
				if button[0].active
					shrinkDropDownMenu(ddHeight)
					moveButtonUp(button[1])
					clearSelectLanguage(langBtn)
					button[0].active = false
				elseif button[0].active = false and button[1].active = false
					expandDropDownMenu(ddHeight + offset)
					moveButtonDown(button[1], offset)
					langBtn = placeSelectLanguage(button[1].sprY)
					button[0].active = true
				endif
			endCase
			case button[1].sprID
				if button[1].active
					shrinkDropDownMenu(ddHeight)
					button[1].active = false
				elseif button[1].active = false and button[0].active = false
					expandDropDownMenu(ddHeight + offset)
					button[1].active = true
				endif
			endCase
			endSelect
			if button[0].active
				
			endif
			if button[1].active
				
			endif
		endif	
		sync()
	until quit
	
endFunction

function keyPressed(spriteID)

	keyTimer as timer_t

	state.buttonHit = true
	SetSpriteColorAlpha(spriteID, 32)
	click()
	keyTimer = setTimer(75)
	
endFunction keyTimer

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
		// if ready button is active
		if cue.responseReq
			// get if ready button is pressed
			if getButton(sprite.bReady)
				cue.responseReq = false
				cue.responseAck = true
				clearSpriteSingle(sprite.bReady)
			endif
			// pulse once a second
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
			if getOrientationChange(prop)
				setScreenTextOrientation(txt.clock, prop.orientation, prop.padVertical)
			endif
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
		updateTweenString(txt.clock)
		sync()
	until quit
	
	clearCountDown()
	
endFunction
