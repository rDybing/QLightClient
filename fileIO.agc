/***********************************************************************************************************************

fileIO.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Media Load/Save ****************************************************

function loadMedia()
	
	LoadSound(sound.click, "keyClick.wav")
		
	LoadFont(media.fontA, "Roboto-Regular.ttf")
	LoadFont(media.fontB, "Roboto-Medium.ttf")
	LoadFont(media.fontC, "UbuntuMono-B.ttf")
	LoadFont(media.fontD, "Riffic-Bold.ttf")
	LoadFont(media.fontE, "Imperium-Hollow.ttf")
	LoadFont(media.fontF, "College-Halo.ttf")
	LoadFont(media.fontG, "Aurebesh-Bold.ttf")
	
	LoadImage(media.back, "whiteDot.png")
	LoadImage(media.logo, "QLiteLogo.png")
	LoadImage(media.framePc, "frame_trans_pc.png")
	LoadImage(media.framePhone, "frame_trans_phone.png")
	LoadImage(media.dot, "whiteDot.png")
	LoadImage(media.bBack, "btnBack.png")
	LoadImage(media.bReady, "btnReady.png")
	LoadImage(media.bMenu, "btnMenu.png")
	LoadImage(media.bLeft, "btnLeft.png")
	LoadImage(media.bRight, "btnRight.png")
	LoadImage(media.bCheck, "btnCheck.png")
	LoadImage(media.flagNO, "flagNorway.png")
	LoadImage(media.flagUK, "flagUK.png")
	
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
