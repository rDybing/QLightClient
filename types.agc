/***********************************************************************************************************************

types.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* Control ************************************************************

type version_t
	name				as string
	major				as integer
	minor				as integer
	patch				as integer
endType

type appSettings_t
	id					as string
	apiIp				as string
	apiPort				as string
	apiId				as string
	apiKey				as string
	language			as string
	name				as string
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
	loggedIn			as integer
	live 				as integer
	apiBusy				as integer
	fatalError			as integer
	rotation			as integer
	orientation			as integer
	landscape			as integer
	language			as integer
	buttonHit			as integer
	mode				as string
endType

type network_t
	id					as integer
	hostID				as integer
	hostPort			as integer
	active				as integer
	clientID			as integer
	clientCount			as integer
	clients				as client_t[]
endType

type client_t
	id					as string
	connectID			as integer
	name				as string
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

type button_t
	active				as integer
	sprID				as integer
	txtID				as integer
	sprX				as float
	sprY				as float
	sprW				as float
	sprH				as float
	txtX				as float
	txtY				as float
endType

//************************************************* Module Specific ****************************************************

type cueLight_t
	receiverID			as string[]
	colorStep			as integer
	fadeOn				as integer
	fadeDuration		as float
	audioOn				as integer
	responseReq			as integer
	responseAck			as integer
	responseUpd			as integer
	orientation			as integer
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
	play				as integer
	output				as string
endType

// text control in countdown
type property_t
	baseSize			as float
	font				as integer
	fontColor			as integer
	fontAlpha			as integer
	orientation			as integer
	padVertical			as integer
endType

type mode_t
	altButton			as integer
	spriteID			as integer
	enum				as string
	emit				as integer
endType

type message_t
	new					as integer
	mode				as string
	inJSON				as string	
endType

//************************************************* Media **************************************************************

type media_t
	fontA				as integer
	fontB				as integer
	fontC				as integer
	fontD				as integer
	fontE				as integer
	fontF				as integer
	fontG				as integer
	back				as integer
	framePC				as integer
	framePhone			as integer
	logo				as integer
	dot					as integer
	bBack				as integer
	bReady				as integer
	bMenu				as integer
	bLeft				as integer
	bRight				as integer
	bCheck				as integer
	bPlay				as integer
	bPause				as integer
	flagNO				as integer
	flagUK				as integer
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
	frame				as integer
	logo				as integer
	dropBack			as integer
	bBack				as integer
	bReady				as integer
	bMenu				as integer
	bModeClient			as integer
	bModeCtrl			as integer
	bCtrlWait			as integer
	bCtrlReady			as integer
	bCtrlAction			as integer
	bCtrlTimer			as integer
	bCtrlEdit			as integer
	bCtrlReset			as integer
	bCtrlPlayPause		as integer
	bCtrlAudio			as integer
	bCtrlFade			as integer
	bLang				as integer
	bName				as integer
	bLeft				as integer
	bRight				as integer
	bCheck				as integer
	flag				as integer
endType

type tween_t
	back				as integer
	text				as integer
	ready				as integer
	button				as integer
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
	a					as integer
	size				as float
	interval			as integer
endType

type txtProp_t
	startY				as float
	startX				as float
	offset 				as integer
	align 				as integer
	hOffset				as float
	size				as float
	active				as integer
	maxLines			as integer
	layer				as integer
endType

type txt_t
	null				as integer
	version				as integer
	editBox				as integer
	clock				as integer
	bModeClient			as integer
	bModeCtrl			as integer
	bCtrlWait			as integer
	bCtrlReady			as integer
	bCtrlAction			as integer
	bCtrlTimer			as integer
	bCtrlEdit			as integer
	bCtrlReset			as integer
	bCtrlAudio			as integer
	bCtrlFade			as integer
	modeSelect			as integer
	appID				as integer
	bLang				as integer
	bName				as integer	
endType

type locale_t
	ID					as integer
	item				as string
endType

//************************************************* Composition ********************************************************

type layer_t
	top					as integer
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
