-- The main LogicParser
-- Made by vifino

commands = {}
commandVars = {}
-- Functions for Commands

function printIRC(text,nick,channel)
	return text
end
function rainbowify(text,nick,channel, ...)
	local c=0
	local colors={"04","07","08","03","02","12","06","04","07"}
	local rainbowText = text:gsub(".",function(t)
		c=(c%9)+1
		return "\3"..colors[c]..t
	end)
	return rainbowText.."\3"
end

function actionCMD(text,nick,channel, ...)
	action(channel,text)
	return ""
end

function returnChannel(text,nick,channel, ...)
	return text.." "..channel
end

function append(text,nick,channel, ...)
	local appendString = ""
	local normalString = ""
	normalString,appendString = text:match("(.+):(.+)")
	if (appendString ~= nil and normalString ~= nil) then
		-- Success
		return appendString.." "..normalString
	else
		-- Missing :
		return "Error: Colon not found!"
	end
end

function random(text,nick,channel, ...)
	math.randomseed( os.time() )
	math.random()
	local inputTable = splitToTable(text, "%S+")
	local number1 = 1
	math.random()
	local number2 = 100
	number1 = tonumber(inputTable[1])
	number2 = tonumber(inputTable[2])
	math.random()
	if (number1 ~= nil and number2 ~= nil) then
		return math.random(number1,number2)
	elseif number1 ~= nil and number2 == nil then
		return math.random(1,number1)
	else
		return "Error: Please input two Numbers."
	end
end

function raw(text,nick,channel, ...)
	if isPrivileged(nick) then
		send(text)
	else
		msg(channel,no())
	end
end

function message(text,nick,channel, ...)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] and inputTable[2] then
		if isPrivileged(nick) then
			table.remove(inputTable,1)
			local msgtext = concatTable(inputTable)
			msg(inputTable[1],msgtext)
		else
			msg(channel,no())
		end
	else
		return "Error: Not enough arguments."
	end
end

function flags(text,nick,channel, ...)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] and inputTable[2] then
		if isPrivileged(nick) then
			setFlags(inputTable[1],channel,inputTable[2])
		else
			msg(channel,no())
		end
	else
		return "Error: Not enough arguments."
	end
end

function joinCMD(text,nick,channel, ...)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] then
		if isPrivileged(nick) then
			join(inputTable[1])
		else
			msg(channel,no())
		end
	else
		return "Error: Not enough arguments."
	end
end

function bold(text,nick,channel, ...)
	return string.char(2)..text
end

function underline(text,nick,channel, ...)
	return string.char(31)..text
end

function italic(text,nick,channel, ...)
	return string.char(22)..text
end

function strikeThrough(text,nick,channel, ...)
	return string.char(19)..text
end

function normal(text,nick,channel, ...)
	return string.char(15)..text
end

function reverse(text,nick,channel, ...)
	return string.char(0xE2,0x80,0xAE)..text
end

function void(text,nick,channel, ...)
	return ""
end

function getVar(text,nick,channel, ...)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] then
		print(inputTable[1])
		if commandVars[inputTable[1]] then
			print(text)
			print(commandVars[inputTable[1]])
			local var = inputTable[1]
			--local newText = text:sub(1,-1*#var)
			return commandVars[inputTable[1]]
		else
			return "Error: Var not existing!"
		end
	else
		return "Error: Not enough arguments."
	end
end

function setVar(text,nick,channel, ...)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] then
		local varContent = string.sub(text,string.len(inputTable[1])+2)
		print(varContent)
		commandVars[inputTable[1]] = varContent
		return varContent
	else
		return "Error: Not enough arguments."
	end
end

function dateCMD(text, nick, channel)
	print("user "..nick.." has asked for the date")
	local date = os.date("%x")
	return text..date
end

function time(text, nick, channel)
	print("user "..nick.." has asked for the time")
	local time = os.date("*t")
	local finalValue = tostring(time[6])..":"..tostring(time[7])

	return text..time
end

function lower(text, nick, channel)
	return string.lower(text)
end

function upper(text, nick, channel)
	return string.upper(text)
end

function kickUser(text, nick, channel)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] == nil then
		return "Error: Please provide username to kick."
	else
		if isPrivileged(nick) then
			if text then
				local kickText = string.sub(text,string.len(inputTable[1])+2)
				kick(channel, inputTable[1], kickText)
			else
				kick(channel, inputTable[1])
			end
			return text
		else
			return no()
		end
	end
end

function repeatCommand(text,nick,channel, ...)
	local cmdString = ""
	local timesString = ""
	timesString,cmdString = text:match("(.+):(.+)")
	if (cmdString ~= nil and timesString ~= nil) then
		-- Succes
		local times = tonumber(timesString)
		print(times)
		if times ~= nil then
			for i = 0, times, 1 do
				evalCommand(nick,channel,string.sub(text,times+2))
			end
		else
			return "Error: Text is not a number!"
		end
	else
		-- Missing ;
		return "Error: Colon not found!"
	end
end


function exitCMD(text, nick, channel)
	local inputTable = splitToTable(text, "%S+")
	if isPrivileged(nick) then
		send("QUIT :Shuting down...")
		os.exit(0)
		return ""
	else
		return no()
	end
end

function doFile(text, nick, channel)
	if text:match("(.*)") then
		return evalFile(text.."\n", nick,channel)
	else
		return "Error: Can\'t execute nothing."
	end

end

function gethb(text, nick, channel)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] then
		local retText = string.sub(text,string.len(inputTable[1])+2)
		return retText..getHastebin(inputTable[1])
	else
		return "Error: Can't get nothing."
	end
end

function helpCMD(text, nick, channel)
	local outputTable = {}
	for i,k in pairs(commands) do table.insert(outputTable,i) end
	return table.concat(outputTable," | ")
end

function topic(text,nick,channel)
	return text..getTopic(channel)
end

function topicset(text,nick,channel)
	if isPrivileged(nick) then
		local inputTable = splitToTable(text, "%S+")
		if inputTable[1] then
			print(text)
			setTopic(channel,text)
		else
			return "Error: Not enough arguments."
		end
		return text
	else return no() end
end

-- End of Command Functions

function initCommands()
	commands["test"] = function(text,nick,channel) return "I am in "..channel.." and you are "..nick.."!" end
	commands["help"] = helpCMD
	commands["rainbow"] = rainbowify
	commands["print"] = printIRC
	commands["action"] = actionCMD
	commands["channel"] = returnChannel
	commands["append"] = append
	commands["random"] = random
	commands["join"] = joinCMD
	commands["raw"] = raw
	--commands["msg"] = message
	--commands["setFlags"] = flags
	commands["bold"] = bold
	commands["underline"] = underline
	commands["italic"] = italic
	commands["normal"] = normal
	commands["strikethrough"] = strikeThrough
	commands["reverse"] = reverse
	commands["void"] = void
	commands["getvar"] = getVar
	commands["setvar"] = setVar
	commands["date"] = dateCMD
	--commands["time"] = time
	commands["upper"] = upper
	commands["lower"] = lower
	commands["kick"] = kickUser
	--commands["repeat"] = repeatCommand
	commands["exit"] = exitCMD
	commands["puthb"] = putHastebin
	commands["gethb"] = gethb
	commands["dofile"] = doFile
	commands["topic"] = topic
	commands["settopic"] = topicset
end
local function doCommand(oldcommand,nick,channel)
	local command = triml(oldcommand)
	local commandItems = {}
	for commandItem in command:gmatch("%S+") do table.insert(commandItems, commandItem) end
	local currentFunc = commands[string.lower(commandItems[1])]
	local argTable = {}
	local argString = ""
	if commandItems[1] ~= nil then
		for i,item in pairs(commandItems) do
			if i ~= 1 then
				table.insert(argTable, item)
			end
		end
		local argString = string.sub(command,string.len(commandItems[1])+2)
		if currentFunc ~= nil then
			-- TODO: Run this pcall'ed
			local funcOutput = currentFunc(argString,nick,channel,unpack(argTable))
			return funcOutput
		else
			if commandNotFoundMessage then
				return "Command \""..commandItems[1].."\" doesn\'t exist."
			end
		end
	else
		return ""
	end

end
function evalCommand(nick,channel,command)
	local commandPiped = {}
	local commandStriped = triml(command)
		local output = {}
		local cmdCount = 0
		for commandItemOld in commandStriped:gmatch("[^|]+") do
      		local commandItem = triml(triml(commandItemOld))
			cmdCount = cmdCount + 1
			if cmdCount > 1 then
				--output[cmdCount] = doCommand(commandItem.." "..output[cmdCount-1],nick,channel)
				output[cmdCount] = doCommand(commandItem..output[cmdCount-1],nick,channel)
			else
				output[1] = doCommand(commandItem,nick,channel)
			end
		end
		if output[#output] ~= nil then
			commandVars["last"] = triml(output[#output])
			return triml(output[#output])
		else
			return ""
		end
end
function evalFile(content,nick,channel)
	local output = {}
	local cmdCount = 0
	for i,command in pairs(splitbyLines(content)) do
		cmdCount = cmdCount + 1
		if command then
			print(command)
			output[cmdCount] = evalCommand(nick,channel,command)
		end
	end
	if output[#output] ~= nil then
		commandVars["last"] = trim(output[#output])
		return trim(output[#output])
	else
		return ""
	end
end
