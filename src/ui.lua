local class = require('pl.class')
local vec3 = require("cpml.vec3")
local mat4 = require("cpml.mat4")

class.View()
function View:_init(frame)
    self.frame = frame
    self.subviews = {}
end

function View:addSubview(subview)
    table.insert(self.subviews, subview)
end

class.Button(View)

class.Size()
function Size:_init(width, height)
    self.width = width
    self.height = height
end

class.Frame()
function Frame:_init(pose, size)
    self.pose = pose
    self.size = size
end

return {
    View = View,
    Button = Button,
    Frame = Frame,
    Size = Size,
    position = function(x, y, z)
        return mat4.translate(mat4.identity(), mat4.identity(), vec3.new(x, y, z))
    end
}