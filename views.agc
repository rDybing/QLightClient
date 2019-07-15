/***********************************************************************************************************************

views.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Main Menu Functions ************************************************

function mainMenuView()
	
	quit		as integer = false
	keyTimer	as timer_t
	mouse		as mouse_t
	spriteID	as integer
	button		as button_t[]
	modeSelect	as string = ""
	
	state.buttonHit = false
		
	button = placeMainMenu()
		
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
				modeSelect = "client"
			endCase
			case sprite.bModeCtrl
				keyTimer = keyPressed(sprite.bModeCtrl)
				modeSelect = "ctrl"
			endCase
			endSelect
		endif	
		// reset button highlight
		if getTimer(keyTimer) and state.buttonHit
			state.buttonHit = false
			highlightButton(spriteID, state.buttonHit)
			modeSwitch(modeSelect, button)
			placeMainMenu()
		endif
		sync()
	until quit
	
endFunction

function keyPressed(spriteID)

	keyTimer as timer_t

	state.buttonHit = true
	highlightButton(spriteID, state.buttonHit)
	click()
	keyTimer = setTimer(50)
	
endFunction keyTimer

//************************************************* Controller Functions ***********************************************

function controlView()
	
	quit 		as integer
	mouse		as mouse_t
	spriteID	as integer
	keyTimer	as timer_t
	button		as button_t[]
	modeSelect	as string
	dimmed		as integer = 48
	altButton	as integer = false
	clock		as clock_t
	clockTimer	as timer_t
	clockCol	as color_t[2]
	prop		as property_t
	btnOk		as button_t
	
	setBackgroundColor(color[10])
	placeLogo()
	button = placeControlButtons(dimmed)
	
	prop.baseSize = 7.5
	prop.font = media.fontC
	prop.fontColor = 5
	prop.fontAlpha = 192
	
	clock = loadDefaultClock()
	clockCol = setClockColors()
	
	setSecondsInClock(clock)
	placeCountdownStart(clock.hour, clock.min, clock.sec, color[5], prop, "ctrl")
	
	repeat
		if GetRawKeyReleased(escKey)
			quit = true
		endif
		
		mouse = updateMouse()		
		if mouse.hit
			mouse = getMouseHit(mouse)
			spriteID = mouse.spriteID
			select spriteID
			case sprite.bCtrlWait
				state.buttonHit = true
				state.mode = "cue"
				modeSelect = "wait"
			endCase
			case sprite.bCtrlReady
				state.buttonHit = true
				state.mode = "cue"
				modeSelect = "ready"
			endCase
			case sprite.bCtrlAction
				state.buttonHit = true
				state.mode = "cue"
				modeSelect = "action"
			endCase
			case sprite.bCtrlTimer
				state.buttonHit = true
				state.mode = "timer"
				modeSelect = "timer"
			endCase
			case sprite.bCtrlPlayPause
				if state.mode = "timer"
					state.buttonHit = true
					modeSelect = "playpause"
					clock.play = not clock.play
					clockTimer = setTimer(1000)
				endif
			endCase
			case sprite.bCtrlEdit
				if not clock.play
					keyTimer = keyPressed(sprite.bCtrlEdit)
					altButton = true
					modeSelect = "edit"
				endif
			endCase
			case sprite.bCtrlReset
				if state.mode = "timer"
					keyTimer = keyPressed(sprite.bCtrlReset)
					altButton = true
					clock.play = false
					clock = loadDefaultClock()
					setSecondsInClock(clock)
					resetCtrlClock(clock, clockCol, prop.fontAlpha)
				endif
			endCase
			endSelect
		endif
		
		if state.buttonHit
			click()
			state.buttonHit = false
			changeButtonHighlight(modeSelect, dimmed, clock)
			networkEmitter(modeSelect)
		endif
		
		if getTimer(keyTimer) and altButton
			altButton = false
			highlightButton(spriteID, false)
			if modeSelect = "edit"
				btnOK = placeSetClockEdit(clock)
			endif
		endif
		
		if btnOK.active
			timeSet = handleChangeClockEdit(spriteID, btnOK, clock)
			if timeSet
				clearTextInput(btnOK.sprID)
				timeSet = false
				btnOK.active = false
				updateClockText(clock, 3)
			endif
		endif
		
		if clock.play 
			if getTimer(clockTimer)
				updateCtrlClock(clock, clockCol)
			endif
			updateTweenString(txt.clock)
		endif
		//testClockRaw(clock)
		sync()
	until quit
	
	clearControl(button)
	
endFunction

function handleChangeClockEdit(spriteID as integer, nameBtn ref as button_t, c ref as clock_t)
	
	out as integer = false
	
	if spriteID = nameBtn.sprID
		click()
		c.output = getEditBoxInput()
		setClockFromInput(c)
		//saveDefaultClock()
		out = true
	endif
	
endFunction out

function updateCtrlClock(c ref as clock_t, cc as color_t[])
	
	if c.secCurrent <> 0
		updateClockTime(c)
		getClockCtrlChange(c, cc)
		updateClockText(c, 3)
	endif
		
endFunction

function resetCtrlClock(c ref as clock_t, cc as color_t[], alpha as integer)
	
	setClockCtrlReset(c, cc[0], alpha)
	updateClockText(c, 3)
	
endFunction

function changeButtonHighlight(in as string, dimmed as integer, clock ref as clock_t)
	
	select in
	case "wait"
		highlightColorButton(sprite.bCtrlWait, true, dimmed)
		highlightColorButton(sprite.bCtrlReady, false, dimmed)
		highlightColorButton(sprite.bCtrlAction, false, dimmed)
		highlightButton(sprite.bCtrlTimer, false)
		resetPlayPause(clock)
	endCase
	case "ready"
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, true, dimmed)
		highlightColorButton(sprite.bCtrlAction, false, dimmed)
		highlightButton(sprite.bCtrlTimer, false)
		resetPlayPause(clock)
	endCase
	case "action"
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, false, dimmed)
		highlightColorButton(sprite.bCtrlAction, true, dimmed)
		highlightButton(sprite.bCtrlTimer, false)
		resetPlayPause(clock)
	endCase
	case "timer"
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, false, dimmed)
		highlightColorButton(sprite.bCtrlAction, false, dimmed)
		highlightButton(sprite.bCtrlTimer, true)
		setSpriteFramePlayPause(false)
	endCase
	case "playpause"
		setSpriteFramePlayPause(clock.play)
	endCase
	case "edit"
		highlightButton(sprite.bCtrlEdit, true)
	endCase
	case "reset"
		highlightButton(sprite.bCtrlReset, true)
		setSpriteFramePlayPause(clock.play)
	endCase
	endSelect
	
endFunction

//************************************************* Main Menu Drop Down Functions **************************************

function dropDownView()
	
	quit		as integer = false
	mouse		as mouse_t
	options		as string[2] = ["setLang", "setName"]
	button		as button_t[2]
	langBtn		as button_t[3]
	nameBtn		as button_t
	spriteID	as integer
	ddHeight 	as float
	offset		as integer = 12
	tempLang	as integer
	nameSet		as integer = false	
	
	tempLang = state.language
	button = placeDropDownMenu(options)
	ddHeight = getDropDownMenuSize()
	sync()
	click()
	
	repeat 
		mouse = updateMouse()
		if mouse.hit
			mouse = getMouseHit(mouse)
			spriteID = mouse.spriteID
			quit = handleMainDropDown(spriteID, button, langBtn, nameBtn, ddHeight, offset, quit)
			// Change Language
			if button[0].active
				tempLang = handleChangeLanguage(spriteID, langBtn, tempLang)				
			endif
			// Change Client Name
			if button[1].active
				nameSet = handleChangeClientName(spriteID, nameBtn)
				if nameSet
					clearTextInput(nameBtn.sprID)
					resizeDropDownMenu(ddHeight)
					nameSet = false
					button[1].active = false
				endif
			endif
		endif
		//testDevice()	
		sync()
	until quit
	
endFunction

function handleMainDropDown(spriteID as integer, 
	button		ref as button_t[], 
	langBtn		ref as button_t[],
	nameBtn		ref as button_t, 
	ddHeight	as float, 
	offset		as integer, 
	quit		as integer)
	
	select spriteID
	// Settings Drop Down Menu
	case sprite.bMenu
		clearDropDownMenu(button)
		clearSelectLanguage(langBtn)
		clearTextInput(nameBtn.sprID)
		quit = true
		click()
	endCase
	// Change Language
	case button[0].sprID
		if button[0].active
			resizeDropDownMenu(ddHeight)
			moveButton(button[1], 0)
			clearSelectLanguage(langBtn)
			button[0].active = false
		elseif button[0].active = false and button[1].active = false
			resizeDropDownMenu(ddHeight + offset)
			moveButton(button[1], offset)
			langBtn = placeSelectLanguage(button[1].sprY)
			button[0].active = true
		endif
		click()
	endCase
	// Change Client Name
	case button[1].sprID
		if button[1].active
			resizeDropDownMenu(ddHeight)
			clearTextInput(nameBtn.sprID)
			button[1].active = false
		elseif button[1].active = false and button[0].active = false
			resizeDropDownMenu(ddHeight + offset)
			nameBtn = placeSetClientName()
			button[1].active = true
		endif
		click()
	endCase
	endSelect
	
endFunction quit

function handleChangeLanguage(spriteID as integer, langBtn ref as button_t[], tempLang as integer)
	
	select spriteID
	// Left / Previous
	case langBtn[0].sprID
		if tempLang > 0
			dec tempLang
		else
			tempLang = ml[0].lang.length
		endif
		click()
		updateFlagSprite(tempLang)
		updateCheckSprite(tempLang)
	endCase
	// Right / Next
	case langBtn[1].sprID
		if tempLang < ml[0].lang.length
			inc tempLang
		else
			tempLang = 0
		endif
		click()
		updateFlagSprite(tempLang)
		updateCheckSprite(tempLang)
	endCase
	// Check / Accept
	case langBtn[2].sprID
		if tempLang <> state.language
			click()
			state.language = tempLang
			app.language = getLangCode(tempLang)
			changeLanguageAllActive()
			saveAppSettings()
			updateCheckSprite(tempLang)
		endif
	endCase
	endSelect
				
endFunction tempLang

function handleChangeClientName(spriteID as integer, nameBtn ref as button_t)
	
	out as integer = false
	
	if spriteID = nameBtn.sprID
		click()
		app.name = getEditBoxInput()
		saveAppSettings()
		out = true
	endif
	
endFunction out

//************************************************* Cue Light Functions ************************************************

function cueLightView()
	
	quit		as integer
	cue			as cueLight_t
	backCol		as color_t[2]
	time		as timer_t
	pulseIn		as integer = false
	mouse		as mouse_t
	
	time = setTimer(1000)
	backCol = setCueBackgroundColors()
	placeCueLightStart(backCol[0])
	placeFrame()
		
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
	mouse		as mouse_t
	
	pulseIn = false	
	items = setClockItems(clock)	
	setSecondsInClock(clock)
	backCol = setClockColors()
	
	placeCountdownStart(clock.hour, clock.min, clock.sec, backCol[0], prop, "countdown")
	placeFrame()
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
	clearFrame()
	
endFunction
