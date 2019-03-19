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
	
	time.hour = 1
	time.min = 2
	time.sec = 20
	
	countdownView(time)
	
endFunction

function testClockRaw(in as clock_t)
	
	print(in.hour)
	print(in.min)
	print(in.sec)
	
endFunction
