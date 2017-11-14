-- load modules
local youtube = require "youtube"

hs.hotkey.bind({"cmd", "ctrl"}, "a", function()
  print('Hello')
  youtube.transitionToVideo()
end)


hs.hotkey.bind({"cmd", "ctrl"}, "s", function()
state, result = hs.osascript.applescript("tell application \"Safari\" \n set timeStamp to do JavaScript \"function ts() {var player = document.getElementById('movie_player') ||document.getElementsByTagName('embed')[0];player.pauseVideo();return player.getCurrentTime();} ts();\" in document 1 \n return timeStamp \n end tell")
print(state)
print(result) 

hs.itunes.setPosition(result)
hs.itunes.play()
hs.application.launchOrFocus("itunes")
    --[[print('hey')
        local options = {
            developerExtrasEnabled = true,
    }
   webView = hs.webview.newBrowser({
            x = 100, y = 100,
            h = 500, w = 500
        }, options )
   webView:url('https://www.youtube.com/'):show()
   --webView.bringToFront(true) brauchen wir nicht, ersetzt durch Zeile22
   webViewWindow = webView:hswindow()
   webViewWindow:maximize()
   webViewWindow:raise()
 --]]
 end)   
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
hs.timer.doAt("10:45", function() hs.itunes.play() end)
