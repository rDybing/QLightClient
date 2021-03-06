/***********************************************************************************************************************

input.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Startup Functions **************************************************

function placeStartupText(msg as string)
	
	mt		as txtProp_t
	msgOut	as string
	posY	as float
	
	if device.isComputer
		posY = 70
	else 
		posY = 65
	endif
	
	clearText(txt.startup, txt.startup + 1)
	
	setFontProperties(color[0], 255, media.fontA, 4)	
	
	mt = setTextProperties(mt, 50, posY, 1)
	mt.layer = layer.B
	
	msgOut = GetStringToken(msg, ":", 2)
	
	createText(txt.startup, msgOut)
	textDraw(txt.startup, mt)
	
	mt = setTextProperties(mt, 50, posY + 10, 1)
	
	setFontProperties(color[0], 255, media.fontA, 3)	
	createText(txt.startup + 1, getLangString("continue", state.language))
	textDraw(txt.startup + 1, mt)
	
endFunction

function updateStatusText(msg as string)
	
	SetTextString(txt.status, msg)
	
endFunction

//************************************************* Menu Functions *****************************************************

function placeMenuText()

	mt as txtProp_t

	mt.startX = 50
	mt.startY = 13
	mt.align = 1
	mt.size = 6
	mt.layer = layer.B

	setFontProperties(color[0], 255, media.fontA, mt.size)
	CreateText(txt.modeSelect, getLangString("selectMode", state.language))
	textDraw(txt.modeSelect, mt)

	mt.startY = 50

	CreateText(txt.appID, "AppID: " + '\n' + app.id)
	textDraw(txt.appID, mt)

endFunction

function placeButtonText(txtId as integer, txtStr as string, layer as integer, spr as spriteProp_t, col as color_t, smallText as integer)

	mt as txtProp_t
	sizeDec as float = 2

	mt.startX = spr.posX + (spr.width / 2)
	mt.startY = spr.posY + 0.5
	mt.align = 1
	if smallText
		sizeDec = 3.25
		mt.startY = mt.startY + 0.75
	endif
	mt.size = spr.height - sizeDec
	mt.layer = layer

	setFontProperties(col, 255, media.fontA, mt.size)
	CreateText(txtId, txtStr)
	textDraw(txtId, mt)

endFunction

function updateButtonText(txtID as integer, in as string)

	SetTextString(txtID, in)

endFunction

function updateTextColor(txtID as integer, col as color_t)
	
	SetTextColor(txtID, col.r, col.g, col.b, col.a)
	
endFunction

//************************************************* Cue Light Functions ************************************************

function placeCueText(cueStep as integer, prop as property_t)
	
	mt		as txtProp_t
	cueText	as string[3] = ["action", "ready", "wait"]

	mt.startX = 50
	mt.startY = 50
	mt.align = 1
	mt.layer = layer.front
		
	mt.size = 24 * prop.baseSize
	
	if device.isComputer
		mt.size = mt.size * 1.6
	endif
	
	if GetTextExists(txt.cueStep)
		deleteText(txt.cueStep)
	endif

	setFontProperties(color[prop.fontColor], prop.fontAlpha, prop.font, mt.size)
	CreateText(txt.cueStep, getLangString(cueText[cueStep], state.language))
	textDraw(txt.cueStep, mt)
	updateTextOrientation(txt.cueStep, prop.padVertical)
	
endFunction

function updateCueText(cueStep as integer)
	
	cueText	as string[3] = ["action", "ready", "wait"]
	SetTextString(txt.cueStep, getLangString(cueText[cueStep], state.language))
	
endFunction

//************************************************* Countdown Functions ************************************************

function placeStartClock(in as string, prop ref as property_t)

	mt as txtProp_t
	chars as integer

	mt.startX = 50
	mt.startY = 50
	mt.align = 1
	mt.layer = layer.front
	
	prop.padVertical = 0

	chars = len(in)

	if chars < 3
		mt.size = 50 * prop.baseSize
		prop.padVertical = -20
	elseif chars < 6
		mt.size = 24 * prop.baseSize
	else
		mt.size = 17 * prop.baseSize
		prop.padVertical = 10
	endif

	if device.isComputer
		mt.size = mt.size * 1.6
	endif

	mt.startY = mt.startY - (mt.size / 2)
	
	if GetTextExists(txt.clock)
		deleteText(txt.clock)
	endif

	setFontProperties(color[prop.fontColor], prop.fontAlpha, prop.font, mt.size)
	CreateText(txt.clock, in)
	textDraw(txt.clock, mt)
	updateTextOrientation(txt.clock, prop.padVertical)

endFunction

function placeCtrlClock(in as string, col as color_t, prop ref as property_t)

	mt as txtProp_t

	mt.startX = getSpriteX(sprite.bCtrlWait)
	mt.startY = getSpriteY(sprite.bCtrlPlayPause) + 0.25
	mt.align = 0
	mt.layer = layer.B

	if device.aspect > 0.6
		inc prop.baseSize
	endif

	setFontProperties(color[prop.fontColor], prop.fontAlpha, prop.font, prop.baseSize)
	CreateText(txt.clock, in)
	textDraw(txt.clock, mt)

endFunction

function padClock(in as string)

	out		as string
	temp	as string[]
	items	as integer 

	items = CountStringTokens(in, ":")

	// add zeroes to single digits
	for i = 0 to items
		temp.insert(GetStringToken(in, ":", i + 1))
		if len(temp[i]) = 1
			temp[i] = "0" + temp[i]
		endif
	next i

	// reassemble with colons
	for i = 0 to items
		out = out + temp[i]
		if items - i - 1 > 0
			out = out + ":"
		endif
	next i

endFunction out

function updateClockText(c ref as clock_t, items as integer)

	number as string[]

	c.output = ""

	select items
	case 1
		number.insert(str(c.sec))
	endCase
	case 2
		number.insert(str(c.min) + ":")
		number.insert(str(c.sec))
	endCase
	case default
		number.insert(str(c.hour) + ":")
		number.insert(str(c.min) + ":")
		number.insert(str(c.sec))
	endCase
	endSelect

	for i = 0 to items - 1
		c.output = c.output + number[i]
	next i

	c.output = padClock(c.output)
	SetTextString(txt.clock, c.output)

endFunction

function updateTextOrientation(txtID, pad as integer)

	offset	as integer
	angles	as integer[4] = [180, 0, 180, 270, 90]

	SetTextAngle(txtID, angles[state.orientation])

	if device.isComputer
		offset = 10
	else
		offset = 0
	endif

	select state.orientation
	case 0
		SetTextPosition(txtID, 50, 65 - offset - (pad / 2))
	endCase
	case 1
		SetTextPosition(txtID, 50, 35 - offset + (pad / 1.5))
	endCase
	case 2
		SetTextPosition(txtID, 50, 65 - (pad))
	endCase
	case 3
		SetTextPosition(txtID, 25 + offset + (pad / 2), 50)
	endCase
	case 4
		SetTextPosition(txtID, 75 - (offset * 1.5) - (pad / 2), 50)
	endCase
	endSelect

endFunction

//************************************************* Status Text ********************************************************

function placeStatusText(s as string)
	
	mt as txtProp_t
	col as integer
	posY as integer = 5
		
	clearText(txt.status, txt.status)
	setFontProperties(color[0], 255, media.fontA, 4)
	mt = setTextProperties(mt, 50, posY, 1)
	createText(txt.status, s)
	textDraw(txt.status, mt)
	
endFunction

//************************************************* Static Text ********************************************************

function placeVersionText()

	mt as txtProp_t
	prop as property_t

	mt.startX = 99.5
	mt.startY = 97.5
	mt.align = 2
	mt.size = 1.5
	mt.layer = layer.top
	prop.font = media.fontC
	prop.fontAlpha = 192
	prop.fontColor = 0

	setFontProperties(color[prop.fontColor], prop.fontAlpha, prop.font, mt.size)
	CreateText(txt.version, "v"+ str(version.major) + "." + str(version.minor) + "." + str(version.patch))
	textDraw(txt.version, mt)

endFunction

//************************************************* Text Input *********************************************************

function placeTextInput(mt as txtProp_t, in as string, maxChars as integer)

	height as float 
	width as float
	height = mt.size + 0.5
	width = (maxChars * mt.size) / 1.4

	createEditBox(txt.editBox)
	setEditBoxSize(txt.editBox, width, height)
	setEditBoxPosition(txt.editBox, mt.startX, mt.startY)
	setEditBoxMultiLine(txt.editBox, 0)
	setEditBoxFont(txt.editBox, media.fontA)
	setEditBoxTextColor(txt.editBox, 0, 0, 0)
	setEditBoxBackgroundColor(txt.editBox, color[0].r, color[0].g, color[0].b, 255)
	setEditBoxBorderSize(txt.editBox, 0.1)
	setEditBoxBorderColor(txt.editBox, 0, 0, 0, 255)
	setEditBoxCursorColor(txt.editBox, 0, 0, 0)
	setEditBoxText(txt.editBox, in)
	setEditBoxTextSize(txt.editBox, mt.size)
	SetEditBoxMaxChars(txt.editBox, maxChars) 
	setEditBoxCursorWidth(txt.editBox, 1)
	setEditBoxDepth(txt.editBox, layer.top)
	setEditBoxVisible(txt.editBox, 1)

endFunction

function clearTextInput(spriteID as integer)

	if GetEditBoxExists(txt.editBox)
		DeleteEditBox(txt.editBox)
	endIf

	if GetTextExists(txt.editBox)
		clearTextSingle(txt.editBox)
	endif

	clearSpriteSingle(spriteID)

endFunction

//************************************************* Chores *************************************************************

function changeLanguageAllActive()

	loc as locale_t[]
	loc = getLocaleIDs()

	for i = 0 to loc.length
		if GetTextExists(loc[i].ID)
			SetTextString(loc[i].ID, getLangString(loc[i].item, state.language))
		endif
	next i

endFunction

function textFade(startTxt as integer, stopTxt as integer, dir as string)

	incr as integer

	select dir
	case "in"
		start = 0
		stop = 255
		incr = 16
	endCase
	case "out"
		start = 255
		stop = 0
		incr = -16
	endCase
	endSelect

	// fade in/out
	for i = start to stop step incr
		for j = startTxt to stopTxt
			SetTextColorAlpha(j, i)
		next j
		sync()
	next i

endFunction
 
function textDraw(id as integer, mt as txtProp_t)

	SetTextFont(id, font.id)
	SetTextColor(id, font.r, font.g, font.b, font.a)
	SetTextSize(id, font.size)
	SetTextPosition(id, mt.startX, mt.startY)
	SetTextAlignment(id, mt.align)
	SetTextDepth(id, mt.layer)
	SetTextVisible(id, 1)

endFunction

function setFontProperties(col as color_t, alpha, fnt as integer, size as float)

	font.r = col.r
	font.g = col.g
	font.b = col.b
	font.a = alpha
	font.id = fnt
	font.size = size

endFunction

function clearTextSingle(in as integer)

	if getTextExists(in)
		deleteText(in)
	endif

endFunction

function clearText(start as integer, stop as integer)

	for i = start to stop
		clearTextSingle(i)
	next i

endFunction

function setTextProperties(mt ref as txtProp_t, x as float, y as float, align as integer)

	mt.startX = x
	mt.startY = y
	mt.align = align	

endFunction mt

function getLangString(item as string, langID as integer)

	out as string

	out = "string not found"

	for i = 0 to ml.length
		if ml[i].item = item
			out = ml[i].lang[langID]
			exit
		endif
	next i

endFunction out
