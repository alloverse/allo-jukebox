local gme = require("gmeplayer")

local player = gme.TrackListPlayer()
local musicFiles = io.popen('find '..srcDir..'/../music -type f')
for file in musicFiles:lines() do
    print("Adding ", file)
    player:addTracksInFile(file)
end

local client = Client(
    arg[1], 
    "allo-jukebox"
)
local app = App(client)

local jukebox = ui.View(ui.Bounds(2, 0, -1,   1, 0.5, 0.1))

local controlBoard = ui.Surface(ui.Bounds(0, 0.7, 0,   1, 0.5, 0.1))
controlBoard.bounds.pose:rotate(3.14159/4, 1, 0, 0)
jukebox:addSubview(controlBoard)

local prevButton = ui.Button(ui.Bounds(-0.3, 0.05, 0.0,   0.2, 0.2, 0.1))
local pauseButton = ui.Button(ui.Bounds(0.0, 0.05, 0.0,   0.2, 0.2, 0.1))
local nextButton = ui.Button(ui.Bounds( 0.3, 0.05, 0.0,   0.2, 0.2, 0.1))
local leftSpeaker = ui.Speaker(ui.Bounds(-1.1, 0.05, 0.0,   0.2, 0.2, 0.1))
local rightSpeaker = ui.Speaker(ui.Bounds(1.1, 0.05, 0.0,   0.2, 0.2, 0.1))

controlBoard:addSubview(prevButton)
controlBoard:addSubview(pauseButton)
controlBoard:addSubview(nextButton)
controlBoard:addSubview(leftSpeaker)
controlBoard:addSubview(rightSpeaker)

pauseButton.onActivated = function()
    player:setPaused(not player:isPaused())
    print(player.isPaused and "Play" or "Pause", ":", player:currentTrackDescription())
end
prevButton.onActivated = function()
    player:prevTrack()
    print("Prev track: ", player:currentTrackDescription())
end
nextButton.onActivated = function()
    player:nextTrack()
    print("Next track: ", player:currentTrackDescription())
end


app:scheduleAction(0.02, true, function()
    local leftTrack = leftSpeaker.trackId
    local rightTrack = rightSpeaker.trackId
    local left, right = player:generateAudio(960)
    if leftTrack and left and right then
        app.client.client:send_audio(leftTrack, left)
        app.client.client:send_audio(rightTrack, right)
    end
end)

app.mainView = jukebox
app:connect()
app:run()