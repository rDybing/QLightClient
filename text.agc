/***********************************************************************************************************************

input.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Cue Light Functions ************************************************


//************************************************* Countdown Functions ************************************************

function placeStartClock(in as string, prop ref as property_t)
	
	mt as txtProp_t
	chars as integer
	
	mt.startX = 50
	mt.startY = 50
	mt.align = 1
	
	chars = len(in)
	
	if chars < 3
		mt.size = 50 * prop.baseSize
		prop.padVertical = -20
	elseif chars < 6
		mt.size = 27 * prop.baseSize
	else
		mt.size = 17 * prop.baseSize
		prop.padVertical = 10
	endif
	
	if device.isComputer
		mt.size = mt.size * 1.6
	endif
	
	mt.startY = mt.startY - (mt.size / 2)
	
	setFontProperties(color[prop.fontColor], prop.fontAlpha, prop.font, mt.size)
	CreateText(txt.clock, in)
	textDraw(txt.clock, mt)
	updateTextOrientation(txt.clock, prop.padVertical)
		
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

function updateClockText(in as clock_t, items as integer)
	
	number as string[]
	out as String
	
	select items
	case 1
		number.insert(str(in.sec))
	endCase
	case 2
		number.insert(str(in.min) + ":")
		number.insert(str(in.sec))
	endCase
	case default
		number.insert(str(in.hour) + ":")
		number.insert(str(in.min) + ":")
		number.insert(str(in.sec))
	endCase
	endSelect
	
	for i = 0 to items - 1
		out = out + number[i]
	next i
	
	out = padClock(out)
	SetTextString(txt.clock, out)
	
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
		//SetTextSize(txtID, font.size)
		SetTextPosition(txtID, 50, 65 - offset - (pad / 2))
	endCase
	case 1
		//SetTextSize(txtID, font.size)
		SetTextPosition(txtID, 50, 35 - offset + (pad / 1.5))
	endCase
	case 2
		//SetTextSize(txtID, font.size)
		SetTextPosition(txtID, 50, 65 - (pad))
	endCase
	case 3
		//SetTextSize(txtID, font.size)
		SetTextPosition(txtID, 25 + offset + (pad / 2), 50)
	endCase
	case 4
		//SetTextSize(txtID, font.size)
		SetTextPosition(txtID, 75 - (offset * 1.5) - (pad / 2), 50)
	endCase
	endSelect
	
endFunction

//************************************************* Static Text ********************************************************

function placeVersionText()
	
	mt as txtProp_t
	prop as property_t
	
	mt.startX = 99.5
	mt.startY = 97.5
	mt.align = 2
	mt.size = 1.5
	prop.font = media.fontC
	prop.fontAlpha = 192
	prop.fontColor = 0
	
	setFontProperties(color[prop.fontColor], prop.fontAlpha, prop.font, mt.size)
	CreateText(txt.version, "v"+ str(version.major) + "." + str(version.minor) + "." + str(version.patch))
	textDraw(txt.version, mt)
	SetTextDepth(txt.version, layer.top)
	
endFunction

//************************************************* Chores *************************************************************

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
	SetTextDepth(id, layer.front)
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

function textClearSingle(in as integer)

	if getTextExists(in)
		deleteText(in)
	endif

endFunction

function textClear(start as integer, stop as integer)

	for i = start to stop
		textClearSingle(i)
	next i

endFunction

function setTextProperties(mt ref as txtProp_t, x as float, y as float, align as integer)
	
	mt.startX = x
	mt.startY = y
	mt.align = align	
	
endFunction mt

function initTxtProp(mt ref as txtProp_t)
	
	mt.startY = 50
	mt.startX = 4
	mt.offset = 4
	mt.align = 1
	mt.hOffset = 200
	mt.mainItems = 0
	mt.menuItems = 0
	mt.size = 4
	mt.maxLines = 21
	mt.lang = 0
	
endFunction

function getLangString(item as string, ID as integer)
	
	out as string
	
	out = "string not found"
	
	for i = 0 to ml.length
		if ml[i].item = item
			out = ml[i].lang[ID]
			exit
		endif
	next i
	
endFunction out
