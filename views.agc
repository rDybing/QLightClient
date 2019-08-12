/***********************************************************************************************************************

views.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Main Menu Functions ************************************************

function mainMenuView(lanServer ref as lanServer_t)

	quit		as integer = false
	keyTimer	as timer_t
	mouse		as mouse_t
	spriteID	as integer
	button		as button_t[]
	mode		as mode_t

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
				click()
				mode.enum = enum.client
			endCase
			case sprite.bModeCtrl
				keyTimer = keyPressed(sprite.bModeCtrl)
				click()
				mode.enum = enum.ctrl
			endCase
			endSelect
		endif
		// reset button highlight
		if getTimer(keyTimer) and state.buttonHit
			state.buttonHit = false
			highlightButton(spriteID, state.buttonHit)
			modeSwitch(mode.enum, button, lanServer)
			placeMainMenu()
		endif
		sync()
	until quit

endFunction

function keyPressed(spriteID)

	keyTimer as timer_t

	state.buttonHit = true
	highlightButton(spriteID, state.buttonHit)
	keyTimer = setTimer(50)

endFunction keyTimer

//************************************************* Controller Functions ***********************************************

function controlView()

	quit 		as integer
	keyTimer	as timer_t
	button		as button_t[]
	dimmed		as integer = 48
	altButton	as integer = false
	clock		as clock_t
	clockTimer	as timer_t
	clockCol	as color_t[2]
	prop		as property_t
	btnOk		as button_t
	net			as network_t
	cue			as cueLight_t
	mode		as mode_t
	clientTimer	as timer_t
	timeSet		as integer = false
	pulseTimer	as timer_t
	resetGlow	as integer = false
	pulseReset	as integer = true
	mutedGreen	as color_t
	serverTimer	as timer_t
		
	state.mode = enum.cue
	cue = initCue()	
	setBackgroundColor(color[10])
	placeLogo()
	button = placeControlButtons(dimmed)

	prop.baseSize = 7.5
	prop.font = media.fontC
	prop.fontColor = 5
	prop.fontAlpha = 192

	clock = loadClockTimer()
	clockCol = setClockColors()
	setSecondsInClock(clock)
	placeCountdownStart(clock, color[5], prop, enum.ctrl)

	mutedGreen = color[5]
	mutedGreen.a = dimmed

	if app.name = ""
		app.name = "Ctrl-"
	endif

	app.mode = "ctrlLite"
	
	updateServerText(updateAppInfo())
	serverTimer = setTimer(1000)
	
	repeat
		sync()
	until getTimer(serverTimer)
	
	clearTextSingle(txt.server)
	
	initHostLAN(net)

	clientTimer = setTimer(500)
	pulseTimer = setTimer(1000)

	repeat
		if GetRawKeyReleased(escKey)
			quit = true
		endif
		
		handleControlButtons(mode, clock, clockCol, clockTimer, keyTimer, prop.fontAlpha)

		if state.buttonHit
			click()
			state.buttonHit = false
			changeButtonHighlight(mode.enum, dimmed, clock)
			if mode.emit
				if state.mode = enum.cue or state.mode = enum.countdown
					networkEmitter(net, mode.enum, cue, clock)
				endif
				mode.emit = false
			endif
		endif

		if getTimer(keyTimer) and mode.altButton
			mode.altButton = false
			highlightButton(mode.spriteID, false)
			select mode.enum
			case enum.edit
				hideCtrlTopButtons(true)
				btnOK = placeSetClockEdit()
			endCase
			case enum.reset
				if resetGlow
					resetGlow = false
					spriteColor(sprite.bCtrlReset, 11)
				endif
			endCase
			case enum.audio
				cue.audioOn = not cue.audioOn
				if cue.audioOn
					updateButtonText(txt.bCtrlAudio, getLangString("audioOn", state.language))
				else
					updateButtonText(txt.bCtrlAudio, getLangString("audioOff", state.language))
				endif
			endCase
			case enum.fade
				cue.fadeOn = not cue.fadeOn
				if cue.fadeOn
					updateButtonText(txt.bCtrlFade, getLangString("fadeOn", state.language))
				else
					updateButtonText(txt.bCtrlFade, getLangString("fadeOff", state.language))
				endif
			endCase
			endSelect
		endif

		if btnOK.active
			timeSet = handleChangeClockEdit(mode.spriteID, btnOK, clock)
			if timeSet
				clearTextInput(btnOK.sprID)
				hideCtrlTopButtons(false)
				timeSet = false
				btnOK.active = false
				updateClockText(clock, 3)
				updateTextColor(txt.clock, color[prop.fontColor])
				resetGlow = true
			endif
		endif

		if clock.play 
			if getTimer(clockTimer)
				updateCtrlClock(clock, clockCol)
				networkEmitter(net, enum.countdown, cue, clock)
			endif
			updateTweenString(txt.clock)
		endif

		if getTimer(clientTimer)
			receiveClientsConnect(net, state.mode, cue, clock)
			receiveClientsDisconnect(net)
		endif
		
		if resetGlow
			if getTimer(pulseTimer)
				pulseReset = setButtonPulse(pulseReset, tween.button, sprite.bCtrlReset, mutedGreen, color[11])
			endif
			updateTweenSpriteButton(tween.button, sprite.bCtrlReset)
		endif

		receiveClientsMessage(net)

		//testClockRaw(clock)
		//testNetwork(net)
		sync()
	until quit
	
	networkEmitter(net, enum.close, cue, clock)
	clearControl(button)

endFunction

function handleChangeClockEdit(spriteID as integer, nameBtn ref as button_t, c ref as clock_t)

	out as integer = false

	if spriteID = nameBtn.sprID
		click()
		c.output = getEditBoxInput()
		setClockFromInput(c)
		saveClockTimer(c)
		out = true
	endif

endFunction out

function updateCtrlClock(c ref as clock_t, cc as color_t[])

	if c.secCurrent <> 0
		updateClockTime(c, true)
		getClockCtrlChange(c, cc)
		updateClockText(c, 3)
	endif

endFunction

function resetCtrlClock(c ref as clock_t, cc as color_t[], alpha as integer)

	setClockCtrlReset(c, cc[0], alpha)
	updateClockText(c, 3)

endFunction

function changeButtonHighlight(in as integer, dimmed as integer, clock ref as clock_t)

	select in
	case enum.wait
		highlightColorButton(sprite.bCtrlWait, true, dimmed)
		highlightColorButton(sprite.bCtrlReady, false, dimmed)
		highlightColorButton(sprite.bCtrlAction, false, dimmed)
		highlightButton(sprite.bCtrlTimer, false)
		resetPlayPause(clock)
	endCase
	case enum.ready
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, true, dimmed)
		highlightColorButton(sprite.bCtrlAction, false, dimmed)
		highlightButton(sprite.bCtrlTimer, false)
		resetPlayPause(clock)
	endCase
	case enum.action
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, false, dimmed)
		highlightColorButton(sprite.bCtrlAction, true, dimmed)
		highlightButton(sprite.bCtrlTimer, false)
		resetPlayPause(clock)
	endCase
	case enum.countdown
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, false, dimmed)
		highlightColorButton(sprite.bCtrlAction, false, dimmed)
		highlightButton(sprite.bCtrlTimer, true)
		setSpriteFramePlayPause(false)
	endCase
	case enum.playPause
		setSpriteFramePlayPause(clock.play)
	endCase
	case enum.edit
		highlightButton(sprite.bCtrlEdit, true)
	endCase
	case enum.reset
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
	langBtn		as button_t[4]
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

function handleMainDropDown(spriteID as integer, button ref as button_t[], langBtn ref as button_t[], nameBtn ref as button_t, ddHeight as float, offset as integer, quit as integer)

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

//************************************************* Cue Controller Functions *******************************************

function cueController(lanServer as lanServer_t)

	quit		as integer
	net			as network_t
	netMsg		as message_t
	serverTimer	as timer_t
	netActive	as integer

	if app.name = ""
		app.name = "Client-"
	endif
	
	if device.isComputer
		app.mode = "clientComp"
	else
		app.mode = "clientSP"
	endif
	
	updateServerText(updateAppInfo())
	serverTimer = setTimer(1000)
	
	repeat
		sync()
	until getTimer(serverTimer)
	
	clearTextSingle(txt.server)

	netActive = joinHost(net, lanServer)

	if netActive
		repeat
			print("waiting for response from server...")
			testNetwork(net)
			netMsg = receiveServerAck(net)
			sync()
		until netMsg.mode = enum.cue or netMsg.mode = enum.countdown
	else
		quit = true
	endif
	
	repeat
		select netMsg.mode
		case enum.cue
			netMsg = cueLightView(net, netMsg)
		endCase
		case enum.countdown
			netMsg = countdownView(net, netMsg)
		endCase
		case enum.quit
			quit = true
		endCase
		case enum.close
			quit = true
		endCase
		endSelect
	until quit

	disconnectHost(net)

endFunction

//************************************************* Cue Light Functions ************************************************

function cueLightView(net ref as network_t, netMsg as message_t)

	quit		as integer
	cue			as cueLight_t
	backCol		as color_t[2]
	time		as timer_t
	pulseIn		as integer = false
	mouse		as mouse_t

	time = setTimer(1000)
	backCol = setCueBackgroundColors()
	cue.fromJSON(netMsg.inJSON)
	setBackgroundColor(backCol[cue.colorStep])
	placeFrame()

	repeat
		// get network message
		netMsg = receiveCueLAN(net)

		if netMsg.mode = enum.quit or netMsg.mode = enum.countdown or netMsg.mode = enum.close
			quit = true
		else
			if GetRawKeyReleased(escKey)
				netMsg.mode = enum.quit
				quit = true
			endif
			// if new message from server
			if netMsg.new
				cue.fromJSON(netMsg.inJSON)
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
			updateTweenSpriteButton(tween.ready, sprite.bReady)
		endif
		updateTweenBackground()		
		//testCueRaw(cue)
		//testNetwork(net)
		sync()
	until quit

	clearCueLight()

endFunction netMsg
 
//************************************************* Countdown Timer ****************************************************

function countdownView(net ref as network_t, netMsg as message_t)

	quit		as integer
	items		as integer
	backCol		as color_t[2]
	pulseIn		as integer
	mouse		as mouse_t
	clock		as clock_t
	prop		as property_t
	play 		as integer
	pulseTimer	as timer_t
	
	prop.baseSize = 0.9
	prop.font = media.fontC
	prop.fontColor = 1
	prop.fontAlpha = 192
	prop.orientation = 1

	pulseIn = false
	clock.fromJSON(netMsg.inJSON)
	secOld = clock.secCurrent	
	items = setClockItems(clock)
	setSecondsInClock(clock)
	backCol = setClockColors()

	placeCountdownStart(clock, backCol[0], prop, enum.countdown)
	placeFrame()

	pulseTimer = setTimer(2000)

	repeat
		netMsg = receiveCueLAN(net)
		
		if netMsg.mode = enum.quit or netMsg.mode = enum.cue or netMsg.mode = enum.close
			quit = true
		elseif netMsg.new
			clock.fromJSON(netMsg.inJSON)
			items = setClockItems(clock)
			updateClockText(clock, items)
			if clock.secCurrent = clock.secTotal
				placeCountdownStart(clock, backCol[0], prop, enum.countdown)
			endif
			if netMsg.subMode = enum.reset
				resetCountdown(backCol[0], prop)
			endif
		endif

		if GetRawKeyReleased(escKey)
			netMsg.mode = enum.quit
			quit = true
		endif

		if device.isComputer
			if getOrientationChange(prop)
				setScreenTextOrientation(txt.clock, prop.orientation, prop.padVertical)
			endif
		else
			getScreenTextOrientation(txt.clock, prop.padVertical)
		endif
		if clock.secCurrent = 0
			if getTimer(pulseTimer)
				pulseIn = setClockBackgroundPulse(pulseIn, backCol[2], prop)
			endif
		else
			updateClockTime(clock, false)
			getClockBackgroundChange(clock, backCol)
			updateClockText(clock, items)
		endif
		updateTweenBackground()
		updateTweenString(txt.clock)
		//endif
		testClockRaw(clock)
		testNetwork(net)
		sync()
	until quit

	clearCountDown()
	clearFrame()

endFunction netMsg
