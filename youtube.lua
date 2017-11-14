local loadingDelay = 6
local keys = require "api_key"
local apiKey = keys.youtubeKey


function urlencode(str)
   if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
     function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
   end
   return str    
end

function openURLinWebView(url)
   webView = hs.webview.newBrowser({ x = 100, y = 100, h = 500, w = 500})
   webView:url(url):show()
   webViewWindow = webView:hswindow()
   webViewWindow:maximize()
   webViewWindow:raise()
  
end
  -- makes smooth transition between itunes track and corresponding youtube video
 local transitionBackToiTunes = function()
  state, result = hs.osascript.applescript("tell application \"Safari\" \n set timeStamp to do JavaScript \"function ts() {var player = document.getElementById('movie_player') ||document.getElementsByTagName('embed')[0];player.pauseVideo();return player.getCurrentTime();} ts();\" in document 1 \n return timeStamp \n end tell")
  hs.itunes.setPosition(result)
  hs.itunes.play()
  hs.application.launchOrFocus("itunes")
 end
local transitionToVideo = function()
  if hs.itunes.getPlaybackState() ~= hs.itunes.state_playing then return end
  track = hs.itunes.getCurrentTrack()
  artist = hs.itunes.getCurrentArtist()

  searchQuery = urlencode(track).."%20"..urlencode(artist).."%20music%20video"
  apiURL = "https://www.googleapis.com/youtube/v3/search/?part=snippet&q="..searchQuery.."&key="..apiKey
  hs.http.doAsyncRequest(apiURL, "GET", nil, nil, function(httpStatus, body, header)
    if httpStatus==200 then
      responseTable = hs.json.decode(body)
      -- inspect the returned json body and output title
      videoId = responseTable.items[1].id.videoId
      title = responseTable.items[1].snippet.title
      hs.alert.show("Start playing: \n"..title)

      -- determine the current track position
      currentTrackPosition = hs.itunes.getPosition()+loadingDelay
      currentTrackPositionSeconds = tostring(math.floor(currentTrackPosition % 60))
      currentTrackPositionMinutes = tostring(math.floor(currentTrackPosition/60))
      -- open youtube url
      resultYoutubeURL = "https://youtube.com/watch?v="..videoId.."&t="..currentTrackPositionMinutes.."m"..currentTrackPositionSeconds.."s"
      hs.urlevent.openURL(resultYoutubeURL)
      --openURLinWebView(resultYoutubeURL)
      if timer then timer:stop() timer = nil end
      timer = hs.timer.delayed.new(loadingDelay, function()  
        -- pause itunes
        hs.itunes.pause()
      end):start()
    else
      hs.alert.show("Error connecting to Youtube API")
    end
  end)
end

return {
  transitionToVideo = transitionToVideo, transitionBackToiTunes = transitionBackToiTunes
}
