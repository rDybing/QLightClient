/***********************************************************************************************************************

network.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

function networkListener()
	
	testCueLight()
	testClock()
	
endFunction

function networkEmitter(in as string)
	// do stuff
endFunction

//************************************************* Cue Light Functions ************************************************

function getCueUpdate(cue ref as cueLight_t)
	
	out as integer	
	out = testCueUpdate(cue)
		
endFunction out

//************************************************* Countdown Functions ************************************************

function getOrientationChange(prop ref as property_t)
	
	out as integer
	out = testClockUpdate(prop)
	
endFunction out
