local gme = require("gmeplayer")
local tablex = require("pl.tablex")

local player = gme.TrackListPlayer()
local musicFilesProc = io.popen('find '..arg[1]..'/music -type f')
local musicFiles = {}
for file in musicFilesProc:lines() do
    table.insert(musicFiles, file)
end
musicFilesProc:close()
for _, file in tablex.sort(musicFiles) do
    print("Adding ", file)
    player:addTracksInFile(file)
end

local client = Client(
    arg[2], 
    "allo-jukebox"
)
local app = App(client)
local Jukebox = {
    assets= {
        prev = ui.Asset.Base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAG1SURBVGhD1Zm7TgMxEAAD/AsF/4DEd/ItFEhUiBaJBlEDLbRITGQrOo6zz69d746iyGkuM94kd0nObp8eD265e3s9j0uHYM+914BgDy4DTvbgL2BpD84CVvbgKeC/PbgJ2LQHHwEpe3AQkLEH6wF5ezAdsGsPpddC799fcaXF8+dHXGWRncDP/QO3+EAGqYClumiDSID0ri8ZH6BpD4MDlO1hZIC+PQwLmGIPYwJm2cOAE5mE/cXNtdKJTGjvyw/bFZB6GvYvruRpD8jbqzU0BljY+0DLm1jIfnXYl6vLuMpSPQE7ex+oC7BmDxUBBu2h/VMoMNceSgM2t3+6PfROYDqlAZubnXpXaNI7gekNFQGpV/zchroJGGyofglZa2j8QpPSXeZ1JkldCwXszKH9UyjfoFbSHgAW5tAVAKmGTsoPO+bn9d0tb+hU/XldaA4ljAmAWQ3DAmBKw8gA0G8YHADKDeMDQLNBJABoOGWI9kgFBJYZQsgGKFB6Ji7503wKRRMwaw/7AZbtYSfAuD0kA1C3bw/bAS7UAxsBjuxhHeDLHv4EuLOHGIC6R3s4BjhVP3I4/AJOwc2Q7k4s+AAAAABJRU5ErkJggg=="),
        pause = ui.Asset.Base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAF7SURBVGhD7Zm9TsNAEAYNPBcSz8mzUCBRIVpKRA200CIxkQ90JOefJN/u3kqewjrZzYzOe4nki9unxyEtd68vl2WZEOy5Zg0Y7SFlwJ895Auo7SFZwJ49ZAo4tIc0AU17yBEwZQ8JAmbsofeAeXvoOmDRHtb+F3r7+iwrL54/3stqljSn0BRbQDRnzcD3/UNZ/XJ1c11W1dP65nqCZ6BuO+wU4vQK2TX4zYBRg+sQWzR4n0LyBu8A0DYEBICwISYAVA1OAc3fMkmD3w4YNbi+QhYN3jMgbwgYYm1DQAAIG2ICQNUQFgDNhmOJDDjz/BkJC2jan7AnMQEqewgIENqDd4DWHlwD5PbgF2BhD04BRvYQMMQjEnuICVDZQ0CA0B68A7T24Bogtwe/AAt7cAowsgergNrYzh62j3zRbAHRrJ2BNR/NQ1i1A93aw3JAz/awENC5PUwGoN6/PbQDUqiPNAIS2cN+QC57+BeQzh5KAOoZ7WEXkFR9xzD8AB43p0o1zRr1AAAAAElFTkSuQmCC"),
        next = ui.Asset.Base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAG2SURBVGhD1ZmxTsMwEEADfBcS38l3VEwMSEyIlRGxVQJWWJF4xVYErpMc9Z3P91RV7tK+Z8dJ2p5dPz5MYbl9eT7Pw4Bgz3PUgGQPIQNme4gX8NseggUU9hAp4NgewgRU7SFGwJI9BAhYsYfRA9btYeiATXuQ3gu9fn7kUS+e3t/yaBXbFfi6u+eRX9hgGDCrmzZYBRTSdg39NrFRQ9ezkEVD1wBQb+gdALoNDgGg2PC/C5nu5F1cXeZRDf0LWYt91VVlOqQB7R9m1NB1D1g09N7E6g3STbzf3eTRD+v7b5OqcfGeQ9yNLqG4Dj4BoNXgFgAqDZ4B0N7gHACNDf4BUG0QMkTAaeefhH9A1V6+Js4BjfbgGdBuD24BKvZw4r2QnKqTxH6UeyFcC12tuU/0PoR07aFrgLo9SAMaPwYs7MHq5/WqbsG6/dBfaKB97hM+AVr24BCgaA+9A3TtoWuAuj24bWItrAKOJ9ti+sFwBWZjBkb2YHsImaonpFdiyZ/mLohWYFh72A4Y2R42Aga3h8UA1Me3h3pACPVEJSCQPZQBsezhT0A4e8gBqEe0h0NAUPUD0/QNT6PWkOV/4K8AAAAASUVORK5CYII="),
        quit = ui.Asset.Base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAABHNCSVQICAgIfAhkiAAABUtJREFUeJztm+1TGlcUxp9dcEEQ1wFl7VjT5sXMRE3SWmOssUkax6oBtNM/r39DJ8bXWKNJG3XaRGPbqJlpY0zrS+sC4cUFFYHdfohaQMC9cLc6kOfj7p5nz/l593Dv3pX5dvapgiLVxMoy2JNO4qQ0sbIMAMUJ4KB4oAgBJBYPFBmA1OKBIgKQrnigSABkKh4oAgDZigcKHMBxxQMFDEBN8UCBAlBbPFCAAEiKBwB9LjfZDEm5hGmuRbdIHFNwI4BU7wFoaa4PhaAPBDNfoHYhrmi3YtcMQEkgAKF/EMLQCHThcPqLmON9TCtv8MF398Du7NJNcF+aAODcHlT3D0AvSdBLEuxDI2AjEWKf0r9WUTk+Ac7jhTAwqAkE6gCM6xuoHhxOSpbz+WEfeQAmFiPyqRobByPLhx7CwCB04W2q+VIFYF5+DWHkAZi9vSPnDJsi7GPjwH5B2WT4ZxP20TEw8XjScc7nR3X/fZQEs/QVQlEDYFl6icqHk0BK0okyrq6hcvJx+ua3f4xzu2EfHs04WvRbEoR7A+A8XgpZUwLAz83D+uOUqm5tfrUM68zM0RMM3j3rQ6Ngo9GsHrqdHQj3B2HY+DvXlA+VNwBdeBvlLxaIYiwvFsHPzScdK/H5IAyrb5ZsNApheBTGPCHkBCDx7xw3m+B2dEMuKSHyqHg2C8vSSwBASTAIYXCEuMtHbTbs2auIYlJF5RGICAI83Z1QWDI765NpWBaWYB8Yhm6brLvvVdoguu4Sg08VtSa4W1sLb2cHWZCiwDo1DX0oRBQWtVohupyQDQay+6VR/gASnoft8+fgu9met2U2RXkeossBudRIxS9vAErKdFZqbECwpTlf27SKlVsg9rkQN5uoeWoyFQ40fwbpciNVz1hZGcReF+JlZqq+mi2GfO03EK67QMUrbjLB3edErNxCxS9R2i2HGcDb8SV2z9TmZSOXGiH2OhDleUqJJUvbFyIsC3f3Vzn/VssGA0SXE1GrlXJi/0n7N0IsC5njcgqN2KuwZ7NRTihZ2gKQZVR+/xDG9Y2cwkvX1mGdmqacVLK0A6AoqJx4BNObP/OysSwuoWL2OZ2c0kgbAApge/QDzMuvqdjxs3OwLCxS8UoVfQCKAtuTKZT9/gdVW+vUDMyvyDY91Ig6AOvMTyjbX+XRlm3yMYyra1Q9qQKo+PkpLITvBkjEyDLsY+PgRDc1T2oAKuaeg5//lSyIYbB99mOykFgMwvAoOL+f7F4ZRAVA+S+/gX82Rxznb2uFp6cLW1evEMWxkQiqhkahl/Lfo6QCQDZwAKNilyNBgdbrh4X721oRvlhHFK8PhWBZzL/X5AQgtdRQ/SV4ujoBnU5VfLC5CcGmTxIMGXjv3MbOR2dU5yBdaYS/9brq6zMp7xFwAGP73FmIzh4ox0x7tz69ikDLtTSZsPB0dSJSXX3sPQMt1+Brv6Fqa+04Uf0V2K2pwWafE/HS0rTnpcuN8H/emjFe0evhdnQjasuw+GEY+G59gWBzE410AWgwD9irqoL4TR/i5uQXF6H6S/C1tx0b/24F6Di69tfp4O3sgNRQTzNdbabCUZ6H+LXrEEL4Yh3e3rqpulHGTSa4XY7DkaRwHERHD8IXzlPPVbPF0AEEqbEBb+/cJn5eozwPt/MuYuXl2Ox1YvfDGi3SBJPL/wv8n98IMbKser+hIL8RIt1sIdWpB6C13gM46QROWjl9KJlLszmtIh4BpJ+innYRASi04gECAIVYPKCiBxRq4QfKOgIKvXggC4BiKB7IAKBYigfSACim4oGEJlhshR+IBYq3eAD4FzLNyUTM0XqEAAAAAElFTkSuQmCC"),
    }
}
app.assetManager:add(Jukebox.assets)

local pi = 3.14159

local jukebox = ui.View(ui.Bounds(2, 1.4, -1,   1, 0.5, 0.1))

local controlBoard = ui.Cube(ui.Bounds(0, 0, 0,   1, 0.5, 0.01))
controlBoard.color = {0.5, 0.7, 0.7, 1.0}
controlBoard.bounds.pose:rotate(-pi/4, 1, 0, 0)
controlBoard.grabbable = true
jukebox:addSubview(controlBoard)

local prevButton = ui.Button(ui.Bounds(-0.3, 0.05, 0.06,   0.2, 0.2, 0.1))
prevButton:setDefaultTexture(Jukebox.assets.prev)
local pauseButton = ui.Button(ui.Bounds(0.0, 0.05, 0.06,   0.2, 0.2, 0.1))
pauseButton:setDefaultTexture(Jukebox.assets.pause)
local nextButton = ui.Button(ui.Bounds( 0.3, 0.05, 0.06,   0.2, 0.2, 0.1))
nextButton:setDefaultTexture(Jukebox.assets.next)
local leftSpeaker = ui.Speaker(ui.Bounds(-1.1, 0.05, 0.0,   0.2, 0.2, 0.1))
local rightSpeaker = ui.Speaker(ui.Bounds(1.1, 0.05, 0.0,   0.2, 0.2, 0.1))
local grabHandle = ui.GrabHandle(ui.Bounds{size=ui.Size(0.2,0.2,0.2)}:move(-0.52,0.25,0.01))
local quitButton = ui.Button(ui.Bounds{size=ui.Size(0.12,0.12,0.05)}:move( 0.52,0.25,0.025))
quitButton:setDefaultTexture(Jukebox.assets.quit)
local volumeSlider = ui.Slider(ui.Bounds(0, -0.12, 0.01,   0.8, 0.08, 0.05))
volumeSlider:currentValue(1.0)

local label = ui.Label{
    bounds=ui.Bounds(-0.10, -0.18, 0.01,   0.6, 0.05, 0.01),
    halign="left",
}
label.text = "Nevyn's Retro Jukebox"

controlBoard:addSubview(prevButton)
controlBoard:addSubview(pauseButton)
controlBoard:addSubview(nextButton)
controlBoard:addSubview(label)
controlBoard:addSubview(leftSpeaker)
controlBoard:addSubview(rightSpeaker)
controlBoard:addSubview(quitButton)
controlBoard:addSubview(volumeSlider)


pauseButton.onActivated = function()
    player:setPaused(not player:isPaused())
    label:setText(player:currentTrackDescription())
    print(player.isPaused and "Play" or "Pause", ":", player:currentTrackDescription())
end
prevButton.onActivated = function()
    player:prevTrack()
    label:setText(player:currentTrackDescription())
    print("Prev track: ", player:currentTrackDescription())
end
nextButton.onActivated = function()
    player:nextTrack()
    label:setText(player:currentTrackDescription())
    print("Next track: ", player:currentTrackDescription())
end
quitButton.onActivated = function()
    app:quit()
end
volumeSlider.onValueChanged = function(v, newValue)
    player:setVolume(newValue)
end


app:scheduleAction(0.02, true, function()
    local leftTrack = leftSpeaker.trackId
    local rightTrack = rightSpeaker.trackId
    local left, right = player:generateAudio(960)
    if leftTrack and left and right then
        app.client.client:send_audio(leftTrack, left)
        --app.client.client:send_audio(rightTrack, right)
    end

    if player:hasEnded() then
        nextButton.onActivated()
    end
end)

app.mainView = jukebox
app:connect()
app:run(100)
