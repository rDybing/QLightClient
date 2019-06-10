/***********************************************************************************************************************

network.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

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
