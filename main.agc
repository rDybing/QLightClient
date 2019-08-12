/***********************************************************************************************************************

QLightClient is Copyright 2019 Roy Dybing - all rights reserved.

Source is open to provide insight into working app, mainly to ensure any and all that this app do not collect any data
of use or user or device it is installed upon - except as explicitly noted below:

- ip of device when connecting to WAN and LAN server
- appId of app when connecting to WAN and LAN server
- time of contact with WAN and LAN server

Source is not to be used to facilitate distribution of compiled code.

Configuration files and media files are *NOT* included in this source repo.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Contact: roy[dot]dybing[at]gmail[dot]com

***********************************************************************************************************************/

#include "views.agc"
#include "output.agc"
#include "text.agc"
#include "input.agc"
#include "network.agc"
#include "httpIO.agc"
#include "fileIO.agc"
#include "chores.agc"
#include "errors.agc"
#include "types.agc"
#include "constants.agc"
#include "tests.agc"

#constant false			= 0
#constant true			= 1
#constant nil			= -1
#constant escKey		= 27
#constant maxClients	= 8

global media		as media_t				// constant IDs
global font			as font_t				// constant IDs
global layer		as layer_t				// constant layer values
global sound 		as sound_t				// constant IDs
global sprite		as sprite_t				// constant IDs
global tween		as tween_t				// constant IDs
global txt			as txt_t				// constant IDs
global ml 			as menuLang_t[]			// constant language strings after load from file
global device 		as device_t				// constant device properties
global app			as appSettings_t		// constant IP, api and key values after load from file
global color		as color_t[12]			// constant color values
global state		as globalState_t		// will change here, there and everywhere
global version		as version_t			// constant version info
global enum			as enum_t				// constant after init

initConstants()
initEnums()
initColor()
loadMedia()
setStartState()
setDevice()

SetErrorMode(2)
SetRandomSeed(GetUnixTime())

ml = loadLocalization()
loadAppSettings()
setLanguage()

if app.id = ""
	app.id = createAppID()
	saveAppSettings()
endif

SetWindowTitle(version.name)
SetWindowAllowResize(0)
SetScissor(0,0,0,0)
SetOrientationAllowed(1, 0, 0, 0)
SetVSync(1) 
UseNewDefaultFonts(0)
SetPrintSize(2.0)
SetPrintColor(255, 255, 0)

/*
getPrivateIP()
*/

main()

function main()

	appJSON		as string
	restore		as integer = false
	lanServer	as lanServer_t
	
	placeVersionText()
	
	if not state.fatalError
		splash()
		lanServer = networkAreadyExist()
		clearTextSingle(txt.server)
		if device.isComputer
			cueController(lanServer)
		else
			if restore
				cueController(lanServer)
			else
				if lanServer.exist and lanServer.ip <> device.privateIP
					cueController(lanServer)
				else
					mainMenuView(lanServer)
				endif
			endif
		endif
		appJSON = app.toJSON()
		repeat
			print("--In JSON--")
			print(appJSON)
			sync()
		until GetRawKeyReleased(escKey)
	endif

endFunction

function splash()
	
	msg				as string
	proceedTimer	as timer_t
	serverTimer		as timer_t
	
	setBackgroundColor(color[10])
	placeLogoSplash()
	
	if app.name = ""
		app.name = "Ctrl-"
	endif

	if device.isComputer
		app.mode = "noneComp"
	else
		app.mode = "noneSP"
	endif
	
	updateServerText(uploadAppInfo())
	serverTimer = setTimer(1000)
	
	repeat
		sync()
	until getTimer(serverTimer)
	
	clearTextSingle(txt.server)
	
	msg = getWelcome()
	clearTextSingle(txt.server)	
	placeStartupText(msg)
	textFade(txt.startup, txt.startup + 1, "in")
	proceedTimer = setTimer(4000)
	clearTextSingle(txt.server)
	
	repeat
		sync()
	until GetPointerPressed() or getTimer(proceedTimer)
	
	textFade(txt.startup, txt.startup + 1, "out")
	clearText(txt.startup, txt.startup + 1)
	clearSpriteSingle(sprite.logo)
	
endFunction

function modeSwitch(mode as integer, btn as button_t[], lanServer ref as lanServer_t)

	clearMainMenu(btn)

	select mode
	case enum.client
		cueController(lanServer)
	endCase
	case enum.ctrl
		controlView()
	endCase
	endSelect

endFunction
