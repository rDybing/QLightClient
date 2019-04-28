/***********************************************************************************************************************

network.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Cue Light Functions ************************************************

function getCueUpdate(cue ref as cueLight_t)
		
	out as integer = false
	
	// simple keyboard press for testing purposes
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
	endIf
	if GetRawKeyReleased(53)		// 5: Ready Acknowledge
		cue.responseReq = false
		cue.responseAck = true
	endIf
	if GetRawKeyReleased(54)		// 6: Set fade on 1/2 second
		cue.fadeOn = true
		cue.fadeDuration = 0.25
	endIf
	if GetRawKeyReleased(55)		// 7: Set fade off
		cue.fadeOn = false
	endIf
		
endFunction out
