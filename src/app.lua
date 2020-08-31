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

local pi = 3.14159

local jukebox = ui.View(ui.Bounds(2, 0, -1,   1, 0.5, 0.1))

local controlBoard = ui.Surface(ui.Bounds(0, 0.7, 0,   1, 0.5, 0.1))
controlBoard.bounds.pose:rotate(-pi/4, 1, 0, 0)
jukebox:addSubview(controlBoard)

local prevButton = ui.Button(ui.Bounds(-0.3, 0.05, 0.01,   0.2, 0.2, 0.1))
prevButton:setDefaultTexture("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAG1SURBVGhD1Zm7TgMxEAAD/AsF/4DEd/ItFEhUiBaJBlEDLbRITGQrOo6zz69d746iyGkuM94kd0nObp8eD265e3s9j0uHYM+914BgDy4DTvbgL2BpD84CVvbgKeC/PbgJ2LQHHwEpe3AQkLEH6wF5ezAdsGsPpddC799fcaXF8+dHXGWRncDP/QO3+EAGqYClumiDSID0ri8ZH6BpD4MDlO1hZIC+PQwLmGIPYwJm2cOAE5mE/cXNtdKJTGjvyw/bFZB6GvYvruRpD8jbqzU0BljY+0DLm1jIfnXYl6vLuMpSPQE7ex+oC7BmDxUBBu2h/VMoMNceSgM2t3+6PfROYDqlAZubnXpXaNI7gekNFQGpV/zchroJGGyofglZa2j8QpPSXeZ1JkldCwXszKH9UyjfoFbSHgAW5tAVAKmGTsoPO+bn9d0tb+hU/XldaA4ljAmAWQ3DAmBKw8gA0G8YHADKDeMDQLNBJABoOGWI9kgFBJYZQsgGKFB6Ji7503wKRRMwaw/7AZbtYSfAuD0kA1C3bw/bAS7UAxsBjuxhHeDLHv4EuLOHGIC6R3s4BjhVP3I4/AJOwc2Q7k4s+AAAAABJRU5ErkJggg==")
local pauseButton = ui.Button(ui.Bounds(0.0, 0.05, 0.01,   0.2, 0.2, 0.1))
pauseButton:setDefaultTexture("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAF7SURBVGhD7Zm9TsNAEAYNPBcSz8mzUCBRIVpKRA200CIxkQ90JOefJN/u3kqewjrZzYzOe4nki9unxyEtd68vl2WZEOy5Zg0Y7SFlwJ895Auo7SFZwJ49ZAo4tIc0AU17yBEwZQ8JAmbsofeAeXvoOmDRHtb+F3r7+iwrL54/3stqljSn0BRbQDRnzcD3/UNZ/XJ1c11W1dP65nqCZ6BuO+wU4vQK2TX4zYBRg+sQWzR4n0LyBu8A0DYEBICwISYAVA1OAc3fMkmD3w4YNbi+QhYN3jMgbwgYYm1DQAAIG2ICQNUQFgDNhmOJDDjz/BkJC2jan7AnMQEqewgIENqDd4DWHlwD5PbgF2BhD04BRvYQMMQjEnuICVDZQ0CA0B68A7T24Bogtwe/AAt7cAowsgergNrYzh62j3zRbAHRrJ2BNR/NQ1i1A93aw3JAz/awENC5PUwGoN6/PbQDUqiPNAIS2cN+QC57+BeQzh5KAOoZ7WEXkFR9xzD8AB43p0o1zRr1AAAAAElFTkSuQmCC")
local nextButton = ui.Button(ui.Bounds( 0.3, 0.05, 0.01,   0.2, 0.2, 0.1))
nextButton:setDefaultTexture("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAG2SURBVGhD1ZmxTsMwEEADfBcS38l3VEwMSEyIlRGxVQJWWJF4xVYErpMc9Z3P91RV7tK+Z8dJ2p5dPz5MYbl9eT7Pw4Bgz3PUgGQPIQNme4gX8NseggUU9hAp4NgewgRU7SFGwJI9BAhYsYfRA9btYeiATXuQ3gu9fn7kUS+e3t/yaBXbFfi6u+eRX9hgGDCrmzZYBRTSdg39NrFRQ9ezkEVD1wBQb+gdALoNDgGg2PC/C5nu5F1cXeZRDf0LWYt91VVlOqQB7R9m1NB1D1g09N7E6g3STbzf3eTRD+v7b5OqcfGeQ9yNLqG4Dj4BoNXgFgAqDZ4B0N7gHACNDf4BUG0QMkTAaeefhH9A1V6+Js4BjfbgGdBuD24BKvZw4r2QnKqTxH6UeyFcC12tuU/0PoR07aFrgLo9SAMaPwYs7MHq5/WqbsG6/dBfaKB97hM+AVr24BCgaA+9A3TtoWuAuj24bWItrAKOJ9ti+sFwBWZjBkb2YHsImaonpFdiyZ/mLohWYFh72A4Y2R42Aga3h8UA1Me3h3pACPVEJSCQPZQBsezhT0A4e8gBqEe0h0NAUPUD0/QNT6PWkOV/4K8AAAAASUVORK5CYII=")
local leftSpeaker = ui.Speaker(ui.Bounds(-1.1, 0.05, 0.0,   0.2, 0.2, 0.1))
local rightSpeaker = ui.Speaker(ui.Bounds(1.1, 0.05, 0.0,   0.2, 0.2, 0.1))
local grabHandle = ui.GrabHandle(ui.Bounds{size=ui.Size(0.2,0.2,0.2)}:rotate(-pi/2,0,1,0):move(-0.50,0.40,-0.6))


controlBoard:addSubview(prevButton)
controlBoard:addSubview(pauseButton)
controlBoard:addSubview(nextButton)
controlBoard:addSubview(leftSpeaker)
controlBoard:addSubview(rightSpeaker)
jukebox:addSubview(grabHandle)


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
        --app.client.client:send_audio(rightTrack, right)
    end
end)

app.mainView = jukebox
app:connect()
app:run()