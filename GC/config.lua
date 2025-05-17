local GC = {}
GC.__index = GC

function GC:new()
    return setmetatable({force = false}, GC)
end

function GC:forceCollect()
    self.force = true
    return self
end

function GC:apply()
    if self.force then
        os.execute("./mais force")
    end
    os.execute("./mais mem")
    return self
end

GC:new():forceCollect():apply()