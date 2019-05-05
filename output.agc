/***********************************************************************************************************************

output.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Cue Light Functions ************************************************

function placeCueLightStart(col as color_t)
	
	setBackgroundColor(col)
	
endFunction

function clearCueLight()
	
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
		setSpriteTweenColor(tween.back, sprite.back, col[1], duration)		
	endif
	if c.secCurrent = c.rStartSec
		duration = c.rStartSec - c.rEndSec
		clearTweenSingle(tween.back)
		setSpriteTweenColor(tween.back, sprite.back, col[2], duration)	
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
		setSpriteTweenColor(tween.back, sprite.back, col, duration)
		clearTweenSingle(tween.text)	
		setTextTweenColor(tween.text, txt.clock, color[prop.fontColor], duration)
	else
		// go to black background 
		clearTweenSingle(tween.back)
		setSpriteTweenColor(tween.back, sprite.back, color[1], duration)	
		clearTweenSingle(tween.text)
		setTextTweenColor(tween.text, txt.clock, col, duration)
	endif
	
endFunction not pulseIn

function clearCountDown()
	
	textClearSingle(txt.clock)
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

function setSpriteTweenColor(tweenID as integer, spriteID as integer, col as color_t, duration as float)
	
	clearTweenSingle(tweenID)

	CreateTweenSprite(tweenID, duration)
	SetTweenSpriteRed(tweenID, GetSpriteColorRed(spriteID), col.r, TweenEaseIn1())
	SetTweenSpriteGreen(tweenID, GetSpriteColorGreen(spriteID), col.g, TweenEaseIn1())
	SetTweenSpriteBlue(tweenID, GetSpriteColorBlue(spriteID), col.b, TweenEaseIn1())
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
		UpdateAllTweens(GetFrameTime())
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

	SetSpriteColor(sprite.back, color[9].r, color[9].g, color[9].b, color[9].a)

endFunction
