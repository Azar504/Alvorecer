function version()
    local version = "0.53.purpleS"
    print("Alvorecer Framework - v" .. version)
end

version()

local GENERIC_ERROR = "[ALVORECER:GENERIC_ERROR] :: A general execution failure was detected during the runtime of a Lua-wrapped function. Possible causes: invalid input, internal check failure, or unsafe context. Interpreter halted the process to preserve integrity."

function console(valuept, level)

	if valuept then
		if type(valuept) == "table" then
			if level then
				if type(level) == "string" then
					if level == "info" then
						level = "[INFO]"
					else
						if level == "warn" then
							level = "[WARN]"
						else
							if level == "error" then
								level = "[ERROR]"
							else
								if level == "debug" then
									level = "[DEBUG]"
								else
									level = ""
								end
							end
						end
					end
				end
			else
				level = ""
			end
			local out = ""
			if out == "" then
				if type(valuept) == "table" then
					if level then
						if type(valuept) == "table" then
							for k, v in pairs(valuept) do
								if k then
									if v then
										out = out .. k .. ": " .. tostring(v) .. ", "
									end
								end
							end
							out = out:sub(1, -3)
						end
					end
				end
			end
			print(level .. " " .. out)
		else
			if level then
				if level == "info" then
					level = "[INFO]"
				elseif level == "warn" then
					level = "[WARN]"
				elseif level == "error" then
					level = "[ERROR]"
				elseif level == "debug" then
					level = "[DEBUG]"
				else
					level = ""
				end
			else
				level = ""
			end
			print(level .. " " .. tostring(valuept))
		end
	end

end

function echo(printvalue)
    print(printvalue)
end

function globalkey(table, name, value)
    table[name] = value
end

local tokenglobal = {}

function globaltoken(name, value)
    local CriticalErrorCoppy = "Attempt to overwrite variable detected // critical error //"

    if type(name) == "string" then
        if name:match("^[%a_][%w_]*$") then
            if _G[name] == nil then
                rawset(_G, name, value)
                if type(name) == "string" then
                    if not tokenglobal then
                        tokenglobal = {}
                        if tokenglobal then
                            tokenglobal[name] = true
                            if tokenglobal[name] == true then
                                if _G then
                                    setmetatable(_G, {
                                        __newindex = function(_, key, value)
                                            if tokenglobal then
                                                if tokenglobal[key] then
                                                    error(CriticalErrorCoppy)
                                                else
                                                    if _G then
                                                        rawset(_G, key, value)
                                                    end
                                                end
                                            end
                                        end
                                    })
                                end
                            end
                        end
                    end
                end
            else
                return "Critical error: global token already exists"
            end
        else
            return GENERIC_ERROR
        end
    else
        return "token name must be of type == string"
    end
end

function cmd(cmd_exect)
    os.execute(cmd_exect)
end

function foreach(list, value, opts)
    if list then 
        if type(list) == "table" then
            if value ~= nil then
                if opts == nil or type(opts) == "table" then
                    local return_error = false
                    if opts then
                         if opts.return_error ~= nil then
                             if type(opts.return_error) == "boolean" then
                                 return_error = opts.return_error
                                 else
                                     return "ERROR: 'return_error', must be boolean"
                             end
                         end
                    end
                         if #list > 0 then
                             for i,v in ipairs(list) do
                                 if v == value then
                                     return "Value at found index ".. i
                                 end
                             end
                             if return_error then
                                 return "ERROR; Value not found in the list."
                                 
                                 else
                                     return ""
                             end
                             else
                                 return "ERROR; the list is empty"
                         end
                             else
                                 return "ERROR; options must be a table nil"
                end
                             else
                                 return "ERROR; A Value to search must be proviend"
            end
                             else
                                 return "ERROR; first argument must be a table"
        end
                             else
                                 return "ERROR; no list proviend"
    end
end
 
function voidfn(name)
  if name then
      if type(name) == "string" then
          if #name > 0 then
              return function(fn)
                  if fn then
                      if type(fn) == "function" then
                          if _G then
                              if type(_G) == "table" then
                                  _G[name] = fn
                                  return true
                              end
                          end
                          else
                              return "ERROR; second param is not a function"
                      end
                          else
                              return "ERROR; not function proviend"
                  end
              end
              else
                  return "ERROR; name must not be empty"
          end
                          else
                              return "ERROR; name must be string"
      end
                          else
                              return "ERROR; no name proviend"
  end
end

function data()
    local datetime = os.date("%d/%m/%Y %H:%M:%S")
    print(datetime)
    return datetime
end 
function deletefile(name)
    if name then
        if name ~= nil then
            if type(name) then
                if type(name) == "string" then
                    if #name > 0 then
                        if name ~= " " then
                            if name ~= "do_not_delete.txt" then
                                if string.sub(name, 1, 1) ~= "#" then
                                    if not name:find("[^%w%._%-]") then
                                        if io.open(name, "r") then
                                            local command = "rm -f " .. name
                                            local result = os.execute(command)
                                            if result then
                                                return "SUCCESS: File '" .. name .. "' deleted."
                                            else
                                                return "ERROR: System command failed to execute."
                                            end
                                        else
                                            return "ERROR: File does not exist."
                                        end
                                    else
                                        return "ERROR: Filename contains invalid characters."
                                    end
                                else
                                    return "ERROR: Cannot delete files starting with '#'."
                                end
                            else
                                return "ERROR: Reserved file cannot be deleted."
                            end
                        else
                            return "ERROR: Filename cannot be a blank space."
                        end
                    else
                        return "ERROR: Filename too short."
                    end
                else
                    return "ERROR: Expected string, got " .. type(name)
                end
            else
                return "ERROR: Could not determine type."
            end
        else
            return "ERROR: Filename not provided."
        end
    else
        return "ERROR: Filename is nil."
    end
end

function createfile(name)
    if name then
        if name ~= nil then
            if type(name) then
                if type(name) == "string" then
                    if #name > 0 then
                        if not name:find("[^%w%._%-]") then
                            local file = io.open(name, "r")
                            if file then
                                file:close()
                                return "ERROR: File already exists."
                            else
                                local command = "touch " .. name
                                local result = os.execute(command)
                                if result then
                                    return "SUCCESS: File '" .. name .. "' created."
                                else
                                    return "ERROR: Failed to create file via system command."
                                end
                            end
                        else
                            return "ERROR: Invalid characters in filename."
                        end
                    else
                        return "ERROR: Filename is empty."
                    end
                else
                    return "ERROR: Filename must be string."
                end
            else
                return "ERROR: Could not determine type."
            end
        else
            return "ERROR: Filename is nil."
        end
    else
        return "ERROR: Filename not provided."
    end
end


function writefile(name, content)
    if name then
        if content then
            if type(name) == "string" then
                if type(content) == "string" then
                    if #name > 0 and #content > 0 then
                        if not name:find("[^%w%._%-]") then
                            local file = io.open(name, "r")
                            if file then
                                file:close()
                                local command = "echo \"" .. content:gsub('"', '\\"') .. "\" > " .. name
                                local result = os.execute(command)
                                if result then
                                    return "SUCCESS: Content written to '" .. name .. "'."
                                else
                                    return "ERROR: Write failed via system command."
                                end
                            else
                                return "ERROR: File does not exist to write."
                            end
                        else
                            return "ERROR: Invalid characters in filename."
                        end
                    else
                        return "ERROR: Filename or content is empty."
                    end
                else
                    return "ERROR: Content must be string."
                end
            else
                return "ERROR: Filename must be string."
            end
        else
            return "ERROR: Missing content."
        end
    else
        return "ERROR: Missing filename."
    end
end

function renamefile(old, new)
    if old then
        if new then
            if type(old) == "string" and type(new) == "string" then
                if #old > 0 and #new > 0 then
                    if not old:find("[^%w%._%-]") and not new:find("[^%w%._%-]") then
                        local oldFile = io.open(old, "r")
                        local newFile = io.open(new, "r")
                        if oldFile then
                            oldFile:close()
                            if newFile then
                                return "ERROR: New file already exists."
                            else
                                local command = "mv " .. old .. " " .. new
                                local result = os.execute(command)
                                if result then
                                    return "SUCCESS: File renamed from '" .. old .. "' to '" .. new .. "'."
                                else
                                    return "ERROR: Rename failed via system."
                                end
                            end
                        else
                            return "ERROR: Old file does not exist."
                        end
                    else
                        return "ERROR: Invalid characters in filenames."
                    end
                else
                    return "ERROR: Empty filenames."
                end
            else
                return "ERROR: Both old and new names must be strings."
            end
        else
            return "ERROR: Missing new name."
        end
    else
        return "ERROR: Missing old name."
    end
end

function listfiles(dir)
    if dir then
        if type(dir) == "string" then
            if #dir > 0 then
                if not dir:find("[^%w%/%._%-]") then
                    local command = "ls " .. dir
                    local result = os.execute(command)
                    if result then
                        return "SUCCESS: Directory listed."
                    else
                        return "ERROR: Failed to list directory."
                    end
                else
                    return "ERROR: Directory contains invalid characters."
                end
            else
                return "ERROR: Directory is empty."
            end
        else
            return "ERROR: Directory must be string."
        end
    else
        return "ERROR: No directory provided."
    end
end

function checkpermissions(name)
    if name then
        if type(name) == "string" then
            if #name > 0 then
                if not name:find("[^%w%._%-]") then
                    local command = "ls -l " .. name
                    local result = os.execute(command)
                    if result then
                        return "SUCCESS: File permissions checked for '" .. name .. "'."
                    else
                        return "ERROR: Failed to check permissions."
                    end
                else
                    return "ERROR: Invalid characters in filename."
                end
            else
                return "ERROR: Filename is empty."
            end
        else
            return "ERROR: Filename must be string."
        end
    else
        return "ERROR: No filename provided."
    end
end

function createfolder(dir)
    if dir then
        if type(dir) == "string" then
            if #dir > 0 then
                if not dir:find("[^%w%/%._%-]") then
                    local command = "mkdir -p " .. dir
                    local result = os.execute(command)
                    if result then
                        return "SUCCESS: Folder '" .. dir .. "' created."
                    else
                        return "ERROR: Failed to create folder."
                    end
                else
                    return "ERROR: Invalid characters in directory name."
                end
            else
                return "ERROR: Directory name is empty."
            end
        else
            return "ERROR: Directory name must be string."
        end
    else
        return "ERROR: Directory name missing."
    end
end

function splitlist(inputlist, splitindex)
    if inputlist == nil then
        print("ERROR; list null")
        return nil
    elseif #inputlist == 0 then
        print("ERROR; list is empty")
        return nil
        else
            if splitindex == nil then
                print("ERROR; splitindex not provided")
                return nil
            elseif type(splitindex) ~= "number" then
                print("ERROR; splitindex must be number")
                return nil
                else
                    if splitindex < 1 then
                        print("ERROR; splitindex less than 0")
                        return nil
                    elseif splitindex > #inputlist then 
                        print("ERROR; splitindex > inputlist")
                        return nil
                        else
                            
                        local firspart = {}
                        local secondpart = {}
                        
                        if splitindex == 1 then
                            firspart = {inputlist[1]}
                            secondpart = {unpack(inputlist[2])}
                            else
                                for i = 1, splitindex do
                                    table.insert(firspart, inputlist[1])
                                end
                                for i = splitindex + 1, #inputlist do
                                    table.insert(secondpart, inputlist[i])
                                end
                        end
                            if #firspart == 0 then
                                print("ERROR; firspart = 0")
                                return nil
                            elseif #secondpart == 0 then
                                print("ERROR; secondpart = 0")
                                return nil
                                else
                                    return firspart, secondpart
                            end
                    end
            end
    end
end

function grant_max_permission(path)
    if path then
        if type(path) == "string" then
            if #path > 0 then
                local os_type = package.config:sub(1,1) == "/" and "linux" or "windows"
                if os_type then
                    if os_type == "linux" then
                        if os.execute("[ -e '" .. path .. "' ]") == 0 then
                            if os.execute("[ -f '" .. path .. "' ]") == 0 then
                                if os.execute("file '" .. path .. "' | grep -q script") == 0 then
                                    if os.execute("chmod +x '" .. path .. "'") == 0 then
                                        if os.execute("ls -l '" .. path .. "' | grep -q 'x'") == 0 then
                                            print("Execution permission successfully granted on Linux!")
                                        else
                                            print("Execute flag seems missing after chmod.")
                                        end
                                    else
                                        print("Failed to apply chmod.")
                                    end
                                else
                                    print("The file does not appear to be a script.")
                                end
                            else
                                print("Target is not a regular file.")
                            end
                        else
                            print("File does not exist.")
                        end
                    end
                    if os_type == "windows" then
                        if os.execute("if exist \"" .. path .. "\" (echo OK)") == 0 then
                            if path:match("%.bat$") or path:match("%.cmd$") or path:match("%.ps1$") then
                                if os.execute("attrib -r -h -s \"" .. path .. "\"") == 0 then
                                    if os.execute("icacls \"" .. path .. "\" /grant Everyone:F") == 0 then
                                        if os.execute("icacls \"" .. path .. "\" | findstr /C:\"Everyone.*F\"") == 0 then
                                            print("Full permissions successfully granted on Windows!")
                                        else
                                            print("Failed to confirm full permission.")
                                        end
                                    else
                                        print("Failed to set permissions with icacls.")
                                    end
                                else
                                    print("Failed to remove restrictive attributes.")
                                end
                            else
                                print("File extension not recognized as script.")
                            end
                        else
                            print("File does not exist.")
                        end
                    end
                else
                    print("Unable to detect OS type.")
                end
            else
                print("Path is empty.")
            end
        else
            print("Path is not a string.")
        end
    else
        print("No path provided.")
    end
end

function installpkg(pkg)
    local t = type(pkg)
    if t ~= "string" and t ~= "number" then
        return GENERIC_ERROR
    end

    cmd("apt install " .. tostring(pkg))
end

function manageProcesses(processPattern, action)
    local GLOBAL_PROCESS_DATA = {}
    local GLOBAL_PROCESS_FILTERED = {}
    local GLOBAL_EXECUTION_STATUS = false
    local GLOBAL_SYSTEM_TYPE = ""
    local GLOBAL_PERMISSIONS_LEVEL = "none"
    local GLOBAL_OUTPUT_BUFFER = {}
    local GLOBAL_ERROR_STATE = false
    local GLOBAL_SIGNAL_MAP = {TERM = 15, KILL = 9, HUP = 1, INT = 2, QUIT = 3}
    local GLOBAL_ALLOWED_ACTIONS = {display = true, filter = true, save = true, terminate = true, prioritize = true, pause = true, resume = true}
    local GLOBAL_SUPPORTED_DISTROS = {ubuntu = true, debian = true, arch = true, fedora = true, centos = true, redhat = true, opensuse = true, gentoo = true}
    local GLOBAL_COMMAND_EXISTS = {ps = false, grep = false, awk = false, kill = false, nice = false, renice = false}
    local GLOBAL_FILE_HANDLE = nil
    local GLOBAL_TIMESTAMP = os.time()
    local GLOBAL_OPERATION_RESULT = {}
    
    if type(processPattern) ~= "string" then
        GLOBAL_ERROR_STATE = true
        return "Error: Process pattern must be a string"
    else
        if #processPattern < 1 then
            GLOBAL_ERROR_STATE = true
            return "Error: Process pattern cannot be empty"
        else
            if processPattern:match("[;`\\|]") then
                GLOBAL_ERROR_STATE = true
                return "Error: Process pattern contains unsafe characters"
            else
                processPattern = processPattern:gsub("'", "\\'")
            end
        end
    end
    
    if type(action) ~= "string" then
        GLOBAL_ERROR_STATE = true
        return "Error: Action must be a string"
    else
        if not GLOBAL_ALLOWED_ACTIONS[action:lower()] then
            GLOBAL_ERROR_STATE = true
            return "Error: Invalid action. Allowed actions are: display, filter, save, terminate, prioritize, pause, resume"
        else
            action = action:lower()
        end
    end
    
    local checkHandle = io.popen("uname -a")
    if not checkHandle then
        GLOBAL_ERROR_STATE = true
        return "Error: Unable to execute system commands"
    else
        local systemInfo = checkHandle:read("*a")
        checkHandle:close()
        
        if not systemInfo:lower():match("linux") then
            GLOBAL_ERROR_STATE = true
            return "Error: This function only works on Linux systems"
        else
            GLOBAL_SYSTEM_TYPE = "linux"
            
            local distroCheckHandle = io.popen("cat /etc/*-release 2>/dev/null || cat /etc/issue 2>/dev/null")
            if distroCheckHandle then
                local distroInfo = distroCheckHandle:read("*a"):lower()
                distroCheckHandle:close()
                
                local distroFound = false
                for distro in pairs(GLOBAL_SUPPORTED_DISTROS) do
                    if distroInfo:match(distro) then
                        GLOBAL_SYSTEM_TYPE = distro
                        distroFound = true
                        break
                    end
                end
                
                if not distroFound then
                    GLOBAL_SYSTEM_TYPE = "unknown_linux"
                end
            end
        end
    end
    
    local permissionCheckHandle = io.popen("id -u")
    if permissionCheckHandle then
        local userId = permissionCheckHandle:read("*a")
        permissionCheckHandle:close()
        
        if tonumber(userId) == 0 then
            GLOBAL_PERMISSIONS_LEVEL = "root"
        else
            GLOBAL_PERMISSIONS_LEVEL = "user"
            
            if action == "terminate" or action == "prioritize" or action == "pause" or action == "resume" then
                local sudoCheckHandle = io.popen("sudo -n true 2>/dev/null && echo 'sudo' || echo 'nosudo'")
                if sudoCheckHandle then
                    local sudoCheck = sudoCheckHandle:read("*a"):gsub("%s+", "")
                    sudoCheckHandle:close()
                    
                    if sudoCheck == "sudo" then
                        GLOBAL_PERMISSIONS_LEVEL = "sudo"
                    else
                        if action == "terminate" or action == "prioritize" or action == "pause" or action == "resume" then
                            GLOBAL_ERROR_STATE = true
                            return "Error: Insufficient permissions for " .. action .. " action. Root privileges required."
                        end
                    end
                end
            end
        end
    end
    
    for cmd in pairs(GLOBAL_COMMAND_EXISTS) do
        local cmdCheckHandle = io.popen("command -v " .. cmd .. " 2>/dev/null")
        if cmdCheckHandle then
            local cmdPath = cmdCheckHandle:read("*a")
            cmdCheckHandle:close()
            
            if cmdPath and #cmdPath > 0 then
                GLOBAL_COMMAND_EXISTS[cmd] = true
            else
                if (cmd == "ps" or cmd == "grep") then
                    GLOBAL_ERROR_STATE = true
                    return "Error: Required command '" .. cmd .. "' not found on system"
                end
            end
        end
    end
    
    local psCommand = "ps aux"
    if GLOBAL_SYSTEM_TYPE == "arch" or GLOBAL_SYSTEM_TYPE == "gentoo" then
        psCommand = "ps -aux"
    end
    
    local grepCommand = "| grep -v grep | grep '" .. processPattern .. "'"
    
    local processHandle = io.popen(psCommand .. " " .. grepCommand)
    if not processHandle then
        GLOBAL_ERROR_STATE = true
        return "Error: Failed to execute process query"
    else
        local processOutput = processHandle:read("*a")
        processHandle:close()
        
        for line in processOutput:gmatch("[^\n]+") do
            local processInfo = {}
            local parts = {}
            
            for part in line:gmatch("%S+") do
                table.insert(parts, part)
            end
            
            if #parts >= 11 then
                processInfo.user = parts[1]
                processInfo.pid = tonumber(parts[2])
                processInfo.cpu = tonumber(parts[3]:gsub(",", "."))
                processInfo.mem = tonumber(parts[4]:gsub(",", "."))
                processInfo.vsz = tonumber(parts[5])
                processInfo.rss = tonumber(parts[6])
                processInfo.tty = parts[7]
                processInfo.stat = parts[8]
                processInfo.start = parts[9]
                processInfo.time = parts[10]
                
                processInfo.command = ""
                for i = 11, #parts do
                    processInfo.command = processInfo.command .. parts[i] .. " "
                end
                processInfo.command = processInfo.command:gsub("%s+$", "")
                
                if processInfo.pid then
                    table.insert(GLOBAL_PROCESS_DATA, processInfo)
                end
            end
        end
        
        if #GLOBAL_PROCESS_DATA == 0 then
            if action ~= "filter" then
                return "No processes matching '" .. processPattern .. "' found"
            else
                return {}
            end
        else
            GLOBAL_PROCESS_FILTERED = GLOBAL_PROCESS_DATA
            GLOBAL_EXECUTION_STATUS = true
            
            if action == "display" then
                local displayResult = "PID\tUSER\tCPU%\tMEM%\tCOMMAND\n"
                for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                    displayResult = displayResult .. process.pid .. "\t" .. process.user .. "\t" .. 
                                    process.cpu .. "\t" .. process.mem .. "\t" .. process.command .. "\n"
                    table.insert(GLOBAL_OUTPUT_BUFFER, {
                        pid = process.pid,
                        user = process.user,
                        cpu = process.cpu,
                        mem = process.mem,
                        command = process.command
                    })
                end
                return displayResult
            else
                if action == "filter" then
                    return GLOBAL_PROCESS_DATA
                else
                    if action == "save" then
                        local filename = "processes_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
                        GLOBAL_FILE_HANDLE = io.open(filename, "w")
                        
                        if not GLOBAL_FILE_HANDLE then
                            GLOBAL_ERROR_STATE = true
                            return "Error: Could not create output file"
                        else
                            GLOBAL_FILE_HANDLE:write("PID\tUSER\tCPU%\tMEM%\tCOMMAND\n")
                            
                            for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                GLOBAL_FILE_HANDLE:write(process.pid .. "\t" .. process.user .. "\t" .. 
                                                    process.cpu .. "\t" .. process.mem .. "\t" .. 
                                                    process.command .. "\n")
                            end
                            
                            GLOBAL_FILE_HANDLE:close()
                            return "Successfully saved process information to " .. filename
                        end
                    else
                        if action == "terminate" then
                            if GLOBAL_PERMISSIONS_LEVEL == "user" then
                                local userProcesses = {}
                                
                                for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                    local currentUser = ""
                                    local userCheckHandle = io.popen("whoami")
                                    
                                    if userCheckHandle then
                                        currentUser = userCheckHandle:read("*a"):gsub("%s+", "")
                                        userCheckHandle:close()
                                        
                                        if process.user == currentUser then
                                            table.insert(userProcesses, process)
                                        end
                                    end
                                end
                                
                                if #userProcesses == 0 then
                                    return "No matching processes owned by current user found"
                                else
                                    local killResults = {}
                                    
                                    for _, process in ipairs(userProcesses) do
                                        local killHandle = io.popen("kill -15 " .. process.pid .. " 2>&1")
                                        
                                        if killHandle then
                                            local killOutput = killHandle:read("*a")
                                            killHandle:close()
                                            
                                            if killOutput and #killOutput > 0 then
                                                table.insert(killResults, "Failed to terminate PID " .. process.pid .. ": " .. killOutput)
                                            else
                                                table.insert(killResults, "Successfully terminated PID " .. process.pid)
                                            end
                                        end
                                    end
                                    
                                    return table.concat(killResults, "\n")
                                end
                            else
                                if GLOBAL_PERMISSIONS_LEVEL == "root" or GLOBAL_PERMISSIONS_LEVEL == "sudo" then
                                    local prefix = ""
                                    
                                    if GLOBAL_PERMISSIONS_LEVEL == "sudo" then
                                        prefix = "sudo "
                                    end
                                    
                                    local killResults = {}
                                    
                                    for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                        local killHandle = io.popen(prefix .. "kill -15 " .. process.pid .. " 2>&1")
                                        
                                        if killHandle then
                                            local killOutput = killHandle:read("*a")
                                            killHandle:close()
                                            
                                            if killOutput and #killOutput > 0 then
                                                table.insert(killResults, "Failed to terminate PID " .. process.pid .. ": " .. killOutput)
                                            else
                                                table.insert(killResults, "Successfully terminated PID " .. process.pid)
                                            end
                                        end
                                    end
                                    
                                    return table.concat(killResults, "\n")
                                end
                            end
                        else
                            if action == "prioritize" then
                                if GLOBAL_PERMISSIONS_LEVEL == "user" then
                                    local userProcesses = {}
                                    local currentUser = ""
                                    local userCheckHandle = io.popen("whoami")
                                    
                                    if userCheckHandle then
                                        currentUser = userCheckHandle:read("*a"):gsub("%s+", "")
                                        userCheckHandle:close()
                                        
                                        for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                            if process.user == currentUser then
                                                table.insert(userProcesses, process)
                                            end
                                        end
                                    end
                                    
                                    if #userProcesses == 0 then
                                        return "No matching processes owned by current user found"
                                    else
                                        local reniceResults = {}
                                        
                                        for _, process in ipairs(userProcesses) do
                                            if GLOBAL_COMMAND_EXISTS["renice"] then
                                                local reniceHandle = io.popen("renice -n -5 -p " .. process.pid .. " 2>&1")
                                                
                                                if reniceHandle then
                                                    local reniceOutput = reniceHandle:read("*a")
                                                    reniceHandle:close()
                                                    
                                                    table.insert(reniceResults, "PID " .. process.pid .. ": " .. (reniceOutput or "Priority increased"))
                                                end
                                            end
                                        end
                                        
                                        return table.concat(reniceResults, "\n")
                                    end
                                else
                                    if GLOBAL_PERMISSIONS_LEVEL == "root" or GLOBAL_PERMISSIONS_LEVEL == "sudo" then
                                        local prefix = ""
                                        
                                        if GLOBAL_PERMISSIONS_LEVEL == "sudo" then
                                            prefix = "sudo "
                                        end
                                        
                                        local reniceResults = {}
                                        
                                        for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                            if GLOBAL_COMMAND_EXISTS["renice"] then
                                                local reniceHandle = io.popen(prefix .. "renice -n -10 -p " .. process.pid .. " 2>&1")
                                                
                                                if reniceHandle then
                                                    local reniceOutput = reniceHandle:read("*a")
                                                    reniceHandle:close()
                                                    
                                                    table.insert(reniceResults, "PID " .. process.pid .. ": " .. (reniceOutput or "Priority increased"))
                                                end
                                            end
                                        end
                                        
                                        return table.concat(reniceResults, "\n")
                                    end
                                end
                            else
                                if action == "pause" then
                                    if GLOBAL_PERMISSIONS_LEVEL == "user" then
                                        local userProcesses = {}
                                        local currentUser = ""
                                        local userCheckHandle = io.popen("whoami")
                                        
                                        if userCheckHandle then
                                            currentUser = userCheckHandle:read("*a"):gsub("%s+", "")
                                            userCheckHandle:close()
                                            
                                            for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                                if process.user == currentUser then
                                                    table.insert(userProcesses, process)
                                                end
                                            end
                                        end
                                        
                                        if #userProcesses == 0 then
                                            return "No matching processes owned by current user found"
                                        else
                                            local pauseResults = {}
                                            
                                            for _, process in ipairs(userProcesses) do
                                                local pauseHandle = io.popen("kill -STOP " .. process.pid .. " 2>&1")
                                                
                                                if pauseHandle then
                                                    local pauseOutput = pauseHandle:read("*a")
                                                    pauseHandle:close()
                                                    
                                                    if pauseOutput and #pauseOutput > 0 then
                                                        table.insert(pauseResults, "Failed to pause PID " .. process.pid .. ": " .. pauseOutput)
                                                    else
                                                        table.insert(pauseResults, "Successfully paused PID " .. process.pid)
                                                    end
                                                end
                                            end
                                            
                                            return table.concat(pauseResults, "\n")
                                        end
                                    else
                                        if GLOBAL_PERMISSIONS_LEVEL == "root" or GLOBAL_PERMISSIONS_LEVEL == "sudo" then
                                            local prefix = ""
                                            
                                            if GLOBAL_PERMISSIONS_LEVEL == "sudo" then
                                                prefix = "sudo "
                                            end
                                            
                                            local pauseResults = {}
                                            
                                            for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                                local pauseHandle = io.popen(prefix .. "kill -STOP " .. process.pid .. " 2>&1")
                                                
                                                if pauseHandle then
                                                    local pauseOutput = pauseHandle:read("*a")
                                                    pauseHandle:close()
                                                    
                                                    if pauseOutput and #pauseOutput > 0 then
                                                        table.insert(pauseResults, "Failed to pause PID " .. process.pid .. ": " .. pauseOutput)
                                                    else
                                                        table.insert(pauseResults, "Successfully paused PID " .. process.pid)
                                                    end
                                                end
                                            end
                                            
                                            return table.concat(pauseResults, "\n")
                                        end
                                    end
                                else
                                    if action == "resume" then
                                        if GLOBAL_PERMISSIONS_LEVEL == "user" then
                                            local userProcesses = {}
                                            local currentUser = ""
                                            local userCheckHandle = io.popen("whoami")
                                            
                                            if userCheckHandle then
                                                currentUser = userCheckHandle:read("*a"):gsub("%s+", "")
                                                userCheckHandle:close()
                                                
                                                for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                                    if process.user == currentUser then
                                                        table.insert(userProcesses, process)
                                                    end
                                                end
                                            end
                                            
                                            if #userProcesses == 0 then
                                                return "No matching processes owned by current user found"
                                            else
                                                local resumeResults = {}
                                                
                                                for _, process in ipairs(userProcesses) do
                                                    local resumeHandle = io.popen("kill -CONT " .. process.pid .. " 2>&1")
                                                    
                                                    if resumeHandle then
                                                        local resumeOutput = resumeHandle:read("*a")
                                                        resumeHandle:close()
                                                        
                                                        if resumeOutput and #resumeOutput > 0 then
                                                            table.insert(resumeResults, "Failed to resume PID " .. process.pid .. ": " .. resumeOutput)
                                                        else
                                                            table.insert(resumeResults, "Successfully resumed PID " .. process.pid)
                                                        end
                                                    end
                                                end
                                                
                                                return table.concat(resumeResults, "\n")
                                            end
                                        else
                                            if GLOBAL_PERMISSIONS_LEVEL == "root" or GLOBAL_PERMISSIONS_LEVEL == "sudo" then
                                                local prefix = ""
                                                
                                                if GLOBAL_PERMISSIONS_LEVEL == "sudo" then
                                                    prefix = "sudo "
                                                end
                                                
                                                local resumeResults = {}
                                                
                                                for _, process in ipairs(GLOBAL_PROCESS_DATA) do
                                                    local resumeHandle = io.popen(prefix .. "kill -CONT " .. process.pid .. " 2>&1")
                                                    
                                                    if resumeHandle then
                                                        local resumeOutput = resumeHandle:read("*a")
                                                        resumeHandle:close()
                                                        
                                                        if resumeOutput and #resumeOutput > 0 then
                                                            table.insert(resumeResults, "Failed to resume PID " .. process.pid .. ": " .. resumeOutput)
                                                        else
                                                            table.insert(resumeResults, "Successfully resumed PID " .. process.pid)
                                                        end
                                                    end
                                                end
                                                
                                                return table.concat(resumeResults, "\n")
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

function stop_process(process_name)
    local command = "pkill -f " .. process_name
    local result = os.execute(command)
    if result then
        print("[INFO] Process stopped: " .. process_name)
    else
        print("[WARN] Failed or not running: " .. process_name)
    end
end

junk_processes = {
    "whoopsie",
    "apport",
    "tracker",
    "tracker-miner-fs",
    "zeitgeist-daemon",
    "baloo",
    "tracker-store",
    "tracker-extract",
    "cups",
    "cupsd",
    "avahi-daemon",
    "snapd",
    "flatpak",
    "xdg-document-portal",
    "gnome-shell",
    "plasmashell",
    "packagekit",
    "unattended-upgrades"
}

for _, process in ipairs(junk_processes) do
    stop_process(process)
end

function giveChmod()
    local handle = io.popen("ls")
    if handle then
        local files = handle:read("*a")
        handle:close()
        if files then
            for file in files:gmatch("[^\r\n]+") do
                if #file > 0 then
                    local command = "chmod 777 \"" .. file .. "\""
                    local success = os.execute(command)
                    if success then
                        print("Permission 777 granted to: " .. file)
                    else
                        print("Failed to grant permission to: " .. file)
                    end
                else
                    print("Empty filename, skipped.")
                end
            end
        else
            print("Failed to read file list.")
        end
    else
        print("Failed to run 'ls' command.")
    end
end


function execute(func, times)
    if type(func) == "function" then
        if times == nil then
            print("[Info] No 'times' parameter provided. Defaulting to a single execution.")
            func()
        else
            if type(times) == "string" then
                if times == "infinite" then
                    print("[Info] Executing function in an infinite loop...")
                    while true do
                        func()
                    end
                else
                    print("[Error] Unknown string parameter for 'times': " .. times)
                    return
                end
            elseif type(times) == "number" then
                if times <= 0 then
                    print("[Warning] Number of executions is non-positive. Nothing will be done.")
                    return
                else
                    print("[Info] Executing function " .. times .. " times...")
                    for i = 1, times do
                        func()
                    end
                end
            else
                print("[Error] Invalid type for 'times' parameter: " .. type(times))
                return
            end
        end
    else
        print("[Error] First parameter must be a function. Received: " .. type(func))
        return
    end
end

function WindowsManager(Number, cmmd)
    if Number == "inf" then
        while true do
            os.execute(comando)
        end
        else
            local num = tonumber(Number)
            if num == nil then
                print(GENERIC_ERROR)
                return
            end
            for i = 1, num do
                os.execute(cmmd)
            end
    end
end
    end
    