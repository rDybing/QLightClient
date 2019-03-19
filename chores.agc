/***********************************************************************************************************************

chores.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Countdown Functions ************************************************

function updateClockTime(clock as clock_t)

	seconds as integer
	
	seconds = clock.sec + (clock.min * 60) + (clock.hour * 3600)
	
	if seconds <> 0
		dec seconds
	endif
	
	clock.hour = seconds / 3600
	clock.min = (seconds - (clock.hour * 3600)) / 60
	clock.sec = seconds - (clock.hour * 3600) - (clock.min * 60)

endFunction clock
 
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
	else
		device.width = getDeviceWidth()
		device.height = getDeviceHeight()
	endif

	fDeviceX = device.width
	fDeviceY = device.height
	device.aspect = fDeviceX / fDeviceY

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
