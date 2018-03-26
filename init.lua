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

