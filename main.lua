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
                      
                      
                      
function sum(a, b)
    console(a + b) -- Returns sum of two numbers or strings if applicable
end

function sub(a, b)
    -- Works only with numbers or valid string subtraction (not recommended for strings)
    console(a - b)
end

function multi(a, b)
    console(a * b)
end


function data()
    local datetime = os.date("%d/%m/%Y %H:%M:%S")
    console(datetime)
end 

function createfile(namefile)
    local os_name = "Windows"
    local os_command = "cmd"

    if namefile ~= nil then
        if type(namefile) == "string" then
            if #namefile > 0 then
                if not namefile:find("%p") then
                    if namefile ~= " " then
                        if namefile ~= "" then
                            if os_name then
                                if type(os_name) == "string" then
                                    if os_name == "Windows" then
                                        if os_command then
                                            if type(os_command) == "string" then
                                                return "Windows: File '" .. namefile .. "' created successfully."
                                            else
                                                return "ERROR: Invalid command for Windows"
                                            end
                                        else
                                            return "ERROR: Command not provided for Windows"
                                        end
                                    elseif os_name == "Linux" then
                                        if os_command then
                                            if type(os_command) == "string" then
                                                return "Linux: File '" .. namefile .. "' created successfully."
                                            else
                                                return "ERROR: Invalid command for Linux"
                                            end
                                        else
                                            return "ERROR: Command not provided for Linux"
                                        end
                                    else
                                        return "ERROR: Unsupported OS"
                                    end
                                else
                                    return "ERROR: OS name is not a valid string"
                                end
                            else
                                return "ERROR: OS name is nil"
                            end
                        else
                            return "ERROR: Filename is empty"
                        end
                    else
                        return "ERROR: Filename is a space"
                    end
                else
                    return "ERROR: Filename contains punctuation"
                end
            else
                return "ERROR: Filename is too short"
            end
        else
            return "ERROR: Filename must be a string"
        end
    else
        return "ERROR: Filename is nil"
    end
end

function deletefile(name)
    local os_name = "Linux"
    local os_command = "rm"

    if name ~= nil then
        if type(name) == "string" then
            if #name > 0 then
                if name ~= " " then
                    if name ~= "do_not_delete.txt" then
                        if name:sub(1, 1) ~= "#" then
                            if not name:find("[^%w%.]") then
                                if os_name then
                                    if type(os_name) == "string" then
                                        if os_name == "Windows" then
                                            if os_command then
                                                if type(os_command) == "string" then
                                                    return "Windows: File '" .. name .. "' deleted successfully."
                                                else
                                                    return "ERROR: Invalid command for Windows"
                                                end
                                            else
                                                return "ERROR: Command not provided for Windows"
                                            end
                                        elseif os_name == "Linux" then
                                            if os_command then
                                                if type(os_command) == "string" then
                                                    return "Linux: File '" .. name .. "' deleted successfully."
                                                else
                                                    return "ERROR: Invalid command for Linux"
                                                end
                                            else
                                                return "ERROR: Command not provided for Linux"
                                            end
                                        else
                                            return "ERROR: Unsupported OS"
                                        end
                                    else
                                        return "ERROR: OS name is not a valid string"
                                    end
                                else
                                    return "ERROR: OS name is nil"
                                end
                            else
                                return "ERROR: Filename contains invalid characters"
                            end
                        else
                            return "ERROR: Cannot delete protected files starting with #"
                        end
                    else
                        return "ERROR: Cannot delete the sacred file"
                    end
                else
                    return "ERROR: Filename is a space"
                end
            else
                return "ERROR: Filename is too short"
            end
        else
            return "ERROR: Filename must be a string"
        end
    else
        return "ERROR: Filename is nil"
    end
end

function writefile(name, content)
    local os_name = "Windows"
    local os_command = "echo"

    if name ~= nil and content ~= nil then
        if type(name) == "string" then
            if type(content) == "string" then
                if #name > 0 then
                    if #content > 0 then
                        if not name:find("[^%w%.]") then
                            if not content:find("[\r\n]") then
                                if os_name then
                                    if type(os_name) == "string" then
                                        if os_name == "Windows" then
                                            if os_command then
                                                if type(os_command) == "string" then
                                                    return "Windows: File '" .. name .. "' written with content."
                                                else
                                                    return "ERROR: Invalid command for Windows"
                                                end
                                            else
                                                return "ERROR: Command not provided for Windows"
                                            end
                                        elseif os_name == "Linux" then
                                            if os_command then
                                                if type(os_command) == "string" then
                                                    return "Linux: File '" .. name .. "' written with content."
                                                else
                                                    return "ERROR: Invalid command for Linux"
                                                end
                                            else
                                                return "ERROR: Command not provided for Linux"
                                            end
                                        else
                                            return "ERROR: Unsupported OS"
                                        end
                                    else
                                        return "ERROR: OS name is not a valid string"
                                    end
                                else
                                    return "ERROR: OS name is nil"
                                end
                            else
                                return "ERROR: Content contains newline characters"
                            end
                        else
                            return "ERROR: Filename contains invalid characters"
                        end
                    else
                        return "ERROR: Content is empty"
                    end
                else
                    return "ERROR: Filename is empty"
                end
            else
                return "ERROR: Content is not a string"
            end
        else
            return "ERROR: Filename is not a string"
        end
    else
        return "ERROR: Filename or content is nil"
    end
end

function renamefile(old, new)
    local os_name = "Linux"
    local os_command = "mv"

    if old ~= nil and new ~= nil then
        if type(old) == "string" and type(new) == "string" then
            if old ~= new then
                if #old > 0 and #new > 0 then
                    if not old:find("[^%w%.]") and not new:find("[^%w%.]") then
                        if os_name then
                            if type(os_name) == "string" then
                                if os_name == "Windows" then
                                    if os_command then
                                        if type(os_command) == "string" then
                                            return "Windows: File '" .. old .. "' renamed to '" .. new .. "'"
                                        else
                                            return "ERROR: Invalid command for Windows"
                                        end
                                    else
                                        return "ERROR: Command not provided for Windows"
                                    end
                                elseif os_name == "Linux" then
                                    if os_command then
                                        if type(os_command) == "string" then
                                            return "Linux: File '" .. old .. "' renamed to '" .. new .. "'"
                                        else
                                            return "ERROR: Invalid command for Linux"
                                        end
                                    else
                                        return "ERROR: Command not provided for Linux"
                                    end
                                else
                                    return "ERROR: Unsupported OS"
                                end
                            else
                                return "ERROR: OS name is not a valid string"
                            end
                        else
                            return "ERROR: OS name is nil"
                        end
                    else
                        return "ERROR: Invalid characters in filename"
                    end
                else
                    return "ERROR: Old or new filename is empty"
                end
            else
                return "ERROR: Old name is the same as new name"
            end
        else
            return "ERROR: Old or new name is not a string"
        end
    else
        return "ERROR: Old or new name is nil"
    end
end

function listfiles(dir)
    local os_name = "Windows"
    local os_command = "dir"

    if dir ~= nil then
        if type(dir) == "string" then
            if #dir > 0 then
                if not dir:find("[^%w%/]") then
                    if dir:sub(-1) ~= "/" then
                        dir = dir .. "/"
                    end
                    if os_name then
                        if type(os_name) == "string" then
                            if os_name == "Windows" then
                                if os_command then
                                    if type(os_command) == "string" then
                                        return "Windows: Listing files in directory '" .. dir .. "'"
                                    else
                                        return "ERROR: Invalid command for Windows"
                                    end
                                else
                                    return "ERROR: Command not provided for Windows"
                                end
                            elseif os_name == "Linux" then
                                if os_command then
                                    if type(os_command) == "string" then
                                        return "Linux: Listing files in directory '" .. dir .. "'"
                                    else
                                        return "ERROR: Invalid command for Linux"
                                    end
                                else
                                    return "ERROR: Command not provided for Linux"
                                end
                            else
                                return "ERROR: Unsupported OS"
                            end
                        else
                            return "ERROR: OS name is not a valid string"
                        end
                    else
                        return "ERROR: OS name is nil"
                    end
                else
                    return "ERROR: Invalid characters in directory name"
                end
            else
                return "ERROR: Directory name is empty"
            end
        else
            return "ERROR: Directory name is not a string"
        end
    else
        return "ERROR: Directory name is nil"
    end
end