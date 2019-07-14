/***********************************************************************************************************************

output.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Menu Functions *****************************************************

function placeMainMenu()
	
	btn as button_t[]
	
	setBackgroundColor(color[10])
	placeLogo()
	placeMenuButton(color[0])
	placeMenuText()
	btn = placeModeButtons(color[11])
	
endFunction btn

function placeLogo()
	
	spr as spriteProp_t
	
	spr.width = 14
	spr.height = -1
	spr.posX =  0.5
	spr.posY = 0.5
	
	imageSetup(sprite.logo, layer.B, spr, media.logo)
	SetSpriteColor(sprite.logo, 255, 255, 255, 255)	
	
endFunction

function placeMenuButton(col as color_t)
	
	spr as spriteProp_t
	
	spr.width = 12
	spr.height = -1
	spr.posX =  95 - (spr.width / 2)
	spr.posY = 0.5
	
	imageSetup(sprite.bMenu, layer.front, spr, media.bMenu)
	SetSpriteColor(sprite.bMenu, col.r, col.g, col.b, 255)	
	
endFunction

function placeModeButtons(col as color_t)
	
	spr		as spriteProp_t
	btn		as button_t[2]
	sTxt	as integer = false
	
	spr.width = 70
	spr.height = 10
	spr.posX =  15
	spr.posY = 30
	
	// Button Client
	imageSetup(sprite.bModeClient, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bModeClient, col.r, col.g, col.b, col.a)	
	placeButtonText(txt.bModeClient, getLangString("client", state.language), layer.B, spr, color[0], sTxt)
	btn[0] = buttonTransfer(spr, sprite.bModeClient, txt.bModeClient)
	// Button Controller
	spr.posY = spr.posY + spr.height + 2
	imageSetup(sprite.bModeCtrl, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bModeCtrl, col.r, col.g, col.b, col.a)
	placeButtonText(txt.bModeCtrl, getLangString("ctrl", state.language), layer.B, spr, color[0], sTxt)
	btn[1] = buttonTransfer(spr, sprite.bModeCtrl, txt.bModeCtrl)
	
endFunction btn

function highlightButton(spriteID as integer, highlight as integer)
	
	if highlight
		SetSpriteColorAlpha(spriteID, 32)
	else
		SetSpriteColorAlpha(spriteID, color[11].a)
	endif
	
endFunction

function clearMainMenu(btn as button_t[])
	
	clearSpriteSingle(sprite.logo)
	clearSpriteSingle(sprite.bMenu)
	
	for i = 0 to btn.length
		clearSpriteSingle(btn[i].sprID)
		clearTextSingle(btn[i].txtID)
	next i
	
	clearTextSingle(txt.modeSelect)
	clearTextSingle(txt.appID)
	
endFunction

//************************************************* Controller Functions ***********************************************

function placeControlButtons(dimmed as integer)
	
	spr 	as spriteProp_t
	sprTemp	as spriteProp_t
	btn 	as button_t[7]
	sTxt	as integer = false
	btnPP	as integer[]
	
	btnPP.insert(media.bPlay)
	btnPP.insert(media.bPause)
	
	spr.width = 70
	spr.height = 10
	spr.posX =  15
	spr.posY = 18
	
	// Button Red
	imageSetup(sprite.bCtrlWait, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bCtrlWait, color[3].r, color[3].g, color[3].b, 255)	
	placeButtonText(txt.bCtrlWait, getLangString("wait", state.language), layer.B, spr, color[0], sTxt)
	btn[0] = buttonTransfer(spr, sprite.bCtrlWait, txt.bCtrlWait)
	// Button Yellow
	spr.posY = spr.posY + spr.height + 2
	imageSetup(sprite.bCtrlReady, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bCtrlReady, color[4].r, color[4].g, color[4].b, dimmed)
	placeButtonText(txt.bCtrlReady, getLangString("ready", state.language), layer.B, spr, color[0], sTxt)
	btn[1] = buttonTransfer(spr, sprite.bCtrlReady, txt.bCtrlReady)
	// Button Green
	spr.posY = spr.posY + spr.height + 2
	imageSetup(sprite.bCtrlAction, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bCtrlAction, color[5].r, color[5].g, color[5].b, dimmed)	
	placeButtonText(txt.bCtrlAction, getLangString("action", state.language), layer.B, spr, color[0], sTxt)
	btn[2] = buttonTransfer(spr, sprite.bCtrlAction, txt.bCtrlAction)
	// Button Timer
	spr.posY = spr.posY + spr.height + 2
	imageSetup(sprite.bCtrlTimer, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bCtrlTimer, color[11].r, color[11].g, color[11].b, color[11].a)
	placeButtonText(txt.bCtrlTimer, getLangString("timer", state.language), layer.B, spr, color[0], sTxt)
	btn[3] = buttonTransfer(spr, sprite.bCtrlTimer, txt.bCtrlTimer)
	// Button Play/Pause (timer)
	spr.posY = spr.posY + spr.height + 2
	sprTemp = spr
	spr.posX = 70
	spr.width = 15
	spriteSetup(sprite.bCtrlPlayPause, layer.C, spr, btnPP)
	SetSpriteColor(sprite.bCtrlPlayPause, color[5].r, color[5].g, color[5].b, color[11].a)
	placeButtonText(txt.null, "", layer.B, spr, color[0], sTxt)
	btn[4] = buttonTransfer(spr, sprite.bCtrlPlayPause, txt.null)
	spr = sprTemp
	// Button Edit (timer)
	spr.posY = spr.posY + spr.height + 2
	spr.width = (spr.width / 2) - 1.5
	sTxt = true
	imageSetup(sprite.bCtrlEdit, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bCtrlEdit, color[11].r, color[11].g, color[11].b, color[11].a)
	placeButtonText(txt.bCtrlEdit, getLangString("edit", state.language), layer.B, spr, color[0], sTxt)
	btn[5] = buttonTransfer(spr, sprite.bCtrlEdit, txt.bCtrlEdit)
	// Button Reset (timer)
	spr.posX = spr.posX + spr.width + 3
	imageSetup(sprite.bCtrlReset, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bCtrlReset, color[11].r, color[11].g, color[11].b, color[11].a)
	placeButtonText(txt.bCtrlReset, getLangString("reset", state.language), layer.B, spr, color[0], sTxt)
	btn[6] = buttonTransfer(spr, sprite.bCtrlReset, txt.bCtrlReset)
		
endFunction btn

function highlightColorButton(spriteID as integer, highlight as integer, dimmed as integer)
	
	if highlight
		SetSpriteColorAlpha(spriteID, 256)
	else
		SetSpriteColorAlpha(spriteID, dimmed)
	endif
	
endFunction

function resetPlayPause(c ref as clock_t)
	
		SetSpriteFrame(sprite.bCtrlPlayPause, 1)
		SetSpriteColor(sprite.bCtrlPlayPause, color[5].r, color[5].g, color[5].b, color[11].a)
		c.play = false
		
endFunction

function setSpriteFramePlayPause(in as integer)
	
	if in
		SetSpriteFrame(sprite.bCtrlPlayPause, 2)
		SetSpriteColor(sprite.bCtrlPlayPause, color[3].r, color[3].g, color[3].b, color[3].a)
	else
		SetSpriteFrame(sprite.bCtrlPlayPause, 1)
		SetSpriteColor(sprite.bCtrlPlayPause, color[5].r, color[5].g, color[5].b, color[5].a)
	endif
	
endFunction

function clearControl(btn as button_t[])
	
	clearSpriteSingle(sprite.logo)
	
	for i = 0 to btn.length
		clearSpriteSingle(btn[i].sprID)
		clearTextSingle(btn[i].txtID)
	next i
			
endFunction

//************************************************* Main Menu Drop Down Functions **************************************

function placeDropDownMenu(options as string[])
	
	btn		as button_t[2]
	spr		as spriteProp_t
	sTxt	as integer = false
	col		as color_t
	
	col = color[12]
	spr.width = 74
	spr.height = 8 * (options.length + 1)
	spr.posX =  26
	spr.posY = 8
	
	imageSetup(sprite.dropBack, layer.A, spr, media.dot)
	SetSpriteColor(sprite.dropBack, col.r, col.g, col.b, col.a)
	
	spr.width = 70
	spr.height = 10
	spr.posX = 28
	spr.posY = spr.posY + 1
	
	col = color[11]
	// Button Set Language
	imageSetup(sprite.bLang, layer.front, spr, media.dot)
	SetSpriteColor(sprite.bLang, col.r, col.g, col.b, 32)
	placeButtonText(txt.bLang, getLangString(options[0], state.language), layer.top, spr, color[0], sTxt)
	btn[0] = buttonTransfer(spr, sprite.bLang, txt.bLang)
	// Button Set Client Name
	spr.posY = spr.posY + spr.height + 2
	imageSetup(sprite.bName, layer.front, spr, media.dot)
	SetSpriteColor(sprite.bName, col.r, col.g, col.b, 32)
	placeButtonText(txt.bName, getLangString(options[1], state.language), layer.top, spr, color[0], sTxt)
	btn[1] = buttonTransfer(spr, sprite.bName, txt.bName)
	
endFunction btn

function getDropDownMenuSize()
	
	out as float
	out = GetSpriteHeight(sprite.dropBack)

endFunction out

function resizeDropDownMenu(size as float)
	
	SetSpriteSize(sprite.dropBack, GetSpriteWidth(sprite.dropBack), size)
	
endFunction

function moveButton(btn as button_t, offset as integer)
		
	if GetSpriteExists(btn.sprID)
		SetSpritePosition(btn.sprID, btn.sprX, btn.sprY + offset)
		SetTextPosition(btn.txtID, btn.txtX, btn.txtY + offset)
	endIf
	
endFunction

function clearDropDownMenu(btn as button_t[])
		
	clearSpriteSingle(sprite.dropBack)
	for i = 0 to btn.length
		clearSpriteSingle(btn[i].sprID)
		clearTextSingle(btn[i].txtID)
	next i
	
endFunction

function placeSelectLanguage(posY as float)

	btn as button_t[3]
	spr as spriteProp_t
	col as color_t
	col = color[11]
	languages as integer[]
	languages.insert(media.flagNO)
	languages.insert(media.flagUK)

	spr.width = 16
	spr.height = 10
	spr.posX = 28
	spr.posY = posY
	
	// Button Prev Language
	imageSetup(sprite.bLeft, layer.front, spr, media.bLeft)
	btn[0] = buttonTransfer(spr, sprite.bLeft, nil)
	// Sprite Flag
	spr.posX = spr.posX + spr.width + 1
	spriteSetup(sprite.flag, layer.front, spr, languages)
	SetSpriteFrame(sprite.flag, state.language + 1)
	// Button Next Language
	spr.posX = spr.posX + spr.width + 1
	imageSetup(sprite.bRight, layer.front, spr, media.bRight)
	btn[1] = buttonTransfer(spr, sprite.bRight, nil)
	// Button Accept
	spr.posX = spr.posX + spr.width + 1
	imageSetup(sprite.bCheck, layer.front, spr, media.bCheck)
	btn[2] = buttonTransfer(spr, sprite.bCheck, nil)
	SetSpriteColor(sprite.bCheck, color[3].r, color[3].g, color[3].b, 128)
	
endFunction btn

function updateFlagSprite(in as integer)
	
	inc in
	setSpriteFrame(sprite.flag, in)
	
endFunction

function updateCheckSprite(in as integer)
	
	if in = state.language
		SetSpriteColor(sprite.bCheck, color[3].r, color[3].g, color[3].b, 128)
	else
		SetSpriteColor(sprite.bCheck, color[5].r, color[5].g, color[5].b, 255)
	endif
	
endFunction

function clearSelectLanguage(btn as button_t[])
	
	clearSpriteSingle(sprite.flag)
	for i = 0 to btn.length
		clearSpriteSingle(btn[i].sprID)
	next i
	
endFunction

function placeSetClientName()
	
	btn as button_t
	mt	as txtProp_t
	spr as spriteProp_t
	
	mt.startX = getSpriteX(sprite.bName)
	mt.startY = getSpriteY(sprite.bName) + GetSpriteHeight(sprite.bName) + 2
	mt.size = 7
	mt.align = 1
	
	spr.posX = 80
	spr.posY = mt.startY - 2
	spr.width = 16
	spr.height = 10
	
	placeTextInput(mt, app.name, 10)
	// Button Accept
	imageSetup(sprite.bCheck, layer.front, spr, media.bCheck)
	btn = buttonTransfer(spr, sprite.bCheck, nil)
	SetSpriteColor(sprite.bCheck, color[5].r, color[5].g, color[5].b, 255)
	
	SetEditBoxFocus(txt.editBox, 1)
	
endFunction btn



//************************************************* Cue Light Functions ************************************************

function placeCueLightStart(col as color_t)
	
	setBackgroundColor(col)
	
endFunction

function placeReadyButton(col as color_t)
	
	spr as spriteProp_t
	
	spr.width = 50
	spr.height = -1
	spr.posX = spr.width / 2
	spr.posY = 50
	
	imageSetup(sprite.bReady, layer.front, spr, media.bReady)
	SetSpritePosition(sprite.bReady, spr.posX, 50 - (getSpriteHeight(sprite.bReady) / 2))
	SetSpriteColor(sprite.bReady, col.r, col.g, col.b, 255)	
	
endFunction

function setButtonPulse(pulseIn as integer, tweenID as integer, spriteID as integer, colA as color_t, colB as color_t)
	
	duration as integer
	duration = 1
	
	if pulseIn
		// go to color 1
		clearTweenSingle(tweenID)
		setSpriteTweenColor(tweenID, spriteID, colA, duration, 5)
	else
		// go to color 2
		clearTweenSingle(tweenID)
		setSpriteTweenColor(tweenID, spriteID, colB, duration, 5)	
	endif
	
endFunction not pulseIn

function placeBackButton()
	
	spr as spriteProp_t
	
	spr.posX = 93
	spr.posY = 0.5
	spr.width = 6
	spr.height = -1
	
	imageSetup(sprite.bBack, layer.top, spr, media.bBack)
	SetSpriteColor(sprite.bBack, color[0].r, color[0].g, color[0].b, 192)
	
endFunction

function clearCueLight()
	
	clearSpriteSingle(sprite.bReady)
	setBackgroundColorDefault()
	clearTweenSingle(tween.back)
	clearFrame()
	
endFunction

//************************************************* Countdown Functions ************************************************

function placeCountdownStart(h, m, s as integer, col as color_t, prop ref as property_t)
	
	hour 	as string
	min		as string
	sec		as String
	clock 	as string

	hour = str(h)
	min	 = str(m)
	sec	 = str(s)
	
	if h <> 0 
		clock = hour + ":" + min + ":" + sec
	endif
	
	if h = 0 and m <> 0  
		clock = min + ":" + sec
	endif
	
	if h = 0 and m = 0
		clock = sec
	endif
	
	setBackgroundColor(col)
	clock = padClock(clock)
	placeStartClock(clock, prop)
	
endFunction

function getClockBackgroundChange(c as clock_t, col as color_t[])
	
	duration as integer
	
	if c.secCurrent = c.yStartSec
		duration = c.yStartSec - c.rStartSec
		clearTweenSingle(tween.back)
		setSpriteTweenColor(tween.back, sprite.back, col[1], duration, 3)		
	endif
	if c.secCurrent = c.rStartSec
		duration = c.rStartSec - c.rEndSec
		clearTweenSingle(tween.back)
		setSpriteTweenColor(tween.back, sprite.back, col[2], duration, 3)	
	endif
	if c.secCurrent = 0
		clearTweenSingle(tween.back)
	endif
	
endFunction

function setClockBackgroundPulse(pulseIn as integer, col as color_t, prop as property_t)
	
	duration as integer
	duration = 1
	
	if pulseIn
		// go to red background
		clearTweenSingle(tween.back)
		setSpriteTweenColor(tween.back, sprite.back, col, duration, 3)
		clearTweenSingle(tween.text)	
		setTextTweenColor(tween.text, txt.clock, color[prop.fontColor], duration)
	else
		// go to black background 
		clearTweenSingle(tween.back)
		setSpriteTweenColor(tween.back, sprite.back, color[1], duration, 3)	
		clearTweenSingle(tween.text)
		setTextTweenColor(tween.text, txt.clock, col, duration)
	endif
	
endFunction not pulseIn

function clearCountDown()
	
	clearTextSingle(txt.clock)
	setBackgroundColorDefault()
	clearTweenSingle(tween.back)
	clearTweenSingle(tween.text)
	clearFrame()
		
endFunction

//************************************************* Static Assets ******************************************************

function placeFrame()
	
	spr as spriteProp_t
	
	spr.posX = 0
	spr.posY = 0
	spr.width = 100
	spr.height = 100
	
	if device.isComputer
		imageSetup(sprite.frame, layer.front, spr, media.framePC)
	else
		imageSetup(sprite.frame, layer.front, spr, media.framePhone)
	endif
	
endFunction

function clearFrame()
	
	clearSpriteSingle(sprite.frame)

endFunction

//************************************************* Screen Orientation *************************************************

function getScreenTextOrientation(txtID, padVertical as integer)
	
	newOrientation	as integer
	newRotation		as integer
	fDeviceX		as float
	fDeviceY		as float
	
	newRotation = GetDirectionAngle()	
		
	if (newRotation > state.rotation + 10) or (newRotation < state.rotation - 10)
		state.rotation = newRotation
	endif
	
	//normal portrait
	if state.rotation > 135 and state.rotation < 225
		newOrientation = 1
	endif
	//reverse portrait
	if state.rotation > 315 and state.rotation < 45
		newOrientation = 2
	endif
	//normal landscape
	if state.rotation > 45 and state.rotation < 135
		newOrientation = 3
	endif
	//reverse landscape
	if state.rotation > 225 and state.rotation < 315
		newOrientation = 4
	endif
	
	if newOrientation <> state.orientation
		if newOrientation = 1 or newOrientation = 2
			state.landscape = false
		endif
		if newOrientation = 3 or newOrientation = 4
			state.landscape = true
		endif
		state.orientation = newOrientation
		updateTextOrientation(txtID, padVertical)
	endif
	
endFunction

function setScreenTextOrientation(txtID, newOrientation, padVertical as integer)
		
	if newOrientation <> state.orientation
		if newOrientation = 1 or newOrientation = 2
			state.landscape = false
		endif
		if newOrientation = 3 or newOrientation = 4
			state.landscape = true
		endif
		state.orientation = newOrientation
		updateTextOrientation(txtID, padVertical)
	endif
	
endFunction

//************************************************* Tweens Functions ***************************************************

function setSpriteTweenColor(tweenID as integer, spriteID as integer, col as color_t, duration as float, mode as integer)
	
	/* Tween Modes
	0: TweenLinear()
	1: TweenSmooth1()
	2: TweenSmooth2()
	3: TweenEaseIn1()
	4: TweenEaseIn2()
	5: TweenEaseOut1()
	6: TweenEaseOut2()
	7: TweenBounce()
	8: TweenOvershoot()	*/
	
	clearTweenSingle(tweenID)

	CreateTweenSprite(tweenID, duration)
	SetTweenSpriteRed(tweenID, GetSpriteColorRed(spriteID), col.r, mode)
	SetTweenSpriteGreen(tweenID, GetSpriteColorGreen(spriteID), col.g, mode)
	SetTweenSpriteBlue(tweenID, GetSpriteColorBlue(spriteID), col.b, mode)
	SetTweenSpriteAlpha(tweenID, GetSpriteColorAlpha(spriteID), col.a, mode)
	PlayTweenSprite(tweenID, spriteID, 0)

endFunction

function setTextTweenColor(tweenID as integer, textID as integer, col as color_t, duration as float)
	
	clearTweenSingle(tweenID)

	CreateTweenText(tweenID, duration)
	SetTweenTextRed(tweenID, GetTextColorRed(textID), col.r, TweenEaseIn1())
	SetTweenTextGreen(tweenID, GetTextColorGreen(textID), col.g, TweenEaseIn1())
	SetTweenTextBlue(tweenID, GetTextColorBlue(textID), col.b, TweenEaseIn1())
	PlayTweenText(tweenID, textID, 0)

endFunction

function updateTweenBackground()

	if GetTweenExists(tween.back)
		UpdateTweenSprite(tween.back, sprite.back, GetFrameTime())
	endif
	
endFunction

function updateTweenString(textID as integer)

	if GetTweenExists(tween.text)
		UpdateTweenText(tween.text, textID, GetFrameTime())
	endif
	
endFunction

function updateTweenSpriteReady()

	if GetTweenExists(tween.ready)
		UpdateTweenSprite(tween.ready, sprite.bReady, GetFrameTime())
	endif
	
endFunction

function clearTweenSingle(in as integer)
	
	if GetTweenExists(in)
		DeleteTween(in)
	endif
	
endFunction

//************************************************* Sprites Functions ************************************************** 

function imageSetup(sID	as integer, depth as integer, spr as spriteProp_t, iID as integer)

	if GetSpriteExists(sID) = true
		DeleteSprite(sID)
	endif

	createSprite(sID, iID)
	setSpritePosition(sID, spr.posX, spr.posY)
	setSpriteSize(sID, spr.width, spr.height)
	setSpriteColorAlpha(sID, 255)
	setSpriteDepth(sID, depth)
	setSpriteVisible(sID, 1)

endFunction

function spriteSetup(sID as integer, depth as integer, spr as spriteProp_t, imageID as integer[])
	
	if GetSpriteExists(sID) = true
		DeleteSprite(sID)
	endif

	createSprite(sID, imageID[0])
	for i = 0 to imageID.length
		AddSpriteAnimationFrame(sID, imageID[i])
	next i
	setSpritePosition(sID, spr.posX, spr.posY)
	setSpriteColorAlpha(sID, 255)
	setSpriteDepth(sID, depth)
	setSpriteFrame(sID, 1)
	setSpriteVisible(sID, 1)
	setSpriteSize(sID, spr.width, spr.height)

endFunction

function clearSpriteSingle(in as integer)
	
	if GetSpriteExists(in)
		DeleteSprite(in)
	endif
	
endFunction

function clearSprites(start as integer, stop as integer)
	
	for i = start to stop 
		clearSpriteSingle(i)
	next i
	
endFunction

function spriteColor(sprID as integer, col as integer)
	
	SetSpriteColor(sprID, color[col].r, color[col].g, color[col].b, color[col].a)
	
endFunction

function setBackgroundColor(c as color_t)

	spr as spriteProp_t
	
	spr.posX = 0
	spr.posY = 0
	spr.width = 100
	spr.height = 100
	
	if not GetSpriteExists(sprite.back)
		imageSetup(sprite.back, layer.back, spr, media.back)
	endif
	SetSpriteColor(sprite.back, c.r, c.g, c.b, c.a)
	
endFunction

function setBackgroundColorDefault()

	if GetSpriteExists(sprite.back)
		SetSpriteColor(sprite.back, color[9].r, color[9].g, color[9].b, color[9].a)
	endif
	
endFunction

//************************************************* Audio Functions ****************************************************

function click()
	
	PlaySound(sound.click, 30)
	
endFunction
