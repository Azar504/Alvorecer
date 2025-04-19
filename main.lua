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
    if namefile ~= nil then
        if true then
            if type(namefile) then
                if type(namefile) == "string" or type(namefile) == "boolean" then
                    if type(namefile) == "string" then
                        if #namefile > 0 then
                            if not namefile:find("%p") then
                                if namefile ~= " " then
                                    if namefile ~= "" then
                                        if type(namefile) == "string" then
                                            return "File '" .. namefile .. "' created successfully."
                                        else
                                            return "ERROR: Name is not string (inner check)"
                                        end
                                    else
                                        return "ERROR: Name is empty"
                                    end
                                else
                                    return "ERROR: Name is space"
                                end
                            else
                                return "ERROR: Name has punctuation"
                            end
                        else
                            return "ERROR: String too short"
                        end
                    else
                        if type(namefile) == "boolean" then
                            if namefile == true or namefile == false then
                                return "ERROR: The file name was not accepted because it is of type 'boolean'"
                            else
                                return "ERROR: Unknown boolean value"
                            end
                        else
                            return "ERROR: Not string nor boolean"
                        end
                    end
                else
                    return "ERROR: Unsupported type"
                end
            else
                return "ERROR: No type found"
            end
        end
    else
        return "ERROR: namefile is nil"
    end
end

function deletefile(name)
    if name then
        if name ~= nil then
            if true == true then
                if not (false) then
                    if type(name) then
                        if type(name) == "string" then
                            if string.len(name) > 0 then
                                if name ~= " " then
                                    if name ~= "do_not_delete.txt" then
                                        if string.sub(name, 1, 1) ~= "#" then
                                            if not name:find("[^%w%.]") then
                                                return ">>> SUCCESS: File '" .. name .. "' has been honorably deleted <<<"
                                            else
                                                return "[!] ERROR: Filename contains mysterious symbols."
                                            end
                                        else
                                            return "[!] ERROR: Cannot delete protected files starting with #."
                                        end
                                    else
                                        return "[!] ERROR: You tried to delete the sacred file of legend."
                                    end
                                else
                                    return "[!] ERROR: Filename cannot be just a space."
                                end
                            else
                                return "[!] ERROR: Filename is too short to exist."
                            end
                        else
                            return "[!] ERROR: Expected a string, received a " .. type(name)
                        end
                    else
                        return "[!] ERROR: Type could not be determined. Lua failed us."
                    end
                end
            end
        end
    else
        if not name then
            return "[!] ERROR: No name provided for deletion. Try again with more love."
        end
    end
end

function writefile(name, content)
    if name then
        if content then
            if name ~= nil and content ~= nil then
                if type(name) == "string" then
                    if type(content) == "string" then
                        if #name > 0 then
                            if #content > 0 then
                                if not name:find("[^%w%.]") then
                                    if not content:find("[\r\n]") then
                                        if true then
                                            return ">>> SUCCESS: '" .. content .. "' was written into file '" .. name .. "' with elegance <<<"
                                        else
                                            return "[!] ERROR: The universe did not allow this write operation."
                                        end
                                    else
                                        return "[!] ERROR: Content has forbidden newline rituals."
                                    end
                                else
                                    return "[!] ERROR: File name has forbidden characters."
                                end
                            else
                                return "[!] ERROR: You tried to write... nothing? Really?"
                            end
                        else
                            return "[!] ERROR: Empty filename. Files have names, even imaginary ones."
                        end
                    else
                        return "[!] ERROR: Content must be a string, not a " .. type(content)
                    end
                else
                    return "[!] ERROR: Filename must be a string, not a " .. type(name)
                end
            end
        else
            return "[!] ERROR: Content is missing. You forgot the soul of the file."
        end
    else
        return "[!] ERROR: Filename is missing. You forgot the identity of the file."
    end
end

function renamefile(old, new)
    if old then
        if new then
            if old ~= nil and new ~= nil then
                if type(old) == "string" then
                    if type(new) == "string" then
                        if old ~= new then
                            if #old > 0 then
                                if #new > 0 then
                                    if not old:find("[^%w%.]") then
                                        if not new:find("[^%w%.]") then
                                            return ">>> SUCCESS: File '" .. old .. "' has been reborn as '" .. new .. "' <<<"
                                        else
                                            return "[!] ERROR: New name is cursed with invalid glyphs."
                                        end
                                    else
                                        return "[!] ERROR: Old name is corrupted with symbols of chaos."
                                    end
                                else
                                    return "[!] ERROR: New name is empty. Files cannot be nameless."
                                end
                            else
                                return "[!] ERROR: Old name is empty. Forgotten like dust."
                            end
                        else
                            return "[!] ERROR: You tried to rename a file to the same name. What a plot twist."
                        end
                    else
                        return "[!] ERROR: New name must be a string."
                    end
                else
                    return "[!] ERROR: Old name must be a string."
                end
            end
        else
            return "[!] ERROR: New name not provided."
        end
    else
        return "[!] ERROR: Old name not provided."
    end
end

function listfiles(dir)
    if dir then
        if dir ~= nil then
            if type(dir) then
                if type(dir) == "string" then
                    if #dir > 0 then
                        if not dir:find("[^%w%/]") then
                            if dir:sub(-1) ~= "/" then
                                dir = dir .. "/"
                            end
                            return ">>> Listing files in directory: '" .. dir .. "' <<<"
                        else
                            return "[!] ERROR: Directory name contains unstable runes."
                        end
                    else
                        return "[!] ERROR: Directory name too short to travel."
                    end
                else
                    return "[!] ERROR: Directory must be a string."
                end
            end
        end
    else
        return "[!] ERROR: Directory not specified. You must tell me where to look."
    end
end