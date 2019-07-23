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
	LoadImage(media.bPlay, "btnPlay.png")
	LoadImage(media.bPause, "btnPause.png")
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
		noFileError('No AppSettings File Exist\nExiting...')
	endif

endFunction

function saveAppSettings()

	appSettings	as string
	appTemp		as appSettings_t[]

	appSettings = "appSettings.json"

	appTemp.insert(app)
	appTemp.Save(appSettings)

endFunction

function loadClockTimer()
	
	clock		as clock_t
	clockTemp	as clock_t[]
	clockFile	as String
	
	clockFile = "clockTimer.json"
	
	if GetFileExists(clockFile)
		clockTemp.Load(clockFile)
		clock = clockTemp[0]
	else
		clock.hour = 0
		clock.min = 0
		clock.sec = 30
		// note: 100% = start of countdown || 0% = end of countdown
		clock.yStartPercent = 90
		clock.rStartPercent = 20
		clock.rEndPercent = 5
	endif

endFunction clock

function saveClockTimer(c as clock_t)

	clockFile	as string
	clockTemp	as clock_t[]

	clockFile = "clockTimer.json"

	clockTemp.insert(c)
	clockTemp.Save(clockFile)

endFunction

//************************************************* Localization Load **************************************************

function loadLocalization()

	locFile		as string
	locTemp		as menuLang_t[]

	locFile = "localization.json"

	if GetFileExists(locFile)
		locTemp.Load(locFile)
	else
		noFileError('No Localization File Exist\nExiting...')
	endif

endFunction locTemp
