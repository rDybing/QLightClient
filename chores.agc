/***********************************************************************************************************************

chores.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Countdown Functions ************************************************

function updateClockTime(c ref as clock_t)
	
	if c.secCurrent <> 0
		dec c.secCurrent
	endif
	
	c.hour = c.secCurrent / 3600
	c.min = (c.secCurrent - (c.hour * 3600)) / 60
	c.sec = c.secCurrent - (c.hour * 3600) - (c.min * 60)
	
endFunction c

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

function setClockBackgroundColors()
	
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
	
	fDeviceX			as float
	fDeviceY			as float
	
	device.os = GetDeviceBaseName()
	device.model = GetDeviceType()

	if device.os = "linux" or device.os = "windows" or device.os = "pi" or device.os = "mac"
		SetAntialiasMode(1)
		aspectMode = 2
		select aspectMode
		case 0									// 0 = iPad || 1 = iPhone
			device.width = 768					// iPad 50% 4/3
			device.height = 1024				// iPad 50% 4/3
		endCase
		case 1
			device.width = 640 					// iPhone 16/9
			device.height = 1136				// iPhone 16/9
		endCase
		case 2
			device.width = 540
			device.height = 888
		endCase
		endSelect
		SetWindowSize(device.width, device.height, 0)
		state.orientation = 0
		state.landscape = false
	else
		device.width = GetDeviceWidth()
		device.Height = GetDeviceHeight()
		SetWindowSize(device.width, device.height, 0)
		state.orientation = 1
		state.landscape = false
		getScreenOrientation(0)
	endif
	
	fDeviceX = device.width
	fDeviceY = device.height
	device.aspect = fDeviceX / fDeviceY
	SetDisplayAspect(device.aspect)

endFunction

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
