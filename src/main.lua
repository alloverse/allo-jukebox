require("liballonet")
local Client = require("client")

local client = Client.connect("alloplace://nevyn.places.alloverse.com", "lua-sample")

client:run()