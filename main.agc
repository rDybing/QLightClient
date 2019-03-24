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
#include "fileIO.agc"
#include "chores.agc"
#include "errors.agc"
#include "types.agc"
#include "constants.agc"
#include "tests.agc"

#constant version		= "v0.0.1"
#constant appName		= "QLightClient"
#constant false			= 0
#constant true			= 1
#constant nil			= -1
#constant maxLocal		= 0

global media		as media_t				// constant IDs
global font			as font_t				// constant IDs
global layer		as layer_t				// constant layer values
global sound 		as sound_t				// constant IDs
global sprite		as sprite_t				// constant IDs
global tween		as tween_t				// constant IDs
global txt			as txt_t				// constant IDs
global ml 			as menuLang_t[maxLocal]	// constant language strings
global device 		as device_t				// constant after init
global app			as appSettings_t		// constant after init
global color		as color_t[9]			// constant after init
global state		as globalState_t		// will change here and there

setStartState()
setDevice()

SetRandomSeed(GetUnixTime())

loadAppSettings()

if app.id = "ERROR"
	noSettingsFileError()
endif

if app.id = ""
	app.id = createAppID()
	saveAppSettings()
endif


initConstants()
initLang(ml)
initColor()
loadMedia()

SetErrorMode(2)
SetWindowTitle("QLight Client")
SetWindowSize(device.width, device.height, 0)
SetWindowAllowResize(1)
SetDisplayAspect(device.aspect)
SetScissor(0,0,0,0)
SetOrientationAllowed(1, 1, 0, 0)
SetSyncRate(30, 0)
UseNewDefaultFonts(1)
SetPrintSize(2.0)
SetPrintColor(255, 255, 0)

setBackground(9)
/*
initWaitSprite()
setLogo()
showVersion()
getPrivateIP()
*/

main()

function main ()
	testClock()
	appJSON as string
	if not state.fatalError
		appJSON = app.toJSON()
		do
			print("In JSON")
			print(appJSON)
			print("In Type:")
			print(app.id)
			print(app.apiIP)
			print(app.apiPort)
			print(app.apiId)
			print(app.apiKey)
			sync()
		loop
	endif
endFunction
