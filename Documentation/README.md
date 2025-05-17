# **Alvorecer Framework - Complete Function Guide**  
*(Objective and direct documentation for all 20+ functions)*  

---

## **Core Functions (`main.lua`)**  

### **1. `version()`**  
Prints framework version.  
```lua 
version() -- Output: "Alvorecer Framework - v0.60.generic"  
```

### **2. `console(value, level)`**  
Logs messages with severity levels:  
```lua 
console("Starting app", "info")  -- [INFO] Starting app  
console("Error!", "error")       -- [ERROR] Error!  
```

### **3. `echo(value)`**  
Simple print wrapper:  
```lua 
echo("Hello") -- Prints "Hello"  
```

### **4. `globalkey(table, key, value)`**  
Adds a key-value pair to a table:  
```lua 
globalkey(mytable, "name", "Alice")  
```

### **5. `globaltoken(name, value)`**  
Creates a **protected global variable**:  
```lua 
globaltoken("API_KEY", "123") -- Creates _G.API_KEY (immutable)  
```

### **6. `cmd(command)`**  
Executes system commands:  
```lua 
cmd("ls -la") -- Runs in shell  
```

### **7. `foreach(list, value, opts)`**  
Searches for a value in a list:  
```lua 
foreach({"a", "b", "c"}, "b") -- Returns "Value at found index 2"  
```

### **8. `voidfn(name, func)`**  
Registers a global function:  
```lua 
voidfn("greet")(function() print("Hi!") end)  
greet() -- Calls the function  
```

### **9. `data()`**  
Returns current date/time:  
```lua 
print(data()) -- "25/12/2023 14:30:00"  
```

### **10. `deletefile(name)`**  
Deletes a file (with safety checks):  
```lua 
deletefile("temp.txt") -- Returns success/error message  
```

### **11. `createfile(name)`**  
Creates an empty file:  
```lua 
createfile("log.txt")  
```

### **12. `writefile(name, content)`**  
Writes to a file:  
```lua 
writefile("log.txt", "Data")  
```

### **13. `renamefile(old, new)`**  
Renames a file:  
```lua 
renamefile("old.txt", "new.txt")  
```

### **14. `listfiles(dir)`**  
Lists directory contents:  
```lua 
listfiles("/home") -- Returns files as string  
```

### **15. `checkpermissions(file)`**  
Checks file permissions:  
```lua 
checkpermissions("script.sh")  
```

### **16. `createfolder(dir)`**  
Creates a directory:  
```lua 
createfolder("docs")  
```

### **17. `splitlist(list, index)`**  
Splits a table at `index`:  
```lua 
splitlist({1, 2, 3}, 2) -- Returns {1, 2}, {3}  
```

### **18. `grant_max_permission(path)`**  
Gives full file permissions:  
```lua 
grant_max_permission("script.sh") -- chmod 777  
```

### **19. `installpkg(pkg)`**  
Installs packages via apt:  
```lua 
installpkg("nginx")  
```

### **20. `manageProcesses(name, action)`**  
Manages system processes:  
```lua 
manageProcesses("nginx", "terminate") -- Kills nginx  
```

### **21. `stop_process(name)`**  
Stops a process by name:  
```lua 
stop_process("node")  
```

### **22. `giveChmod()`**  
Grants 777 to all files in CWD:  
```lua 
giveChmod()  
```

### **23. `execute(func, times)`**  
Runs a function repeatedly:  
```lua 
execute(function() print("Loop") end, 3)  
```

### **24. `WindowsManager(amount, command, debug)`**  
Executes Windows commands:  
```lua 
WindowsManager(2, "echo Hello", true)  
```

### **25. `let(cmd)`**  
Declares variables with scope control:  
```lua 
let("let x number = 10 public") -- Creates _G.x  
```

### **26. `gttoken(length)`**  
Generates secure tokens:  
```lua 
gttoken(32) -- Random 32-char string  
```

### **27. `dataget(table)`**  
Analyzes table structure:  
```lua 
dataget({x=1, y=2}) -- Returns metadata  
```

### **28. `returnbug()`**  
Standard error template:  
```lua 
returnbug() -- Returns predefined error structure  
```

---

## **Memory Management (`config.lua`)**  

### **29. `GC:new(mode, threshold, callback)`**  
Configures garbage collection:  
```lua 
local gc = GC:new("aggressive", 200, function(msg) print(msg) end)  
```

### **30. `gc:forceCollect(level)`**  
Triggers memory cleanup:  
```lua 
gc:forceCollect(3) -- Level 3 (extreme)  
```

### **31. `gc:apply()`**  
Executes GC with current settings:  
```lua 
gc:apply()  
```

---

## **Data Tools (`breaks.lua`)**  

### **32. `breaktable(table, max_depth)`**  
Inspects table structure:  
```lua 
breaktable({x={y=1}}, 2) -- Returns nested analysis  
```

### **33. `deepscan(target)`**  
Advanced data validation:  
```lua 
deepscan({x=1}) -- Checks for anomalies  
```

---

## **C++ Module (`mais.cpp`)**  
- **`SecureAllocator`**: Safe memory allocation (auto-used by framework).  
- **`MemoryManager`**: Interface for Lua memory operations.  

---

## **Usage Rules**  
1. **Always check return values** (most functions return success/error messages).  
2. **Use `globaltoken()`** for critical globals to prevent overwrites.  
3. **Wrap risky ops in `pcall()`**:  
   ```lua 
   pcall(function() manageProcesses("nginx", "kill") end)  
   ```  

**Repo**: [github.com/v0ic32/Alvorecer](https://github.com/v0ic32/Alvorecer/tree/main)
