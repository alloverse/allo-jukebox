local json = require("json")

local Client = {}
local Client_mt = {__index = Client}
function Client.connect(url, name)
    local self = {}
    setmetatable(self, Client_mt)
    self.client = allonet.create()

    self.client:set_disconnected_callback(function()
        print("Lost connection :(")
        exit()
    end)
    self.client:set_interaction_callback(function(inter)
        local body = json.decode(inter.body)
        if body[1] == "announce" then
            self.avatar_id = body[2]
            print("Determined avatar ID: " .. self.avatar_id)
        end
    end)
    self.client:set_state_callback(function(state)
    
    end)
    self.avatar_id = ""

    self.client:connect(
        url,
        json.encode({display_name = name}),
        json.encode({
            geometry = {
                type = "hardcoded-model"
            }
        })
    )
    return self
end


function Client:run()
    while true do
        self.client:poll()
    end
end

return Client
