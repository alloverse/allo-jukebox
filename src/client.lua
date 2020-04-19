local json = require("json")
local tablex = require("pl.tablex")
local Entity, componentClasses = unpack(require("entity"))
local class = require("pl.class")
local ui = require("ui")

class.Client()

function Client:_init(url, name)
    self.client = allonet.create()
    self.url = url
    self.name = name
    self.mainView = ui.View()

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
        self:updateState(state)
    end)
    self.avatar_id = ""

    self.delegates = {
        onEntityAdded = function(e) end,
        onEntityRemoved = function(e) end,
        onComponentAdded = function(k, v) end,
        onComponentChanged = function(k, v) end,
        onComponentChanged = function(k, v) end,
    }

    return self
end

function Client:connect()
    self.client:connect(
        self.url,
        json.encode({display_name = self.name}),
        json.encode(self.mainView:specification())
    )
end

function Client:updateState(newState)
    local oldEntities = tablex.copy(self.state.entities)

    -- Compare existing state to the new incoming state, and apply appropriate functions when we're done.
    local newEntities = {}
    local deletedEntities = {}
    local newComponents = {}
    local updatedComponents = {}
    local deletedComponents = {}
  
    -- While at it, also make Entities and their Components classes so they get convenience methods from entity.lua
  
    -- Entity:getSibling(eid) to get any entity from an entity.
    local getSibling = function(this, id) return self.state.entities[id] end
  
    for eid, newEntity in pairs(newState.entities) do
      local existingEntity = oldEntities[eid]
      local entity = existingEntity
      -- Check for new entity
      if entity == nil then
        entity = newEntity
        setmetatable(entity, Entity)
        entity.getSibling = getSibling
        table.insert(newEntities, entity)
        self.state.entities[eid] = newEntity
      end
      
      -- Component:getEntity()
      local getEntity = function() return entity end
  
      -- Check for new or updated components
      for cname, newComponent in pairs(newEntity.components) do
        local oldComponent = existingEntity and existingEntity.components[cname]
        if oldComponent == nil then
          -- it's a new component
          local klass = componentClasses[cname]
          setmetatable(newComponent, klass)
          newComponent.getEntity = getEntity
          newComponent.key = cname
          entity.components[cname] = newComponent
          table.insert(newComponents, newComponent)
        elseif tablex.deepcompare(oldComponent, newComponent, false) == false then
          -- it's a changed component
          table.insert(updatedComponents, oldComponent)
          tablex.update(oldComponent, newComponent)
        end
      end
      -- Check for deleted components
      if existingEntity ~= nil then
        for cname, oldComponent in pairs(existingEntity.components) do
          local newComponent = newEntity.components[cname]
          if newComponent == nil then
            table.insert(deletedComponents, oldComponent)
            entity.components[cname] = nil
          end
        end
      end
    end
  
    -- check for deleted entities
    for eid, oldEntity in pairs(oldEntities) do
      local newEntity = newState.entities[eid]
      if newEntity == nil then      
        table.insert(deletedEntities, oldEntity)
        tablex.insertvalues(deletedComponents, tablex.values(oldEntity.components))
        self.state.entities[eid] = nil
      end
    end
  
    -- Run callbacks
    tablex.map(function(x) self.delegates.onEntityAdded(x) end, newEntities)
    tablex.map(function(x) self.delegates.onEntityRemoved(x) end, deletedEntities)
    tablex.map(function(x) self.delegates.onComponentAdded(x.key, x) end, newComponents)
    tablex.map(function(x) self.delegates.onComponentChanged(x.key, x) end, updatedComponents)
    tablex.map(function(x) self.delegates.onComponentRemoved(x.key, x) end, deletedComponents)
end


function Client:run()
    while true do
        self.client:poll()
    end
end

return Client
