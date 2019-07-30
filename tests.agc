/***********************************************************************************************************************

tests.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Module Tests *******************************************************

/*
function testClock()

	clock as clock_t
	prop as property_t

	clock = loadClockTimer()

	prop.baseSize = 0.9
	prop.font = media.fontC
	prop.fontColor = 1
	prop.fontAlpha = 192
	prop.orientation = 1
	countdownView(clock, prop)

endFunction
*/

function testClockUpdate(prop ref as property_t)

	out as integer = false

	// simple keyboard press for testing purposes
	if GetRawKeyReleased(48)		// 0: Change orientation
		inc prop.orientation
		if prop.orientation > 4
			prop.orientation = 1
		endif
		out = true
	endif

endFunction out

function testCueUpdate(cue ref as cueLight_t)

	out as integer = false

	cue.responseUpd = false

	// simple keyboard press for testing purposes
	if GetRawKeyReleased(48)		// 0: Change orientation
		inc cue.orientation
		if cue.orientation > 4
			cue.orientation = 1
		endif
		out = true
	endif
	if GetRawKeyReleased(49)		// 1: Green
		cue.colorStep = 0
		out = true
	endIf
	if GetRawKeyReleased(50)		// 2: Yellow
		cue.colorStep = 1
		out = true
	endIf
	if GetRawKeyReleased(51)		// 3: Red
		cue.colorStep = 2
		out = true
	endIf
	if GetRawKeyReleased(52)		// 4: Ready Activate
		cue.responseReq = true
		cue.responseAck = false
		cue.responseUpd = true
		out = true
	endIf
	if GetRawKeyReleased(53)		// 5: Ready Acknowledged
		cue.responseReq = false
		cue.responseAck = true
		cue.responseUpd = true
		out = true
	endIf
	if GetRawKeyReleased(54)		// 6: Set fade on 1/2 second
		cue.fadeOn = true
		cue.fadeDuration = 0.25
	endIf
	if GetRawKeyReleased(55)		// 7: Set fade off
		cue.fadeOn = false
	endIf

endFunction out

//************************************************* Debug Data *********************************************************

function testGeneral(in as string)

	repeat
		print("......testData......")
		print("--------------------")
		print(in)
		print("--------------------")
		print("click to continue...")
		sync()
	until GetRawKeyReleased(escKey) or GetPointerPressed()

endFunction

function testCueRaw(in as cueLight_t)

	print("colorStep  : " + str(in.colorStep))
	print("fadeOn     : " + str(in.fadeOn))
	print("fadeDur.   : " + str(in.fadeDuration))
	print("resp.req   : " + str(in.responseReq))
	print("resp.ack   : " + str(in.responseAck))
	print("resp.upd   : " + str(in.responseUpd))

	testDevice()

endFunction

function testClockRaw(in as clock_t)

	print("hours      : " + str(in.hour))
	print("mins       : " + str(in.min))
	print("secs       : " + str(in.sec))
	print("output     : " + in.output)
	print("secs curr  : " + str(in.secCurrent))
	print("secs total : " + str(in.secTotal))
	print("y startsec : " + str(in.yStartSec))
	print("r startsec : " + str(in.rStartSec))
	print("r endsec   : " + str(in.rEndSec))
	print("play       : " + str(in.play))

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
	print("privateIP  : " + device.privateIP)
	print("appID      : " + app.id)
	print("appName    : " + app.name)
	print("langCode   : " + app.language)
	print("langID     : " + str(state.language))

endFunction

function testNetwork(net as network_t)

	out as string

	out = net.toJSON()
	print(out)

endFunction
