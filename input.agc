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
