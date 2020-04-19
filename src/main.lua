require("liballonet")
package.path = package.path ..';../lib/?/init.lua;../lib/?.lua'
local class = require('pl.class')
local Client = require("client")
local ui = require("ui")
local mat4 = require("cpml.mat4")

local client = Client(
    "alloplace://nevyn.places.alloverse.com", 
    "lua-sample"
)

local controlPad = ui.View(ui.Bounds(2, 1.3, 0,   1, 0.5, 0.1))
controlPad.bounds.pose:rotate(3.14159/4, 1, 0, 0)
local prevButton = ui.Button(ui.Bounds( 0.1, 0.1, 0.15,   0.2, 0.2, 0.1))
local pauseButton = ui.Button(ui.Bounds(0.4, 0.1, 0.15,   0.2, 0.2, 0.1))
local nextButton = ui.Button(ui.Bounds( 0.7, 0.1, 0.15,   0.2, 0.2, 0.1))
controlPad:addSubview(prevButton)
controlPad:addSubview(pauseButton)
controlPad:addSubview(nextButton)

local app = App(client)
app.mainView = controlPad

client:connect()

client:run()