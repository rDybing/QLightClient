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
	case "ready"
		cue.colorStep = 0
	endCase
	case "wait"
		cue.colorStep = 1
	endCase
	case "action"
		cue.colorStep = 2
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
	tc				as client_t
	out				as string
	
	clientID = GetNetworkFirstClient(net.id)
	
	while clientID > 0 and net.clients.length < maxClients	
		// seperate out host
		if clientID = GetNetworkMyClientID(net.id)
			net.hostID = clientID
		else
			clientName = getNetworkClientName(net.id, clientID)
			if getClientExists(net, clientName) = false
				if net.clients.length < maxClients
					tc.connectId = clientID
					tc.name = clientName
					net.clients.insert(tc)
					clientAck = createNetworkMessage()
					out = "ok" + ":" + str(net.hostID)
					AddNetworkMessageString(clientAck, out)
					sendNetworkMessage(net.id, clientID, clientAck)
				endif
			endif
		endif
		net.clientCount = GetNetworkNumClients(net.id) - 1		
		clientID = GetNetworkNextClient(net.id)
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
	
	cueUpdate = CreateNetworkMessage()
	transmitJSON as string
	transmitJSON = cue.toJSON()
	
	AddNetworkMessageString(cueUpdate, transmitJSON)
	SendNetworkMessage(net.id, 0, cueUpdate)	
	
endFunction

//************************************************* LAN Client *********************************************************

function joinHost(net ref as network_t)
	
	net.id = JoinNetwork("QLightNet", app.name)
	
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

function networkListener()
	
	testCueLight()
	testClock()
	
endFunction

function receiveCueLAN(cue ref as cueLight_t, net as network_t)

endFunction

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
