require("liballonet")
package.path = package.path ..';../lib/?/init.lua;../lib/?.lua'
local class = require('pl.class')
local Client = require("client")
local ui = require("ui")
local mat4 = require("cpml.mat4")
local GmePlayer = require("gmeplayer")

local player = GmePlayer("mario.nsf")

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
controlBoard:addSubview(prevButton)
controlBoard:addSubview(pauseButton)
controlBoard:addSubview(nextButton)

pauseButton.onActivated = function()
    print("HEYOOO")
end

app:scheduleAction(1.0, true, function()
    print("tick")
end)

app.mainView = jukebox
app:connect()
app:run()