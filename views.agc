/***********************************************************************************************************************

views.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Main Menu View *****************************************************

function mainMenuView(lanServer ref as lanServer_t)

	quit		as integer = false
	keyTimer	as timer_t
	mouse		as mouse_t
	spriteID	as integer
	button		as button_t[]
	mode		as mode_t
	lanHost		as network_t

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
			highlightButtonGrey(spriteID, state.buttonHit)
			modeSwitch(mode.enum, button, lanServer, lanHost)
			placeMainMenu()
		endif
		sync()
	until quit

endFunction

//************************************************* Main Menu Update ***************************************************

function keyPressed(spriteID)

	keyTimer as timer_t

	state.buttonHit = true
	highlightButtonGrey(spriteID, state.buttonHit)
	keyTimer = setTimer(50)

endFunction keyTimer

//************************************************* Main Menu Drop Down View *******************************************

function dropDownView()

	quit		as integer = false
	mouse		as mouse_t
	options		as string[3] = ["setLang", "setName", "setMute"]
	button		as button_t[3]
	langBtn		as button_t[4]
	nameBtn		as button_t
	spriteID	as integer
	ddHeight 	as float
	offset		as integer = 12
	tempLang	as integer
	nameSet		as integer = false
	
	if app.muted
		options[2] = "setMute"
	else
		options[2] = "setSound"
	endif

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
			if button[2].active
				if app.muted
					options[2] = "setSound"
					app.muted = false
					click()
				else
					options[2] = "setMute"
					app.muted = true
				endif
				button[2].active = false
				updateButtonText(button[2].txtID, getLangString(options[2], state.language))
			endif
		endif
		//testDevice()	
		sync()
	until quit

endFunction

//************************************************* Main Menu Drop Down Update *****************************************

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
			moveButton(button[2], 0)
			clearSelectLanguage(langBtn)
			button[0].active = false
		elseif button[0].active = false and button[1].active = false
			resizeDropDownMenu(ddHeight + offset)
			moveButton(button[1], offset)
			moveButton(button[2], offset)
			langBtn = placeSelectLanguage(button[1].sprY)
			button[0].active = true
		endif
		click()
	endCase
	// Change Client Name
	case button[1].sprID
		if button[1].active
			resizeDropDownMenu(ddHeight)
			moveButton(button[2], 0)
			clearTextInput(nameBtn.sprID)
			button[1].active = false
		elseif button[1].active = false and button[0].active = false
			resizeDropDownMenu(ddHeight + offset)
			moveButton(button[2], offset)
			nameBtn = placeSetClientName()
			button[1].active = true
		endif
		click()
	endCase
	case button[2].sprID
		button[2].active = true
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

//************************************************* Controller View ****************************************************

function controlView(net ref as network_t)

	quit 		as integer
	keyTimer	as timer_t
	button		as button_t[]
	dimmed		as integer = 80
	altButton	as integer = false
	clock		as clock_t
	clockTimer	as timer_t
	clockCol	as color_t[2]
	prop		as property_t
	btnOk		as button_t
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
	
	updateStatusText(postAppUpdate())
	serverTimer = setTimer(1000)
	
	repeat
		sync()
	until getTimer(serverTimer)
	
	clearTextSingle(txt.status)
	
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
			resetGlow = handleControlButtonsUpdate(mode, btnOK, resetGlow, clock.binary, cue, mutedGreen)
		endif

		if btnOK.active
			timeSet = handleChangeClockEdit(mode.spriteID, btnOK, clock)
			if timeSet
				handleChangeClockEditDone(btnOK, clock, color[prop.fontColor])
				timeSet = false
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
	
	clearControl(button)

endFunction

//************************************************* Controller View Update  ********************************************

function handleControlButtonsUpdate(mode ref as mode_t, btnOK ref as button_t, resetGlow as integer, binary as integer, cue ref as cueLight_t, mutedGreen as color_t)
	
	mode.altButton = false
	highlightButtonGrey(mode.spriteID, false)
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
	case enum.text
		if cue.textOn
			highlightButtonColor(sprite.bCtrlText, mutedGreen, true)
		else
			highlightButtonColor(sprite.bCtrlText, mutedGreen, false)
		endif
	endCase
	case enum.fade
		cue.fadeOn = not cue.fadeOn
		if cue.fadeOn
			highlightButtonColor(sprite.bCtrlFade, mutedGreen, true)
		else
			highlightButtonColor(sprite.bCtrlFade, mutedGreen, false)
		endif
	endCase
	case enum.binary
		if binary
			highlightButtonColor(sprite.bCtrlBinary, mutedGreen, true)
		else
			highlightButtonColor(sprite.bCtrlBinary, mutedGreen, false)
		endif
	endCase
	endSelect

endFunction resetGlow

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

function handleChangeClockEditDone(btnOK ref as button_t, clock ref as clock_t, col as color_t)
	
	clearTextInput(btnOK.sprID)
	hideCtrlTopButtons(false)
	btnOK.active = false
	updateClockText(clock, 3)
	updateTextColor(txt.clock, col)
	
endFunction

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
		highlightButtonGrey(sprite.bCtrlTimer, false)
		resetPlayPause(clock, dimmed)
	endCase
	case enum.ready
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, true, dimmed)
		highlightColorButton(sprite.bCtrlAction, false, dimmed)
		highlightButtonGrey(sprite.bCtrlTimer, false)
		resetPlayPause(clock, dimmed)
	endCase
	case enum.action
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, false, dimmed)
		highlightColorButton(sprite.bCtrlAction, true, dimmed)
		highlightButtonGrey(sprite.bCtrlTimer, false)
		resetPlayPause(clock, dimmed)
	endCase
	case enum.countdown
		highlightColorButton(sprite.bCtrlWait, false, dimmed)
		highlightColorButton(sprite.bCtrlReady, false, dimmed)
		highlightColorButton(sprite.bCtrlAction, false, dimmed)
		highlightButtonGrey(sprite.bCtrlTimer, true)
		setSpriteFramePlayPause(false)
	endCase
	case enum.playPause
		setSpriteFramePlayPause(clock.play)
	endCase
	case enum.edit
		highlightButtonGrey(sprite.bCtrlEdit, true)
	endCase
	case enum.reset
		highlightButtonGrey(sprite.bCtrlReset, true)
		setSpriteFramePlayPause(clock.play)
	endCase
	case enum.binary
		// more here possibly
	endCase
	endSelect

endFunction

//************************************************* Cue Controller Switching *******************************************

function cueController(lanServer as lanServer_t)
	
	quit		as integer
	net			as network_t
	netMsg		as message_t
	serverTimer	as timer_t
	netActive	as integer
	button		as button_t[]
	keyTimer	as timer_t
	mode		as mode_t
	
	if app.name = ""
		app.name = "Client-"
	endif
	
	if device.isComputer
		app.mode = "clientComp"
	else
		app.mode = "clientSP"
	endif
	
	updateStatusText(postAppUpdate())
	serverTimer = setTimer(1000)
	
	repeat
		sync()
	until getTimer(serverTimer)
	
	clearTextSingle(txt.status)

	netActive = joinHost(net, lanServer)

	if netActive
		button = placeConnectClientButtons(color[11])
		repeat
			// gets if mode = enum.retry or enum.abort
			handleConnectClientButtons(mode, keyTimer)
			placeStatusText('Waiting for response\nfrom server...')
			//testNetwork(net)
			netMsg = receiveServerAck(net)
			if mode.enum = enum.retry
				CloseNetwork(net.id)
				joinHost(net, lanServer)
			endif
			sync()
		until netMsg.mode = enum.cue or netMsg.mode = enum.countdown
		clearTextSingle(txt.status)
		clearConnect(button)
	else
		quit = true
	endif
	
	if mode.enum = enum.retry or mode.enum = enum.abort
		// do stuff
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
		case enum.retry
			// do stuff
		endCase
		case enum.abort
			quit = true
		endCase
		endSelect
	until quit

	disconnectHost(net)

endFunction

function handleConnectClientButtons(mode ref as mode_t, keyTimer ref as timer_t)
	
	mouse	as mouse_t
	
	mouse = updateMouse()
	if mouse.hit
		mouse = getMouseHit(mouse)
		mode.spriteID = mouse.spriteID
		select mode.spriteID
		case sprite.bClientRetry
			keyTimer = keyPressed(sprite.bClientRetry)
			click()
			mode.enum = enum.retry
		endCase
		case sprite.bClientAbort
			keyTimer = keyPressed(sprite.bClientAbort)
			click()
			mode.enum = enum.abort
		endCase
		endSelect
	endif
	// reset button highlight
	if getTimer(keyTimer) and state.buttonHit
		state.buttonHit = false
		highlightButtonGrey(mode.spriteID, state.buttonHit)
		//modeSwitch(mode.enum, button, lanServer, lanHost)
		//placeMainMenu()
	endif
	
endFunction

//************************************************* Cue Light View *****************************************************

function cueLightView(net ref as network_t, netMsg as message_t)

	quit		as integer
	cue			as cueLight_t
	backCol		as color_t[2]
	time		as timer_t
	pulseIn		as integer = false
	mouse		as mouse_t
	prop		as property_t
	textActive	as integer = false
	
	prop.baseSize = 0.8
	prop.font = media.fontC
	prop.fontColor = 1
	prop.fontAlpha = 192
	prop.orientation = 1
	prop.padVertical = 0

	time = setTimer(1000)
	backCol = setCueBackgroundColors()
	cue.fromJSON(netMsg.inJSON)
	setBackgroundColor(backCol[cue.colorStep])
	placeFrame()

	repeat
		netMsg = receiveCueLAN(net)

		if netMsg.mode = enum.quit or netMsg.mode = enum.countdown or netMsg.mode = enum.close
			quit = true
		elseif netMsg.new
			cue = cueLightViewUpdate(netMsg, backCol)
		endif
		
		if GetRawKeyReleased(escKey)
			netMsg.mode = enum.quit
			quit = true
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
		
		textActive = cueLightTextUpdate(cue, textActive, prop)
		updateTweenBackground()		
		//testCueRaw(cue)
		//testNetwork(net)
		sync()
	until quit

	clearCueLight()

endFunction netMsg

//************************************************* Cue Light Update ***************************************************

function cueLightViewUpdate(netMsg as message_t, backCol as color_t[])
	
	cue as cueLight_t
	
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
	
	if cue.language <> state.language
		state.language = cue.language
	endif
	
endFunction cue

function cueLightTextUpdate(cue as cueLight_t, textActive as integer, prop ref as property_t)
	
	if cue.textOn and textActive = false
		placeCueText(cue.colorStep, prop)
		textActive = true
	endif
	if cue.textOn = false and textActive
		clearTextSingle(txt.cueStep)
		textActive = false
	endif
	if cue.textOn and textActive
		if device.isComputer
			if getOrientationChange(prop)
				setScreenTextOrientation(txt.cueStep, prop.orientation, prop.padVertical)
			endif
		else
			getScreenTextOrientation(txt.cueStep, prop.padVertical)
		endif
		updateCueText(cue.colorStep)
	endif
	
endFunction textActive

//************************************************* Countdown View *****************************************************

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
			items = countdownViewUpdate(netMsg, clock, backCol[0], prop)
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
		//testClockRaw(clock)
		//testNetwork(net)
		sync()
	until quit

	clearCountDown()
	clearFrame()

endFunction netMsg

//************************************************* Countdown Update ***************************************************

function countdownViewUpdate(netMsg as message_t, clock ref as clock_t, backCol as color_t, prop ref as property_t)
	
	items as integer
	
	clock.fromJSON(netMsg.inJSON)
	items = setClockItems(clock)
	updateClockText(clock, items)
	if clock.secCurrent = clock.secTotal
		placeCountdownStart(clock, backCol, prop, enum.countdown)
	endif
	if netMsg.subMode = enum.reset
		resetCountdown(backCol, prop)
	endif
	
endFunction items
