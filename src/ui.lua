local class = require('pl.class')
local vec3 = require("cpml.vec3")
local mat4 = require("cpml.mat4")

class.View()
function View:_init(bounds)
    self.bounds = bounds
    self.subviews = {}
end

function View:addSubview(subview)
    table.insert(self.subviews, subview)
end

class.Button(View)

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
    mat4.rotate(self.transform, self.transform, angle, vec3(x, y, z))
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
end

return {
    View = View,
    Button = Button,
    Bounds = Bounds,
    Pose = Pose,
    App = App,
    Size = Size
}