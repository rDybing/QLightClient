/***********************************************************************************************************************

network.agc

Project: QLightClient

Copyright 2019 Roy Dybing - all rights reserved

***********************************************************************************************************************/

//************************************************* LAN Client/Server Init *********************************************

function initLanHost(net ref as network_t)

	net.hostPort = 1025
	net.active = true
	net.id = hostNetwork("QLightNet", app.name, net.hostPort)
	SetNetworkLatency(net.id, 50)
	//testNetConnect(gs)
	
endFunction


function networkAreadyExist()
        
	listener	as integer
	found		as integer = false
	netNames	as string[]
	netNameTemp	as string
	netFind		as timer_t
	msgAPI		as string
	lanServer	as lanServer_t
	status		as string
	
	lanServer.exist = false
	lanServer.port = 1025	
	
	listener = CreateBroadcastListener(45631)
	netFind = setTimer(2500)

	repeat
		inMsg = GetBroadcastMessage(listener)
		while (inMsg > 0)
			netNameTemp = GetNetworkMessageString(inMsg)
			found = false
			for i = 0 to netNames.length
				if netNames[i] = netNameTemp
					found = true
					exit
				endif
			next i
			if not found
				netNames.insert(netNameTemp)
			endif
			DeleteNetworkMessage(inMsg)
			inMsg = GetBroadcastMessage(listener)
		endwhile

		if netNames.length = nil
			placeStatusText("No Network Found")
		else
			for i = 0 to netNames.length
				if netNames[i] = "QLightNet"
					lanServer.exist = true
					lanServer.directConnect = true
				endif
				placeStatusText(netNames[i])
			next i
		endif
		sync()
	until getTimer(netFind)
	
	DeleteBroadcastListener(listener)
	
	if not lanServer.exist
		updateStatusText("Finding LAN host on server")
		sync()
		msgAPI = getServerIP()
		status = GetStringToken(msgAPI, ":", 1)
		if status = "OK"
			lanServer.exist = true
			lanServer.directConnect = false
			lanServer.ip = GetStringToken(msgAPI, ":", 2)
		endif
	endif
	
	clearTextSingle(txt.status)
	//testGeneral(lanServer.toJSON())

endfunction lanServer

//************************************************* LAN Server *********************************************************

function networkEmitter(net ref as network_t, cmd as integer, cue ref as cueLight_t, clock as clock_t)
	
	emitCueLAN as integer = true 

	select cmd
	case enum.close
		closeLanHost(net)
	endCase
	case enum.countdown
		emitCueLAN = false
	endCase
	case enum.playPause
		emitCueLAN = false
	endCase
	case enum.reset
		emitCueLAN = false
	endCase
	case enum.wait // red
		cue.colorStep = 2
	endCase
	case enum.ready // yellow
		cue.colorStep = 1
	endCase
	case enum.action // green
		cue.colorStep = 0
	endCase
	case enum.text
		cue.textOn = not cue.textOn
	endCase
	endSelect

	if emitCueLAN
		sendCueLAN(net, cue)
	else
		sendCountdownLAN(net, cmd, clock)
	endif

endFunction

function receiveClientsConnect(net ref as network_t, mode as integer, cue as cueLight_t, clock as clock_t)

	newClientAck	as integer
	clientName		as string
	clientRemoval	as integer
	clientConnectID	as integer
	tc				as client_t
	msg				as string
	transmitJSON	as string
	subMode			as string

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
					newClientAck = createNetworkMessage()
					if mode = enum.countdown
						transmitJSON = clock.toJSON()
					else
						transmitJSON = cue.toJSON()
					endif
					subMode = str(0)
					msg = str(enum.newClient) + "|" + str(mode) + ">" + str(net.hostID) + "|" + subMode + "|" + transmitJSON
					AddNetworkMessageString(newClientAck, msg)
					sendNetworkMessage(net.id, clientConnectID, newClientAck)
				endif
			endif
		endif
		clientConnectID = GetNetworkNextClient(net.id)
	endWhile
	
	net.clientCount = GetNetworkNumClients(net.id) - 1
	
endFunction

function receiveClientsDisconnect(net ref as network_t)
	
	clientConnectID	as integer
	
	clientConnectID = GetNetworkFirstClient(net.id)
	
	while clientConnectID > 0 and net.clients.length < maxClients
		if GetNetworkClientDisconnected(net.id, clientConnectID)
			if GetNetworkClientUserData(net.id, clientConnectID, 0) = 0
				SetNetworkClientUserData(net.id, clientConnectID, 0, 1)
				DeleteNetworkClient(net.id, clientConnectID)
			endif
			removeClient(net, clientConnectID)
		endif
		clientConnectID = GetNetworkNextClient(net.id)	
	endWhile
	
	net.clientCount = GetNetworkNumClients(net.id) - 1
	
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

function closeLanHost(net ref as network_t)

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

	transmitJSON	as string
	mode			as string
	subMode			as string
	msg				as string

	cueUpdate = CreateNetworkMessage()
	transmitJSON = cue.toJSON()
	mode = str(enum.cue)
	subMode = str(0)
	msg = mode + "|" + subMode + "|" + transmitJSON

	AddNetworkMessageString(cueUpdate, msg)
	SendNetworkMessage(net.id, 0, cueUpdate)

endFunction

function sendCountdownLAN(net as network_t, cmd as integer, clock as clock_t)
	
	transmitJSON	as string
	mode			as string
	subMode			as string
	msg				as string

	cueUpdate = CreateNetworkMessage()
	transmitJSON = clock.toJSON()
	mode = str(enum.countdown)
	subMode = str(cmd)
	msg = mode + "|" + subMode + "|" + transmitJSON

	AddNetworkMessageString(cueUpdate, msg)
	SendNetworkMessage(net.id, 0, cueUpdate)
	
endFunction

//************************************************* LAN Client *********************************************************

function joinHost(net ref as network_t, lanServer as lanServer_t)

	ok as integer = false

	if lanServer.directConnect
		net.id = JoinNetwork("QLightNet", app.id)
	else
		net.id = JoinNetwork(lanServer.ip, lanServer.port, app.id)
	endif

	if IsNetworkActive(net.id) and lanServer.ip <> device.privateIP
		ok = true
	endif
	
endFunction ok

function disconnectHost(net as network_t)

	out as string
	disconnect as integer

	out = "disconnect:" + str(net.clientID)

	disconnect = CreateNetworkMessage()
	AddNetworkMessageString(disconnect, out)
	SendNetworkMessage(net.id, net.hostID, disconnect)	

endFunction

function receiveServerAck(net ref as network_t)

	netMsg		as message_t
	serverMsg	as integer
	IDs			as string
	temp		as string
	newClient	as integer

	serverMsg = GetNetworkMessage(net.id)

	if serverMsg <> 0
		temp = GetNetworkMessageString(serverMsg)
	endif

	if CountStringTokens(temp, "|") > 0
		newClient = val(GetStringToken(temp, "|", 1))
	endif
	
	if newCLient = enum.newClient
		IDs = GetStringToken(temp, "|", 2)	
		if CountStringTokens(IDs, ">") > 0
			net.clientID = GetNetworkMyClientID(net.id)
			netMsg.mode = val(GetStringToken(IDs, ">", 1))
			net.hostID = val(GetStringToken(IDs, ">", 2))
		endif
		netMsg.subMode = val(GetStringToken(temp, "|", 3))
		netMsg.inJSON = GetStringToken(temp, "|", 4)
		netMsg.new = true
	endif

	DeleteNetworkMessage(serverMsg)	

endFunction netMsg

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

	netMsg.new = false
	serverMsg = GetNetworkMessage(net.id)
	if serverMsg <> 0
		temp = GetNetworkMessageString(serverMsg)
		if CountStringTokens(temp, "|") > 0
			netMsg.mode = val(GetStringToken(temp, "|", 1))
			netMsg.subMode = val(GetStringToken(temp, "|", 2))
			netMsg.inJSON = GetStringToken(temp, "|", 3)
			netMsg.new = true
		endif
		DeleteNetworkMessage(serverMsg)
	endif
	
endFunction netMsg

//************************************************* Countdown Functions ************************************************

function getOrientationChange(prop ref as property_t)

	out as integer
	out = testOrientationUpdate(prop)

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
