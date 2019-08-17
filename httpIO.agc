/***********************************************************************************************************************

httpIO.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

// ************************************************ POST Functions *****************************************************

function uploadAppInfo()
	
	msgOut	as string
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
	
	msgOut = GetStringToken(msg, ":", 2)
	
endFunction msgOut

function updateAppInfo()
	
	msgOut	as string
	posY	as integer = 5
	appName	as string
	query	as string
	
	query = "postAppUpdate"
	
	msg as string
	out as string
	
	if app.name = "Client-" or app.name = "Ctrl-"
		appName = app.name + app.id
	else
		appName = app.name
	endif
	out = "ID=" + app.id
	out = out + "&Name=" + appName
	out = out + "&Mode=" + app.mode 
	msg = postToServer(query, out, posY)
	
	msgOut = GetStringToken(msg, ":", 2)
	
endFunction msgOut

// ************************************************ GET Functions ******************************************************

function getWelcome()

	posY		as integer = 5
	query		as string
	msg			as string
		
	query = "getWelcome?ID=" + app.id
	
	msg = getFromServer(query, posY)
	
endFunction msg

function getServerIP()

	posY	as integer = 5
	query	as string
	msg		as string

	query = "getServerIP?PrivateIP=" + device.privateIP

	msg = getFromServer(query, posY)
	
endFunction msg

//************************************************* Send Query Functions ***********************************************

function getFromServer(query as string, posY as integer)
	
	http		as integer
	response	as string
	
	if GetInternetState()
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
			response = "ERROR:No response from server!"
		else
			response = GetHTTPResponse(http)
			state.httpOK = true
		endif
		CloseHTTPConnection(http)
		DeleteHTTPConnection(http)
	else
		placeTextFromServer("No internet!", posY)
		response = "ERROR:No internet!"
	endif
	
endFunction response

function postToServer(query as string, post as string, posY as integer)
	
	http		as integer
	response	as string
	
	if GetInternetState()	
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
			response = "ERROR:No response from server!"
		else
			response = GetHTTPResponse(http)
			state.httpOK = true
		endif
		CloseHTTPConnection(http)
		DeleteHTTPConnection(http)
	else
		placeTextFromServer("No internet!", posY)
		response = "ERROR:No internet!"
	endif
	
endFunction response
