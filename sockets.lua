--
-- Control your power outlets using hammerspoon
-- 	this is based on the ESP8266 Smartclock project
--	more information: https://github.com/Stunkymonkey/esp8266-smartclock
--

-- base URL of ESP8266 Webserver
local url = 'http://192.168.178.102/'

local toggleSocket = function(socketIndex)
	if(socketIndex < 0 or socketIndex > 2) then print('Toggle: Invalid socketIndex') end
	print(url.."socket"..socketIndex.."Toggle")
	hs.http.doRequest(url.."socket"..socketIndex.."Toggle", "GET");
end

return {
	toggleSocket = toggleSocket
}