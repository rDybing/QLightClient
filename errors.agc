/***********************************************************************************************************************

errors.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/
 
//************************************************* Error Handling *****************************************************

function noFileError(in as string)
	
	errorOut(in)
	state.fatalError = true

endFunction

//************************************************* Output To User *****************************************************

function errorOut(in as string)
	
	repeat
		print("ERROR")
		print("-----")
		print(in)
		print("-----")
		print("Click anywhere to exit")
		sync()
	until GetPointerPressed()	

endFunction
