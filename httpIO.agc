/***********************************************************************************************************************

httpIO.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

// ************************************************ POST Functions *****************************************************

function uploadAppInfo()
	
	posY	as integer = 5
	appName	as string
	query	as string
	query = "postAppInfo"
	
	msg as string
	out as string 
	
	if app.name = "Client-" or app.name = "Ctrl-"
		appName = app.name + app.id
	else
		appName = app.name
	endif
	
	out = "ID=" + app.id
	out = out + "&Name=" + appName
	out = out + "&WH=" + str(device.width) + "x" + str(device.height)
	out = out + "&Aspect=" + str(device.aspect)
	out = out + "&PrivateIP=" + device.privateIP
	out = out + "&Mode=" + app.mode
	out = out + "&OS=" + device.os
	out = out + "&Model=" + device.model 
	
	msg = postToServer(query, out, posY)
	
endFunction msg

//************************************************* Send Query Functions ***********************************************

function getFromServer(query as string, posY as integer)
	
	http		as integer
	response	as string
	
	http = CreateHTTPConnection()
	SetHTTPHost(http, app.apiIp, true, app.apiId, app.apiKey)
	SetHTTPTimeout(http, 10000)
	SendHTTPRequestASync(http, query)
	
	while GetHTTPResponseReady(http) = 0
		placeTextFromServer("Connecting...", posY)
		sync()
	endWhile
	
	if GetHTTPResponseReady(http) = -1
		placeTextFromServer("Connection Failed", posY)
		state.httpOK = false
		response = ""
	else
		response = GetHTTPResponse(http)
		state.httpOK = true
	endif
	
	CloseHTTPConnection(http)
	DeleteHTTPConnection(http)
	
	
endFunction response

function postToServer(query as string, post as string, posY as integer)
	
	http		as integer
	response	as string
	
	http = CreateHTTPConnection()
	SetHTTPHost(http, app.apiIp, true, app.apiId, app.apiKey)
	SetHTTPTimeout(http, 10000)
	
	SendHTTPRequestASync(http, query, post)
	
	while GetHTTPResponseReady(http) = 0
		placeTextFromServer("Connecting...", posY)
		sync()
	endWhile
	
	if GetHTTPResponseReady(http) = -1
		placeTextFromServer("Connection Failed!", posY)
		state.httpOK = false
		response = "fail"
	else
		response = GetHTTPResponse(http)
		state.httpOK = true
	endif
	
	CloseHTTPConnection(http)
	DeleteHTTPConnection(http)
	
endFunction response
