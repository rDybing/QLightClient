/***********************************************************************************************************************

constants.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Control ************************************************************
 
function initConstants()
	
	version.name			= "QLight Client"
	version.major			= 0
	version.minor			= 1
	version.patch			= 0

	layer.top				= 0
	layer.front				= 1
	layer.A					= 10
	layer.B					= 20
	layer.C					= 30
	layer.back				= 999
		
	sound.click				= 1000
		
	txt.version				= 1000
	txt.clock				= 1100
	
	sprite.bBack			= 1010
	sprite.frame			= 1097	
	sprite.logo				= 1098
	sprite.back				= 1099
	
	tween.back				= 1000
	tween.text				= 1001
	
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
	media.bBack				= 1011
	
endFunction

function initLang(ml ref as menuLang_t[])
	
	ml[0].item = "version"
	ml[0].lang[0] = "Versjon:"
	ml[0].lang[1] = "Version:"
	
endFunction

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
	color[3].r = 214
	color[3].g = 88
	color[3].b = 65
	color[3].a = 255
	// Balanced Yellow
	color[4].r = 214
	color[4].g = 162
	color[4].b = 65
	color[4].a = 255
	// Balanced Green
	color[5].r = 65
	color[5].g = 214
	color[5].b = 157
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
	
endFunction
