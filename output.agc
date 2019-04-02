/***********************************************************************************************************************

output.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Countdown Functions ************************************************

function placeCountdownStart(h, m, s as integer, col as color_t)
	
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
	placeStartClock(clock)
	
endFunction

function getClockBackgroundChange(c as clock_t, col as color_t[])
	
	duration as integer
	
	if c.secCurrent = c.yStartSec
		duration = c.yStartSec - c.rStartSec
		if GetTweenSpriteExists(tween.back)
			DeleteTween(tween.back)
		endif
		spriteFadeColor(tween.back, sprite.back, col[1], duration)		
	endif
	if c.secCurrent = c.rStartSec
		duration = c.rStartSec - c.rEndSec
		if GetTweenSpriteExists(tween.back)
			DeleteTween(tween.back)
		endif
		spriteFadeColor(tween.back, sprite.back, col[2], duration)	
	endif
	if c.secCurrent = 0
		DeleteTween(tween.back)
	endif
	
endFunction

function updateClockBackground()

	if GetTweenSpriteExists(tween.back)
		UpdateAllTweens(GetFrameTime())
	endif
	
endFunction

function clearCountDown()
	
	textClearSingle(txt.clock)
	setBackgroundColorDefault()
	DeleteTween(tween.back)
	
endFunction

//************************************************* Set Screen Orientation *********************************************

function getScreenOrientation()
	
	newOrientation	as integer
	fDeviceX		as float
	fDeviceY		as float
	
	newOrientation = GetOrientation()
	
	if newOrientation <> state.orientation
		if newOrientation = 1 or newOrientation = 2
			fDeviceX = device.width
			fDeviceY = device.height
			device.aspect = fDeviceX / fDeviceY
			SetScreenResolution(device.width, device.height)
			SetDisplayAspect(device.aspect)
			landscape = false
		endif
		if newOrientation = 3 or newOrientation = 4
			fDeviceX = device.width
			fDeviceY = device.height
			device.aspect = fDeviceY / fDeviceX
			SetScreenResolution(device.height, device.width)
			SetDisplayAspect(device.aspect)
			landscape = true
		endif
		state.orientation = newOrientation
		state.landscape = landscape
	endif
endFunction

//************************************************* Chores Functions ***************************************************

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

function spriteSetup(sID as integer, depth as integer, spr as spriteProp_t, iID0 as integer, iID1 as integer)
	
	if GetSpriteExists(sID) = true
		DeleteSprite(sID)
	endif

	createSprite(sID, iID0)
	AddSpriteAnimationFrame(sID, iID0)
	AddSpriteAnimationFrame(sID, iID1)
	setSpritePosition(sID, spr.posX, spr.posY)
	setSpriteColorAlpha(sID, 256)
	setSpriteDepth(sID, depth)
	setSpriteFrame(sID, 1)
	setSpriteVisible(sID, 1)
	setSpriteSize(sID, spr.width, -1)

endFunction


function spriteClearSingle(in as integer)
	
	if GetSpriteExists(in)
		DeleteSprite(in)
	endif
	
endFunction

function spriteClear(start as integer, stop as integer)
	
	for i = start to stop 
		spriteClearSingle(i)
	next i
	
endFunction

function spriteColor(sprID as integer, col as integer)
	
	SetSpriteColor(sprID, color[col].r, color[col].g, color[col].b, color[col].a)
	
endFunction

function spriteFadeColor(tweenID as integer, spriteID as integer, col as color_t, duration as float)

        CreateTweenSprite(tweenID, duration)
        SetTweenSpriteRed(tweenID, GetSpriteColorRed(spriteID), col.r, TweenEaseIn1())
        SetTweenSpriteGreen(tweenID, GetSpriteColorGreen(spriteID), col.g, TweenEaseIn1())
        SetTweenSpriteBlue(tweenID, GetSpriteColorBlue(spriteID), col.b, TweenEaseIn1())
        PlayTweenSprite(tweenID, spriteID, 0)

endFunction

function setBackgroundColor(c as color_t)

	SetSpriteColor(sprite.back, c.r, c.g, c.b, c.a)

endFunction

function setBackgroundColorDefault()

	SetSpriteColor(sprite.back, color[9].r, color[9].g, color[9].b, color[9].a)

endFunction

function setBackground(c as integer)
	
	spr as spriteProp_t
	
	spr.posX = 0
	spr.posY = 0
	spr.width = 100
	spr.height = 100
	
	imageSetup(sprite.back, layer.back, spr, media.back)
	SetSpriteColor(sprite.back, color[c].r, color[c].g, color[c].b, color[c].a)

endFunction
