## New network model

Current model isn't really working - plenty of more public networks have restrictions either in what ports are available and/or may not allow cross-network traffic.

So will have to chenge to using port 80 for network traffic - and in cases where intra-network traffic is disallowed - have the server relay commands from controller to clients.

Port 443 will be reserved for traffic to and from the server.

Internet will be required for clients as IP of controller and clients will have to be requested from it - so no autodiscovery. 