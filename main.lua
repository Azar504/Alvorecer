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

function cmd_run(cmd)
    os.execute(cmd)
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