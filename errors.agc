/***********************************************************************************************************************

errors.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/
 
//************************************************* Error Handling *****************************************************

function noSettingsFileError()
	
	errorOut('No AppSettings File Exist\nExiting...')
	state.fatalError = true

endFunction

function noLocalizationFileError()
	
	errorOut('No Localization File Exist\nExiting...')
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
