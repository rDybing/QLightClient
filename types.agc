/***********************************************************************************************************************

types.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Control ************************************************************

type appSettings_t
	id					as string
	apiIp				as string
	apiPort				as string
	apiId				as string
	apiKey				as string
endType

type mouse_t
	x					as integer
	y					as integer
	hit					as integer
	spriteID 			as integer
endType

type device_t
	width				as integer
	height				as integer
	aspect				as float
	id					as string 
	os					as string
	model				as string
	isComputer			as integer
endType

type globalState_t
	httpOK 				as integer
	live 				as integer
	apiBusy				as integer
	fatalError			as integer
	rotation			as integer
	orientation			as integer
	landscape			as integer
endType

type timer_t
	old					as integer
	new					as integer
	freq				as integer
endType

type input_t
	mode				as integer
	name				as string
	button				as integer
	change				as integer
endType

type menuLang_t
	item				as string 
	lang				as string[1]	
endType

type property_t
	baseSize			as float
	font				as integer
	orientation			as integer
	padVertical			as integer
endType

//************************************************* Module Specific ****************************************************

type cue_t
	colorStep			as integer
	fadeOn				as integer
	fadeDuration		as integer
endType

type clock_t
	hour				as integer
	min					as integer
	sec					as integer
	secCurrent			as integer
	secTotal			as integer
	yStartPercent		as integer
	rStartPercent		as integer
	rEndPercent			as integer
	yStartSec			as integer
	rStartSec			as integer
	rEndSec				as integer
endType

//************************************************* Media **************************************************************

type media_t
	fontA				as integer
	fontB				as integer
	fontC				as integer
	fontD				as integer
	back				as integer
	logo				as integer
	bBack				as integer
endType

type spriteProp_t
	posX				as float
	posY				as float
	width				as float
	height				as float
	offsetX				as float
	offsetY				as float
endType

type sprite_t
	back				as integer
	logo				as integer
	bBack				as integer
endType

type tween_t
	back				as integer
endType

type sound_t
	click				as integer
endType

//************************************************* Text ***************************************************************

type font_t
	id					as integer
	r					as integer
	g					as integer
	b					as integer
	size				as float
	interval			as integer
endType

type txtProp_t
	startY				as float
	startX				as float
	offset 				as integer
	align 				as integer
	hOffset				as float
	mainItems			as integer
	menuItems			as integer
	size				as float
	active				as integer
	maxLines			as integer
	lang				as integer
endType

type txt_t
	ver					as integer
	clock				as integer
endType

//************************************************* Composition ********************************************************

type layer_t
	front				as integer
	A					as integer
	B					as integer
	C					as integer
	back				as integer
endType

type color_t
	r					as integer
	g					as integer
	b					as integer
	a					as integer
endType
