/***********************************************************************************************************************

output.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Menu Functions *****************************************************

function placeLogo()
	
	spr as spriteProp_t
	
	spr.width = 14
	spr.height = -1
	spr.posX =  0.5
	spr.posY = 0.5
	
	imageSetup(sprite.logo, layer.B, spr, media.logo)
	//SetSpritePosition(sprite.logo, spr.posX, spr.posY)
	SetSpriteColor(sprite.logo, 255, 255, 255, 255)	
	
endFunction

function placeMenuButton(col as color_t)
	
	spr as spriteProp_t
	
	spr.width = 12
	spr.height = -1
	spr.posX =  95 - (spr.width / 2)
	spr.posY = 0.5
	
	imageSetup(sprite.bMenu, layer.front, spr, media.bMenu)
	//SetSpritePosition(sprite.bMenu, spr.posX, spr.posY)
	SetSpriteColor(sprite.bMenu, col.r, col.g, col.b, 255)	
	
endFunction

function placeModeButtons(col as color_t)
	
	spr as spriteProp_t
	btn as button_t[2]
	
	spr.width = 70
	spr.height = 10
	spr.posX =  15
	spr.posY = 30
	
	// Button Client
	imageSetup(sprite.bModeClient, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bModeClient, col.r, col.g, col.b, col.a)	
	placeButtonText(txt.bModeClient, getLangString("bClient", state.language), layer.B, spr, color[0])
	btn[0] = buttonTransfer(spr, sprite.bModeClient, txt.bModeClient)
	// Button Controller
	spr.posY = spr.posY + spr.height + 2
	imageSetup(sprite.bModeCtrl, layer.C, spr, media.dot)
	SetSpriteColor(sprite.bModeCtrl, col.r, col.g, col.b, col.a)
	placeButtonText(txt.bModeCtrl, getLangString("bCtrl", state.language), layer.B, spr, color[0])
	btn[1] = buttonTransfer(spr, sprite.bModeCtrl, txt.bModeCtrl)
	
endFunction btn

function placeDropDownMenu(options as string[])
	
	btn as button_t[2]
	spr as spriteProp_t
	col as color_t
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
	placeButtonText(txt.bLang, getLangString(options[0], state.language), layer.top, spr, color[0])
	btn[0] = buttonTransfer(spr, sprite.bLang, txt.bLang)
	// Button Set Client Name
	spr.posY = spr.posY + spr.height + 2
	imageSetup(sprite.bName, layer.front, spr, media.dot)
	SetSpriteColor(sprite.bName, col.r, col.g, col.b, 32)
	placeButtonText(txt.bName, getLangString(options[1], state.language), layer.top, spr, color[0])
	btn[1] = buttonTransfer(spr, sprite.bName, txt.bName)
	
endFunction btn

function expandDropDownMenu(ddHeight as float)
	
	SetSpriteSize(sprite.dropBack, GetSpriteWidth(sprite.dropBack), ddHeight)
	
endFunction

function shrinkDropDownMenu(ddHeight as float)
	
	SetSpriteSize(sprite.dropBack, GetSpriteWidth(sprite.dropBack), ddHeight)
	
endFunction

function moveButtonDown(btn as button_t, offset as integer)
		
	if GetSpriteExists(btn.sprID)
		SetSpritePosition(btn.sprID, btn.sprX, btn.sprY + offset)
		SetTextPosition(btn.txtID, btn.txtX, btn.txtY + offset)
	endIf
	
endFunction

function moveButtonUp(btn as button_t)
		
	if GetSpriteExists(btn.sprID)
		SetSpritePosition(btn.sprID, btn.sprX, btn.sprY)
		SetTextPosition(btn.txtID, btn.txtX, btn.txtY)
	endIf
	
endFunction

function clearDropDownMenu(btn as button_t[])
		
	clearSpriteSingle(sprite.dropBack)
	for i = 0 to btn.length
		clearSpriteSingle(btn[i].sprID)
		clearTextSingle(btn[i].txtID)
	next i
	click()
	
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
	btn[0] = buttonTransferNoText(spr, sprite.bLeft)
	// Sprite Flag
	spr.posX = spr.posX + spr.width + 1
	spriteSetup(sprite.flag, layer.front, spr, languages)
	SetSpriteFrame(sprite.flag, state.language + 1)
	// Button Next Language
	spr.posX = spr.posX + spr.width + 1
	imageSetup(sprite.bRight, layer.front, spr, media.bRight)
	btn[1] = buttonTransferNoText(spr, sprite.bRight)
	// Button Accept
	spr.posX = spr.posX + spr.width + 1
	imageSetup(sprite.bCheck, layer.front, spr, media.bCheck)
	btn[2] = buttonTransferNoText(spr, sprite.bCheck)
	
endFunction btn

function clearSelectLanguage(btn as button_t[])
	
	clearSpriteSingle(sprite.flag)
	for i = 0 to btn.length
		clearSpriteSingle(btn[i].sprID)
	next i
	
endFunction

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

function clearCueLight()
	
	clearSpriteSingle(sprite.bReady)
	setBackgroundColorDefault()
	clearTweenSingle(tween.back)
	
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

function placeBackButton()
	
	spr as spriteProp_t
	
	spr.posX = 30
	spr.posY = 30
	spr.width = 10
	spr.height = -1
	
	imageSetup(sprite.bBack, layer.C, spr, media.bBack)
	SetSpriteColor(sprite.bBack, color[8].r, color[8].g, color[8].b, color[8].a)
	
endFunction

//************************************************* Tweens Functions ***************************************************

function setSpriteTweenColor(tweenID as integer, spriteID as integer, col as color_t, duration as float, mode as integer)
	
	/* 
	** Tween Modes **
	0: TweenLinear()
	1: TweenSmooth1()
	2: TweenSmooth2()
	3: TweenEaseIn1()
	4: TweenEaseIn2()
	5: TweenEaseOut1()
	6: TweenEaseOut2()
	7: TweenBounce()
	8: TweenOvershoot()
	*/
	
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
	
	PlaySound(sound.click, 50)
	
endFunction
