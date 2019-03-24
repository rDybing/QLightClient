/***********************************************************************************************************************

tests.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

function testGeneral(in as string)
	
	repeat
		print("testData...")
		print(in)
		print("click to continue...")
		sync()
	until GetPointerPressed()
	
endFunction

function testClock()
	
	time as clock_t
	
	time.hour = 0
	time.min = 1
	time.sec = 30
	// note: 100% = start of countdown || 0% = end of countdown
	time.yStartPercent = 90
	time.rStartPercent = 20
	time.rEndPercent = 5
	countdownView(time)
	
endFunction

function testClockRaw(in as clock_t)
	
	print("hours     : " + str(in.hour))
	print("mins      : " + str(in.min))
	print("secs      : " + str(in.sec))
	print("secs curr : " + str(in.secCurrent))
	print("secs total: " + str(in.secTotal))
	print("y startsec: " + str(in.yStartSec))
	print("r startsec: " + str(in.rStartSec))
	print("r endsec  : " + str(in.rEndSec))
	
endFunction
