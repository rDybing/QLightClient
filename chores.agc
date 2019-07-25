/***********************************************************************************************************************

chores.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Button Functions ***************************************************

function buttonTransfer(spr as spriteProp_t, sprID as integer, txtID as integer)

	btn as button_t

	btn.active = false
	btn.sprID = sprID
	btn.sprX = spr.posX 
	btn.sprY = spr.posY
	btn.sprW = spr.width
	btn.sprH = spr.height
	btn.txtID = txtID

	if txtID <> nil
		btn.txtX = getTextX(txtID)
		btn.txtY = getTextY(txtID)
	else
		btn.txtX = nil
		btn.txtY = nil
	endif

endFunction btn

//************************************************* Cue Light Functions ************************************************

function setCueBackgroundColors()

	bc as color_t[]

	bc.insert(color[5])	
	bc.insert(color[4])
	bc.insert(color[3])

endFunction bc

//************************************************* Countdown Functions ************************************************

function updateClockTime(c ref as clock_t)

	if c.secCurrent <> 0
		dec c.secCurrent
	endif

	c.hour = c.secCurrent / 3600
	c.min = (c.secCurrent - (c.hour * 3600)) / 60
	c.sec = c.secCurrent - (c.hour * 3600) - (c.min * 60)

endFunction

function setSecondsInClock(c ref as clock_t)

	percent as float
	total as float

	c.secTotal = c.hour * 3600
	c.secTotal = c.secTotal + (c.min * 60)
	c.secTotal = c.secTotal + c.sec
	c.secCurrent = c.secTotal

	total = c.secTotal

	percent = total / 100	

	c.yStartSec = c.yStartPercent * percent
	c.rStartSec = c.rStartPercent * percent
	c.rEndSec = c.rEndPercent * percent

endFunction

function setClockItems(c as clock_t)

	out as integer

	if c.hour <> 0
		out = 3
	endif
	if c.hour = 0 and c.min <> 0
		out = 2
	endif
	if out = 0
		out = 1
	endif

endFunction out

function setClockFromInput(c ref as clock_t)

	percent as float
	total as float

	c.secTotal = valFloat(c.output) * 60.0
	c.secCurrent = c.secTotal

	c.hour = c.secCurrent / 3600
	c.min = (c.secCurrent - (c.hour * 3600)) / 60
	c.sec = c.secCurrent - (c.hour * 3600) - (c.min * 60)

	total = c.secTotal

	percent = total / 100

	c.yStartSec = c.yStartPercent * percent
	c.rStartSec = c.rStartPercent * percent
	c.rEndSec = c.rEndPercent * percent

	c.output = str(c.hour) + ":" + str(c.min) + ":" + str(c.sec)
	c.output = padClock(c.output)

endFunction

function setClockColors()

	bc as color_t[]

	bc.insert(color[5])	
	bc.insert(color[4])
	bc.insert(color[3])

endFunction bc
 
//************************************************* Startup ************************************************************

function setStartState()

	state.fatalError = false
	state.apiBusy = false
	state.httpOK = false
	state.live = false

endFunction

function setDevice()

	fDeviceX as float
	fDeviceY as float

	device.os = GetDeviceBaseName()
	device.model = GetDeviceType()

	SetWindowSize(device.width, device.height, 1)

	if device.os = "linux" or device.os = "windows" or device.os = "pi" or device.os = "mac"
		SetAntialiasMode(1)
		device.width = GetMaxDeviceWidth()
		device.height = GetMaxDeviceHeight()
		device.isComputer = true
		state.orientation = 1
		state.landscape = true
	else
		device.width = GetDeviceWidth()
		device.height = GetDeviceHeight()
		device.isComputer = false
		state.orientation = 1
		state.landscape = false
		//getScreenTextOrientation(0)
	endif

	fDeviceX = device.width
	fDeviceY = device.height
	device.aspect = fDeviceX / fDeviceY
	SetDisplayAspect(device.aspect)

endFunction

function setLanguage()

	lang as string

	lang = GetDeviceLanguage()

	if lang <> app.language and app.language <> ""
		lang = app.language
	endif  

	//testGeneral(lang)

	select lang
	case "en"		// english
		state.language = 1
	endCase
	case "nb"		// norwegian (bokmål)
		state.language = 0
	endCase
	case "nn"		// norwegian (nynorsk)
		state.language = 0
	endCase
	case default	// default english
		state.language = 1
	endCase
	endSelect

	//Override for testing:
	//state.language = 1

endFunction

function getLangCode(in as integer)

	out as String

	select in
	case 0
		out = "nb"
	endCase
	case 1
		out = "en"
	endCase
	case 2
		out = "de"
	endCase
	case default
		out = "en"
	endCase
	endSelect

endFunction out

//************************************************* First Run After Install ********************************************

function createAppID()

	out as string
	temp as string

	temp = device.os + device.model
	temp = temp + GetCurrentDate() + GetCurrentTime()
	temp = sha1(temp)

	out = mid(temp, random(1, 28), 12)

endFunction out

//************************************************* Timers *************************************************************

function setTimer(freq as integer)

	t as timer_t

	t.new = GetMilliseconds()
	t.old = t.new
	t.freq = freq

endFunction t

function getTimer(t ref as timer_t)

	out as integer = false

	t.new = GetMilliseconds()

	if t.new > t.old + t.freq
		t.old = t.new
		out = true
	endif

endFunction out
