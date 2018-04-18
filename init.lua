-- load modules
local youtube = require "youtube"
local sockets = require "sockets"



-- hyper key binding using: https://github.com/tekezo/Karabiner-Elements
local hyper = {"cmd", "alt"}

-- hotkey bindings

hs.hotkey.bind({"cmd", "ctrl"}, "s", function()
	youtube.transitionToVideo()
end)


-- _wifi watcher
wifiwatcher = hs.wifi.watcher.new(function ()
	network = hs.wifi.currentNetwork()
	if network==nil then
		subTitle = 'Disconnected'
	else
		subTitle = 'Connected to ' .. network
		--if network == 'eduroam' then initUni() end
	end
--	hs.notify.new({title        = 'Wi-Fi Status',subTitle     = subTitle,}):send()
end)
wifiwatcher:start()


-- Reload config when any lua file in config directory changes, to save having to manually reload.
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == '.lua' then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end


-- Show date,time,battery and temperatur using DHT22
hs.hotkey.bind({ "cmd", "ctrl"},'+', function()
    local seconds = 3
    local message = os.date("%I:%M%p") .. "\n" .. os.date("%a %b %d") .. "\nBattery: " ..
    hs.battery.percentage() .. "%"
    httpStatus, body, header = hs.http.doRequest("http://192.168.178.34/sensorData", "GET", nil, nil)
        if httpStatus==200 then
            responseTable = hs.json.decode(body)
            temperaturId = responseTable.temperatur
            message = message .. "\n Temperatur: \n"..temperaturId..""  

        end
        hs.alert.show(message, seconds)

  end)