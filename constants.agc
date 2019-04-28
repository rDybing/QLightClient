/***********************************************************************************************************************

constants.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Control ************************************************************
 
function initConstants()

	layer.front				= 0
	layer.A					= 10
	layer.B					= 20
	layer.C					= 30
	layer.back				= 999
		
	sound.click				= 1000
		
	txt.ver					= 1000
	txt.clock				= 1100
	
	sprite.bBack			= 1010	
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
	media.back				= 1006
	media.logo				= 1007
	media.bBack				= 1010
	
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
	// Highlight Red
	color[3].r = 209
	color[3].g = 5
	color[3].b = 0
	color[3].a = 255
	// Highligh Yellow
	color[4].r = 231
	color[4].g = 212
	color[4].b = 31
	color[4].a = 255
	// Highlight Green
	color[5].r = 44
	color[5].g = 163
	color[5].b = 0
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
	// Dark Purple
	color[9].r = 43
	color[9].g = 36
	color[9].b = 87
	color[9].a = 255
	
endFunction
