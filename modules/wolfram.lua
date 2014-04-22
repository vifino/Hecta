-- Wolfram IRC Interface
-- Set the AppID in the settings.lua file
-- Made by vifino
wa.setAppID(WAAppID)
local function wolfram(text,nick, channel)
	if isPrivileged(nick) then
		local inputTable = splitToTable(text, "%S+")
		if inputTable[1] ~= nil then
			local retval
			local query = wa.query(text)
			--print(retval)
			for k,v in ipairs(query) do
				print(v)
			end
			return table.concat(query, " ")
		else
			return "Error: Can\'t search nothing on Wolfram Alpha!"
		end
	else
		return "Nope!"
	end
	
end
commands["wolfram"] = wolfram