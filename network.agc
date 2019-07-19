/***********************************************************************************************************************

network.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/



//************************************************* LAN Client/Server Init *********************************************

function initHostLAN(net ref as network_t)

	net.hostPort = 1025
	net.active = true
	net.id = hostNetwork("QLightNet", app.name, net.hostPort)
	SetNetworkLatency(net.id, 50)
	//testNetConnect(gs)
endFunction

//************************************************* LAN Server *********************************************************

function networkEmitter(net ref as network_t, cmd as string, cue as cueLight_t)

	select cmd
	case "close"
		closeHostLAN(net)
	endCase
	case "wait" // red
		cue.colorStep = 2
	endCase
	case "ready" // yellow
		cue.colorStep = 1
	endCase
	case "action" // green
		cue.colorStep = 0
	endCase
	endSelect
	
	if cmd <> "close"
		sendCueLAN(net, cue)
	endif
	
endFunction

function receiveClientsConnect(net ref as network_t)
	
	maxClients		as integer = 8
	clientAck		as integer
	clientName		as string
	clientRemoval	as integer
	clientConnectID	as integer
	tc				as client_t
	out				as string
	
	clientConnectID = GetNetworkFirstClient(net.id)
	
	while clientConnectID > 0 and net.clients.length < maxClients
		// handle disconnect
		clientRemoval = false
		if GetNetworkClientDisconnected(net.id, clientConnectID)
			if GetNetworkClientUserData(net.id, clientConnectID, 0) = 0
				SetNetworkClientUserData(net.id, clientConnectID, 0, 1)
				DeleteNetworkClient(net.id, clientConnectID)
			endif
			removeClient(net, clientConnectID)
			clientRemoval = true
		endif			
		// seperate out host
		if clientConnectID = GetNetworkMyClientID(net.id)
			net.hostID = clientConnectID
		else
			clientName = getNetworkClientName(net.id, clientConnectID)
			if getClientExists(net, clientName) = false and clientRemoval = false
				if net.clients.length < maxClients
					tc.connectId = clientConnectID
					tc.id = clientName
					net.clients.insert(tc)
					clientAck = createNetworkMessage()
					out = "ok" + ":" + str(net.hostID)
					AddNetworkMessageString(clientAck, out)
					sendNetworkMessage(net.id, clientConnectID, clientAck)
				endif
			endif
		endif
		net.clientCount = GetNetworkNumClients(net.id) - 1		
		clientConnectID = GetNetworkNextClient(net.id)
	endWhile
		 
endFunction

function receiveClientsMessage(net ref as network_t)
	
	key as string
	value as integer
	temp as string
	
	clientMess = getNetworkMessage(net.id)
		
	if clientMess <> 0
		temp = GetNetworkMessageString(clientMess)
		if CountStringTokens(temp, ":") > 0
			key = GetStringToken(temp, ":", 1)
			value = val(getStringToken(temp, ":", 2))			
			select key
			case "disconnect"
				removeClient(net, value)
			endCase
			endSelect
		endif			
	endif
	DeleteNetworkMessage(clientMess)
	
endFunction

function closeHostLAN(net ref as network_t)

	if state.loggedIn
		if IsNetworkActive(net.id)
			sendClosingHostLAN(net)
			closeNetwork(net.id)
			net.active = false
			net.id = nil
		endif
	endif

endFunction

function sendClosingHostLAN(net as network_t)
	
	closingLAN = CreateNetworkMessage()
	AddNetworkMessageString(closingLAN, "closing")
	sendNetworkMessage(net.id, 0, closingLAN)
	
endFunction

function sendCueLAN(net as network_t, cue as cueLight_t)
	
	transmitJSON as string
	mode as string
	msg as string
	
	cueUpdate = CreateNetworkMessage()
	transmitJSON = cue.toJSON()
	mode = "cue"
	msg = mode + "|" + transmitJSON
	
	AddNetworkMessageString(cueUpdate, msg)
	SendNetworkMessage(net.id, 0, cueUpdate)	
	
endFunction

//************************************************* LAN Client *********************************************************

function joinHost(net ref as network_t)
	
	net.id = JoinNetwork("QLightNet", app.id)
	
endFunction

function disconnectHost(net as network_t)
	
	out as string
	disconnect as integer
	
	out = "disconnect:" + str(net.clientID)
	
	disconnect = CreateNetworkMessage()
	AddNetworkMessageString(disconnect, out)
	SendNetworkMessage(net.id, net.hostID, disconnect)	
	
endFunction

function receiveServerAck(net ref as network_t)
	
	out			as integer = false
	serverAck	as integer
	in			as string
	temp		as string
	
	serverAck = GetNetworkMessage(net.id)
	
	if serverAck <> 0
		temp = GetNetworkMessageString(serverAck)
	endif
	
	if CountStringTokens(temp, ":") > 0
		in = GetStringToken(temp, ":", 1)
	endif
	
	
	if in = "ok"
		out = true
		net.clientID = GetNetworkMyClientID(net.id)
		net.hostID = val(GetStringToken(temp, ":", 2))
	endif
	
	DeleteNetworkMessage(serverAck)	
	
endFunction out

function getServerInActive(net as network_t)
	
	out as integer = true
	
	if IsNetworkActive(net.id)
		out = false
	endif
	
endFunction out

function receiveCueLAN(net as network_t)
	
	serverMsg	as integer
	temp		as string
	netMsg		as message_t
	
	serverMsg = GetNetworkMessage(net.id)
	
	if serverMsg <> 0
		temp = GetNetworkMessageString(serverMsg)
		if CountStringTokens(temp, "|") > 0
			netMsg.mode = GetStringToken(temp, "|", 1)
			netMsg.inJSON = GetStringToken(temp, "|", 2)
			netMsg.new = true
		endif
	endif		
	
	DeleteNetworkMessage(serverMsg)	

endFunction netMsg

function getCueUpdate(cue ref as cueLight_t)
	
	out as integer	
	out = testCueUpdate(cue)
		
endFunction out

//************************************************* Countdown Functions ************************************************

function getOrientationChange(prop ref as property_t)
	
	out as integer
	out = testClockUpdate(prop)
	
endFunction out

// ************************************************ Chores *************************************************************

function getClientExists(net as network_t, clientID as string)
	
	out as integer = false
	
	if net.clients.length > nil
		for i = 0 to net.clients.length
			if net.clients[i].id = clientID
				out = true
			endif
		next i
	endif
	
endFunction out

function removeClient(net ref as network_t, clientID as integer)
	
	toRemove as integer = nil
	
	for i = 0 to net.clients.length
		if net.clients[i].connectId = clientID
			toRemove = i
		endif
	next i
	
	if toRemove <> nil
		net.clients.remove(toRemove)
		KickNetworkClient(net.id, clientID) 
	endif
	
endFunction
