local class = require('pl.class')
local tablex = require('pl.tablex')
local pretty = require('pl.pretty')
local vec3 = require("cpml.vec3")
local mat4 = require("cpml.mat4")
require "random_string"

class.View()
function View:_init(bounds)
    self.viewId = string.random(16)
    self.bounds = bounds
    self.subviews = {}
end

function View:specification()
    local t = mat4.clone(self.bounds.pose.transform)
    t._m = nil

    local mySpec = {
        ui = {
            view_id = self.viewId
        },
        transform = {
            matrix = t
        },
        children = tablex.map(function(v) return v:specification() end, self.subviews)
    }
    return mySpec
end

function View:addSubview(subview)
    table.insert(self.subviews, subview)
end

class.Surface(View)
function Surface:specification()
    local s = self.bounds.size
    local w2 = s.width / 2.0
    local h2 = s.depth / 2.0
    local mySpec = tablex.union(View.specification(self), {
        geometry = {
            type = "inline",
                  --   #bl                   #br                  #tl                    #tr
            vertices= {{w2, 0.0, -h2},       {w2, 0.0, h2},       {-w2, 0.0, -h2},       {-w2, 0.0, h2}},
            uvs=      {{0.0, 0.0},           {1.0, 0.0},          {0.0, 1.0},            {1.0, 1.0}},
            triangles= {{0, 3, 1}, {0, 2, 3}},
            texture= "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAM6SURBVHhe7Zq9b9NAGIdfJ2lSqlYCNtQVhGBkKOIPQOJjQEgMTBUDYkDqVDb+BqZuwFKpCxJiQRVCZWBKF9S1c4QQXfgKH21omuD3cm+4nBz7fL472z0/Uvq6kXr277n37MZxsLuzOQSPqfHqLZUAXr2lEsCrtxgVcOHSTfayhY3xjVwG6aCuPhkNtbUasBqOzWpWcPxGOFX9AX8jxNTYmQTIwUVIAqJ7sDj+qdkafDsYwOeV6/xdgI/dfVhaf8+2s4rQEiC2YVR4Ed1uoH2IwWXOrL3hW/oiUgm4dvshdDodtp0UXEZVhEpwmSwilAXEtbsqccsCx5+fCeDX4TBVeBESkUZCooA07a6KLEJn1uNII2KqABvBZUQRpsITqssiUoCJdo+Dgj9YvgWt5gysPX/JfjctAUkSMSEAg9Nlx0Z4DE7X85X7d/i7/3EhQpYwFuBq1qOCi6CEqGu/CaK6AY9qeLJVg+89e7OOJAWXcdUNTIDN4Avzc3Dv7g22nZbNrTZ82duDH+Hk2OoG4wIoOJJ21qdhoxusCNBtd1VMijAqwHZwEZTQrAfw90j/P0bEiAAb7a5K1m7ILMDlrMehK0JbQFGCi5AERFUECdC6JVak8EiW46luivJaenS7oOoAXr2lEsCrd1xZPM2qtwK2P31l1VsBq0tnWfVWwKPL51itToL4Q/xU5xtVB/DqLZUAXo8FC031c9n4fgB9QYAnwrKfDBu15OPH4BefvWXbmJ11AG6IIspKfzD9zla3dzie9Xb79TjvxBIgEWXthmkdgMHPP303MdFE5DmgrCL2+5MdgMHxFRWciD0J0h99eFwvhYgTjdExyus8jsQnRAjxgYmi3RQlNjZesW+VkaTghLIAoqgi6Na4anAitQARkpGnCPE7gbThkUwCEJQwG669g/AE5FIEBp8L9/sn3K9OcCKzAMJlN+i2exTGBBA2RZgMThgXgKCEVj2A3pGZZYHB6bkhk+ERKwII6gZEV4SNWRexKoDQWRa2gxNOBBAqIro/f8P6i9GHFtvhEacCEJRAj7jIIlzNuohzAYTYDXkEJ3ITgJCEPIITuQooAsfqnqAOlQBevcVzAQD/ACwg7buhFwAGAAAAAElFTkSuQmCC"
        },
    })
    return mySpec
end

class.Button(View)
function Button:specification()
    local s = self.bounds.size
    local w2 = s.width / 2.0
    local h2 = s.depth / 2.0
    local mySpec = tablex.union(View.specification(self), {
        geometry = {
            type = "inline",
                  --   #bl                   #br                  #tl                    #tr
            vertices= {{w2, 0.0, -h2},       {w2, 0.0, h2},       {-w2, 0.0, -h2},       {-w2, 0.0, h2}},
            uvs=      {{0.0, 0.0},           {1.0, 0.0},          {0.0, 1.0},            {1.0, 1.0}},
            triangles= {{0, 3, 1}, {0, 2, 3}},
            texture= "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAIAAAAlC+aJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAD8SURBVGhD7c/LCcJgFERhq7Qgy3CfRXoQXItNGYmEeMyQbEbuhYFv9T9gzun6fPR1HofGAdP6xgHz+q4By/qWAev1/QKwftIpANNnbQKwe9EjAKPXGgRgMVQPwNxfpQOwddPRgMv99mcYqiTABkOVBNhgqJIAGwxVEmCDoUoCbDBUSYANhioJsMFQJQE2GKokwAZDlQTYYKiSABsMVRJgg6FKAmwwVEmADYYqCbDBUCUBNhiqJMAGQ5UE2GCokgAbDFUSYIOhytEAfKvjUAD+lLIfgA/V7ATgdUEyAO/K2g7Ao8o2AvCiOAbgur6vANy18AnAaSPvABx1Mg4vbr0dVP2tGoQAAAAASUVORK5CYII="
        },
        collider= {
            type= "box",
            width= s.width, height= s.height, depth= s.depth
        }
    })
    return mySpec
end

class.Pose()
-- Pose(): create zero pose
-- Pose(transform): create pose from transform
-- Pose(x, y, z): create positioned pose
-- Pose(a, x, y, z): create rotated pose
function Pose:_init(a, b, c, d)
    if b == nil then
        self.transform = a or mat4.identity()
    elseif d == nil then
        self.transform = mat4.translate(mat4.identity(), mat4.identity(), vec3.new(a, b, c))
    else
        self.transform = mat4.rotate(mat4.identity(), mat4.identity(), a, vec3.new(b, c, d))
    end
end

function Pose:rotate(angle, x, y, z)
    self.transform = mat4.rotate(self.transform, self.transform, angle, vec3(x, y, z))
end

class.Size()
function Size:_init(width, height, depth)
    self.width = width
    self.height = height
    self.depth = depth
end

class.Bounds()
-- Bounds(pose, size)
-- Bounds(x, y, z, w, h)
function Bounds:_init(a, b, z, w, h, d)
    if type(a) == "table" then
        self.pose = a
        self.size = b
    else
        self.pose = Pose(a, b, z)
        self.size = Size(w, h, d)
    end
end

class.App()
function App:_init(client)
    self.client = client
    self.mainView = View()
    client.delegates.onInteraction = function(inter, body, receiver, sender) 
        self:onInteraction(inter, body, receiver, sender) 
    end
end

function App:connect()
    local mainSpec = self.mainView:specification()
    self.client:connect(mainSpec)
end

function App:onInteraction(inter, body, receiver, sender) 

end

return {
    View = View,
    Surface = Surface,
    Button = Button,
    Bounds = Bounds,
    Pose = Pose,
    App = App,
    Size = Size
}