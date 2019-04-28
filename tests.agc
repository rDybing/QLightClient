/***********************************************************************************************************************

tests.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Module Tests *******************************************************

function testCueLight()
	
	time as timer_t
	cue as cueLight_t
	
	cueLightView()
	
endFunction

function testClock()
	
	time as clock_t
	prop as property_t
	
	time.hour = 0
	time.min = 0
	time.sec = 30
	// note: 100% = start of countdown || 0% = end of countdown
	time.yStartPercent = 90
	time.rStartPercent = 20
	time.rEndPercent = 5
	prop.baseSize = 0.9
	prop.font = media.fontC
	prop.fontColor = 1
	prop.fontAlpha = 160
	prop.orientation = 1
	countdownView(time, prop)
	
endFunction

//************************************************* Debug Data *********************************************************

function testGeneral(in as string)
	
	repeat
		print("......testData......")
		print("--------------------")
		print(in)
		print("--------------------")
		print("click to continue...")
		sync()
	until GetPointerPressed()
	
endFunction

function testCueRaw(in as cueLight_t)
	
	print("colorStep  : " + str(in.colorStep))
	print("fadeOn     : " + str(in.fadeOn))
	print("fadeDur.   : " + str(in.fadeDuration))
	print("resp.req   : " + str(in.responseReq))
	print("resp.ack   : " + str(in.responseAck))
	
	testDevice()
	
endFunction

function testClockRaw(in as clock_t)
	
	print("hours      : " + str(in.hour))
	print("mins       : " + str(in.min))
	print("secs       : " + str(in.sec))
	print("secs curr  : " + str(in.secCurrent))
	print("secs total : " + str(in.secTotal))
	print("y startsec : " + str(in.yStartSec))
	print("r startsec : " + str(in.rStartSec))
	print("r endsec   : " + str(in.rEndSec))

	testDevice()
	
endFunction

function testDevice()

	print("device OS  : " + device.os)
	print("model      : " + device.model)
	print("is computer: " + str(device.isComputer))
	print("rotation   : " + str(state.rotation))
	print("orientation: " + str(state.orientation))
	print("landscape  : " + str(state.landscape))
	print("width      : " + str(device.width))
	print("height     : " + str(device.height))
	print("aspect     : " + str(device.aspect))
	
endFunction
