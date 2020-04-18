require("liballonet")
package.path = package.path ..';../lib/?/init.lua;../lib/?.lua'
local class = require('pl.class')
local Client = require("client")
local ui = require("ui")
local mat4 = require("cpml.mat4")

local client = Client.connect("alloplace://nevyn.places.alloverse.com", "lua-sample")

local controlPad = ui.View(ui.Frame(ui.position(2, 1.3, 0), ui.Size(1, 0.5)))
local prevButton = ui.Button(ui.Frame(ui.position(0.1, 0.1, 0.15), ui.Size(0.2, 0.2)))
local pauseButton = ui.Button(ui.Frame(ui.position(0.4, 0.1, 0.15), ui.Size(0.2, 0.2)))
local nextButton = ui.Button(ui.Frame(ui.position(0.7, 0.1, 0.15), ui.Size(0.2, 0.2)))
controlPad:addSubview(prevButton)
controlPad:addSubview(pauseButton)
controlPad:addSubview(nextButton)


client:run()