function version()
    local version = 0.36
    print("Alvorecer framewok - v" .. version)
end

version()
    


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

function global(table, name, value)
    table[name] = value
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

function grant_max_script_permission(path)
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