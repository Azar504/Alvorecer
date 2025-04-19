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


-------------------------------
-- Command Execution (Linux)
-------------------------------

function cmd_run(cmd)
    os.execute(cmd)
end