/***********************************************************************************************************************

fileIO.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Media Load/Save ****************************************************

function loadMedia()
		
	loadFont(media.fontA, "Roboto-Regular.ttf")
	loadFont(media.fontB, "Roboto-Medium.ttf")
	loadFont(media.fontC, "UbuntuMono-B.ttf")
	loadFont(media.fontD, "Riffic-Bold.ttf")
	loadFont(media.fontE, "Imperium-Hollow.ttf")
	loadFont(media.fontF, "College-Halo.ttf")
	LoadFont(media.fontG, "Aurebesh-Bold.ttf")
	
	LoadImage(media.back, "whiteDot.png")
	LoadImage(media.framePc, "frame_trans_pc.png")
	LoadImage(media.framePhone, "frame_trans_phone.png")
	LoadImage(media.bBack, "btnBack.png")
	LoadImage(media.bReady, "btnReady.png")
	
endFunction
 
//************************************************* AppSettings Load/Save **********************************************

function loadAppSettings()
	
	appSettings	as string	
	appTemp		as appSettings_t[]
	
	appSettings = "appSettings.json"
	
	if GetFileExists(appSettings)
		appTemp.Load(appSettings)
		app = appTemp[0]
	else
		app.id = "ERROR"
	endif

endFunction

function saveAppSettings()
	
	appSettings	as string
	appTemp		as appSettings_t[]
	
	appSettings = "appSettings.json"
	
	appTemp.insert(app)
	appTemp.Save(appSettings)
	
endFunction
