/***********************************************************************************************************************

input.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

function getEditBoxInput()

	out as string

	out = GetEditBoxText(txt.editBox)
	if len(out) > 10
		out = left(out, 10)
		SetEditBoxText(txt.editBox, out)
	endif

endFunction out

//************************************************* Control Actions ****************************************************

function handleControlButtons(mode ref as mode_t, clock ref as clock_t, clockCol ref as color_t[], clockTimer ref as timer_t, keyTimer ref as timer_t, alpha as integer)

	mouse as mouse_t

	mouse = updateMouse()

	if mouse.hit
		mouse = getMouseHit(mouse)
		mode.spriteID = mouse.spriteID
		select mode.spriteID
		case sprite.bCtrlAudio
			keyTimer = keyPressed(sprite.bCtrlAudio)
			mode.emit = false
			mode.altButton = true
			mode.enum = enum.audio
		endCase
		case sprite.bCtrlFade
			keyTimer = keyPressed(sprite.bCtrlFade)
			mode.emit = false
			mode.altButton = true
			mode.enum = enum.fade
		endCase
		case sprite.bCtrlWait
			state.buttonHit = true
			state.mode = enum.cue
			mode.enum = enum.wait
			mode.emit = true
		endCase
		case sprite.bCtrlReady
			state.buttonHit = true
			state.mode = enum.cue
			mode.enum = enum.ready
			mode.emit = true
		endCase
		case sprite.bCtrlAction
			state.buttonHit = true
			state.mode = enum.cue
			mode.enum = enum.action
			mode.emit = true
		endCase
		case sprite.bCtrlTimer
			state.buttonHit = true
			state.mode = enum.countdown
			mode.enum = enum.countdown
			mode.emit = true
		endCase
		case sprite.bCtrlPlayPause
			if state.mode = enum.countdown
				state.buttonHit = true
				mode.enum = enum.playPause
				//mode.emit = true
				clock.play = not clock.play
				clockTimer = setTimer(1000)
			endif
		endCase
		case sprite.bCtrlEdit
			if not clock.play
				keyTimer = keyPressed(sprite.bCtrlEdit)
				mode.altButton = true
				mode.enum = enum.edit
				//mode.emit = false
			endif
		endCase
		case sprite.bCtrlReset
			if state.mode = enum.countdown
				keyTimer = keyPressed(sprite.bCtrlReset)
				mode.altButton = true
				clock.play = false
				clock = loadClockTimer()
				setSecondsInClock(clock)
				resetCtrlClock(clock, clockCol, alpha)
				mode.enum = enum.reset
				//mode.emit = true
			endif
		endCase
		endSelect
	endif

endFunction

//************************************************* Mouse Actions ******************************************************

function getButton(sprID as integer)

	m	as mouse_t
	out	as integer

	m = getMouseHit(updateMouse())

	if m.hit and m.spriteID = sprID
		out = true
	endif

endFunction out

function updateMouse()

	m as mouse_t

	m.x = GetPointerX()
	m.y = GetPointerY()
	m.hit = GetPointerPressed()

endFunction m

function getMouseHit(m as mouse_t)

	m.spriteID = GetSpriteHit(m.x, m.y)

endFunction m
