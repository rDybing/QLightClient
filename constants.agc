/***********************************************************************************************************************

constants.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Control ************************************************************
 
function initConstants()

	version.name			= "QLight Client"
	version.major			= 0
	version.minor			= 3
	version.patch			= 0

	layer.top				= 0
	layer.front				= 1
	layer.A					= 10
	layer.B					= 20
	layer.C					= 30
	layer.back				= 999

	sound.click				= 1

	txt.null				= 1000	
	txt.version				= 1001
	txt.editBox				= 1002
	txt.bModeClient			= 1008
	txt.bModeCtrl			= 1009
	txt.bCtrlWait			= 1010
	txt.bCtrlReady			= 1011
	txt.bCtrlAction			= 1012
	txt.bCtrlTimer			= 1013
	txt.bCtrlEdit			= 1014
	txt.bCtrlReset			= 1015
	txt.bCtrlAudio			= 1016
	txt.bCtrlFade			= 1017
	txt.modeSelect			= 1018
	txt.appID				= 1019
	txt.bLang				= 1020
	txt.bName				= 1021
	txt.server				= 1022
	txt.clock				= 1100

	sprite.logo				= 1010
	sprite.dropBack			= 1011
	sprite.bBack			= 1012
	sprite.bReady			= 1013
	sprite.bMenu			= 1014
	sprite.bModeClient		= 1015
	sprite.bModeCtrl		= 1016
	sprite.bCtrlWait		= 1017
	sprite.bCtrlReady		= 1018
	sprite.bCtrlAction		= 1019
	sprite.bCtrlTimer		= 1020
	sprite.bCtrlEdit		= 1021
	sprite.bCtrlReset		= 1022
	sprite.bCtrlPlayPause	= 1023
	sprite.bCtrlAudio		= 1024
	sprite.bCtrlFade		= 1025
	sprite.bLang			= 1026
	sprite.bName			= 1027
	sprite.bLeft			= 1028
	sprite.bRight			= 1029
	sprite.bCheck			= 1030
	sprite.flag				= 1080
	sprite.frame			= 1097
	sprite.back				= 1099

	tween.back				= 1000
	tween.text				= 1001
	tween.ready				= 1002
	tween.button			= 1003

	media.fontA				= 1000
	media.fontB				= 1001
	media.fontC				= 1002
	media.fontD				= 1003
	media.fontE				= 1004
	media.fontF				= 1005
	media.fontG				= 1006
	media.back				= 1007
	media.framePC			= 1008
	media.framePhone		= 1009
	media.logo				= 1010
	media.dot				= 1011
	media.bBack				= 1012
	media.bReady			= 1013
	media.bMenu				= 1014
	media.bLeft				= 1015
	media.bRight			= 1016
	media.bCheck			= 1017
	media.bPlay				= 1018
	media.bPause			= 1019
	media.flagNO			= 1080
	media.flagUK			= 1081
	media.flagDE			= 1082

endFunction

function initEnums()
	
	enum.client				= 10
	enum.ctrl				= 11
	enum.cue				= 12
	enum.countdown			= 13
	enum.quit				= 14
	enum.close				= 15
	enum.wait				= 16
	enum.ready				= 17
	enum.action				= 18
	enum.audio				= 19
	enum.fade				= 20
	enum.playPause			= 21
	enum.edit				= 22
	enum.reset				= 23
	enum.newClient			= 24
	
endFunction

function getLocaleIDs()

	loc as locale_t[5]

	loc[0].ID = txt.bModeClient
	loc[0].item = "client"
	loc[1].ID = txt.bModeCtrl
	loc[1].item = "ctrl"
	loc[2].ID = txt.modeSelect
	loc[2].item = "selectMode"
	loc[3].ID = txt.bLang
	loc[3].item = "setLang"
	loc[4].ID = txt.bName
	loc[4].item = "setName"

endFunction loc

function initColor()

	// Off-White
	color[0].r = 230
	color[0].g = 225
	color[0].b = 205
	color[0].a = 255
	// Black
	color[1].r = 0
	color[1].g = 0
	color[1].b = 0
	color[1].a = 0
	// Normal Red
	color[2].r = 110
	color[2].g = 29
	color[2].b = 24
	color[2].a = 255
	// Balanced Red
	color[3].r = 225
	color[3].g = 55
	color[3].b = 55
	color[3].a = 255
	// Balanced Yellow
	color[4].r = 214
	color[4].g = 162
	color[4].b = 65
	color[4].a = 255
	// Balanced Green
	color[5].r = 35
	color[5].g = 204
	color[5].b = 65
	color[5].a = 255
	// Highlight Blue
	color[6].r = 96
	color[6].g = 81
	color[6].b = 219
	color[6].a = 255
	// New-Blue
	color[7].r = 0
	color[7].g = 164
	color[7].b = 225
	color[7].a = 255
	// Highlight Cyan
	color[8].r = 77
	color[8].g = 209
	color[8].b = 170
	color[8].a = 255
	// Balanced Purple
	color[9].r = 112
	color[9].g = 65
	color[9].b = 214
	color[9].a = 255
	// Material Background
	color[10].r = 18
	color[10].g = 18
	color[10].b = 18
	color[10].a = 255
	// Material Buttons
	color[11].r = 255
	color[11].g = 255
	color[11].b = 255
	color[11].a = 16
	// Material Background
	color[12].r = 27
	color[12].g = 27
	color[12].b = 27
	color[12].a = 255

endFunction

function initCue()

	cue as cueLight_t

	cue.responseUpd = false
	cue.orientation = 1
	cue.colorStep = 2 // 0: Green | 1: Yellow | 2: red
	cue.responseReq = false
	cue.responseAck = false
	cue.responseUpd = false
	cue.fadeOn = false
	cue.fadeDuration = 0.25
	cue.audioOn = false

endFunction cue
