/***********************************************************************************************************************

output.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Countdown Functions ************************************************

function placeCountdownStart(h, m, s as integer)
	
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
	
	clock = padClock(clock)
	placeStartClock(clock)
	
endFunction

function clearCountDown()
	
	textClearSingle(txt.clock)
	
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

function spriteFadeColor(spriteID as integer, colID as integer, duration as float)

        tweenFade = CreateTweenSprite(duration)
        SetTweenSpriteRed(tweenFade, GetSpriteColorRed(spriteID), color[colID].r, TweenEaseOut1())
        SetTweenSpriteGreen(tweenFade, GetSpriteColorGreen(spriteID), color[colID].g, TweenEaseOut1())
        SetTweenSpriteBlue(tweenFade, GetSpriteColorBlue(spriteID), color[colID].b, TweenEaseOut1())
        PlayTweenSprite(tweenFade, spriteID, 0)

endFunction tweenFade
