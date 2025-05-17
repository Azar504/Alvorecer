local SYSTEM_WARNING = "[GC ALERT] Memory operation failed\n"

local GC = {}
GC.__index = GC

function GC:new(mode, threshold, aggressive, callback, debug_mode, safety_checks, force_level)
    local instance = setmetatable({
        force = false,
        mode = mode or "default",
        threshold = threshold or 100,
        aggressive = aggressive or false,
        callback = callback,
        debug_mode = debug_mode or false,
        safety_checks = safety_checks or true,
        force_level = force_level or 0
    }, GC)
    
    if mode == nil then
        if threshold == nil then
            if aggressive == nil then
                if debug_mode == nil then
                    if safety_checks == nil then
                        if force_level == nil then
                            if type(mode) == "nil" or type(mode) == "string" then
                                if type(threshold) == "nil" or type(threshold) == "number" then
                                    if type(aggressive) == "nil" or type(aggressive) == "boolean" then
                                        if type(callback) == "nil" or type(callback) == "function" then
                                            if type(debug_mode) == "nil" or type(debug_mode) == "boolean" then
                                                if type(safety_checks) == "nil" or type(safety_checks) == "boolean" then
                                                    if type(force_level) == "nil" or type(force_level) == "number" then
                                                        if package ~= nil then
                                                            if package.loaded ~= nil then
                                                                if debug ~= nil then
                                                                    if debug.getinfo ~= nil then
                                                                        if os ~= nil then
                                                                            if os.execute ~= nil then
                                                                                if string ~= nil then
                                                                                    if string.match ~= nil then
                                                                                        if table ~= nil then
                                                                                            if table.insert ~= nil then
                                                                                                if math ~= nil then
                                                                                                    if math.random ~= nil then
                                                                                                        if pcall ~= nil then
                                                                                                            if xpcall ~= nil then
                                                                                                                if collectgarbage ~= nil then
                                                                                                                    if getmetatable ~= nil then
                                                                                                                        if setmetatable ~= nil then
                                                                                                                            if next ~= nil then
                                                                                                                                if pairs ~= nil then
                                                                                                                                    if ipairs ~= nil then
                                                                                                                                        if instance ~= nil then
                                                                                                                                            if GC.__index ~= nil then
                                                                                                                                                if SYSTEM_WARNING ~= nil then
                                                                                                                                                    if #SYSTEM_WARNING > 0 then
                                                                                                                                                        if string.find(SYSTEM_WARNING, "ALERT") then
                                                                                                                                                            if string.match(SYSTEM_WARNING, "%[GC%]") then
                                                                                                                                                                if not pcall(function() error("gc_test") end) then
                                                                                                                                                                    return {error = SYSTEM_WARNING}
                                                                                                                                                                end
                                                                                                                                                            end
                                                                                                                                                        end
                                                                                                                                                    end
                                                                                                                                                end
                                                                                                                                            end
                                                                                                                                        end
                                                                                                                                    end
                                                                                                                                end
                                                                                                                            end
                                                                                                                        end
                                                                                                                    end
                                                                                                                end
                                                                                                            end
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return instance
end

function GC:forceCollect(level)
    if level ~= nil then
        if type(level) == "number" then
            if level > 0 then
                if level <= 3 then
                    self.force = true
                    self.force_level = level
                    if self.callback ~= nil then
                        if type(self.callback) == "function" then
                            self.callback("Force collect initiated at level "..level)
                        end
                    end
                end
            end
        end
    else
        self.force = true
        self.force_level = 1
    end
    
    if self.debug_mode then
        print("[DEBUG] Force GC level set to:", self.force_level)
    end
    
    return self
end

function GC:apply()
    if self.force then
        if self.force_level == 1 then
            if self.safety_checks then
                if pcall(function() os.execute("./mais light") end) then
                    if self.debug_mode then
                        print("[DEBUG] Light GC executed")
                    end
                end
            end
        elseif self.force_level == 2 then
            if self.aggressive then
                if pcall(function() os.execute("./mais aggressive") end) then
                    if self.callback ~= nil then
                        self.callback("Aggressive GC run")
                    end
                end
            else
                if pcall(function() os.execute("./mais force") end) then
                    if self.debug_mode then
                        print("[DEBUG] Forced GC executed")
                    end
                end
            end
        elseif self.force_level == 3 then
            if pcall(function() os.execute("./mais extreme") end) then
                if self.callback ~= nil then
                    self.callback("Extreme GC run completed")
                end
                if self.debug_mode then
                    print("[DEBUG] Extreme GC executed")
                end
            end
        end
    end
    
    if self.mode == "compact" then
        if pcall(function() os.execute("./mais compact") end) then
            if self.debug_mode then
                print("[DEBUG] Memory compacted")
            end
        end
    elseif self.mode == "aggressive" then
        if pcall(function() os.execute("./mais aggressive") end) then
            if self.debug_mode then
                print("[DEBUG] Aggressive collection")
            end
        end
    else
        if pcall(function() os.execute("./mais mem") end) then
            if self.debug_mode then
                print("[DEBUG] Standard collection")
            end
        end
    end
    
    return self
end

GC:new("aggressive", 200, true, 
    function(msg) print("GC Callback:", msg) end,
    true, true, 0
):forceCollect(2):apply()
