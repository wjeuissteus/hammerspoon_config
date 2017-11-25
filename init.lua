-- Spotify to YouTube Video


-- load modules
local youtube = require "youtube"


hs.hotkey.bind({"cmd", "ctrl"}, "y", function()
    print('Hello')
  youtube.transitionToVideo()
end)

--hs.hotkey.bind({"cmd", "ctrl"}, "x",function()
--print('Loading URL')
--state, result = hs.osascript.applescript("tell application \"Safari\" \n set theURL to URL of front document \n return theURL \n end tell")
--print(result)
--end)

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
local myWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
hs.timer.doAt("10:45", function() hs.spotify.play() end)