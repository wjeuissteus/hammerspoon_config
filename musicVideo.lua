--
-- Continues your iTunes/Spotify song as YouTube Music Video
-- Currently only works with Safari
--

-- seconds to wait for the movie in browser
local loadingDelay = 7
-- replace with your Google API key
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

function transitionToVideo(player)
  if player.getPlaybackState() ~= player.state_playing then return end
  track = player.getCurrentTrack()
  artist = player.getCurrentArtist()

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
      currentTrackPosition = player.getPosition()+loadingDelay
      currentTrackPositionSeconds = tostring(math.floor(currentTrackPosition % 60))
      currentTrackPositionMinutes = tostring(math.floor(currentTrackPosition/60))
      -- open youtube url
      resultYoutubeURL = "https://youtube.com/watch?v="..videoId.."&t="..currentTrackPositionMinutes.."m"..currentTrackPositionSeconds.."s"
      hs.urlevent.openURL(resultYoutubeURL)

      if timer then timer:stop() timer = nil end
      timer = hs.timer.delayed.new(loadingDelay, function()  
        -- pause spotify
        player.pause()
      end):start()
    else
      hs.alert.show("Error connecting to Youtube API")
    end
  end)
end

function transitionBack(player) {
  state, result = hs.osascript.applescript("tell application \"Safari\" \n set timeStamp to do JavaScript \"function ts() {var player = document.getElementById('movie_player') ||document.getElementsByTagName('embed')[0];player.pauseVideo();return player.getCurrentTime();} ts();\" in document 1 \n return timeStamp \n end tell")
  player.setPosition(result)
  player.play()
}

-- makes smooth transition between spotify track and corresponding youtube video
local transitionBackToSpotify = function()
  transitionBack(hs.spotify)
  hs.application.launchOrFocus("Spotify")  
end

-- makes smooth transition between iTunes track and corresponding youtube video
local transitionBackToiTunes = function()
  transitionBack(hs.itunes)
  hs.application.launchOrFocus("iTunes")
end

local transitionFromSpotifyToVideo = function() {
  transitionToVideo(hs.spotify)
}

local transitionFromiTunesToVideo = function() {
  transitionToVideo(hs.itunes)
}

return {
  transitionBackToSpotify = transitionBackToSpotify,
  transitionBackToiTunes = transitionBackToiTunes,
  transitionFromSpotifyToVideo = transitionFromSpotifyToVideo,
  transitionFromiTunesToVideo = transitionFromiTunesToVideo
}
