-- WIP IRC Library, do not use
--local socket = require("socket")
irc = {}
local instances = {}
local function splitn(txt,num)
	local o={}
	while #txt>0 do
		table.insert(o,txt:sub(1,num))
		txt=txt:sub(num+1)
	end
	return o
end
local function splitToTable(text, seperator)
	local returnTable = {}
	for word in text:gmatch(seperator) do table.insert(returnTable, word) end
	return returnTable
end
function irc.spawn(serverAddress, port, nickname, username, realname, password)
    local currentInstance = {}
    currentInstance["nick"] = nickname
    currentInstance["address"] = serverAddress
    currentInstance["port"] = port
    currentSocket = socket.connect(serverAddress, port)
    currentInstance["socket"] = currentSocket
    function currentInstance:send(txt)
	    self["socket"]:send(txt.."\r\n")
    end
    function currentInstance:msg(user,text)
        if (user and text) then
	    	local privmsgStr = "PRIVMSG "..user.." :"
	    	for i,item in pairs(splitn(text,512-#privmsgStr-4)) do
	    		print(self["nick"].." -> "..user..": "..item)
	    		self:send("PRIVMSG "..user.." :"..item)
	    	end
	    else
	    	print("Error: Not enough arguments.")
    	end
    end
    function currentInstance:join(channel)
        self:send("JOIN "..channel)
    end
    local function ircjoin(channel)
        send("JOIN "..channel)
    end
    function currentInstance:part(channel,reason)
        if reason == nil then
            self:send("PART "..channel)
        else
            self:send("PART "..channel.." :"..reason)
        end
    end
    function currentInstance:joinTable(channels)
    	for i,channel in pairs(channels) do
    		self:join(channel)
    	end
    end
    function currentInstance:action( channel, text)
    	print("* "..username.." "..text)
    	send("PRIVMSG "..channel.." :\01ACTION "..text.."\01")
    end
    function currentInstance:receive()
        local server = self["socket"]
    	line = server:receive()
    	if line:match("^PING") then
    		self:send(line:gsub("PING","PONG"))
    	elseif line:match("^:(.*) KICK (.*) "..username.." :(.*)") then
    		local _, channel, kickreason = line:match("^:(.*) KICK (.*) "..username.." :(.*)") 
    		self:join(channel)
    	end
	    return line
    end
    local function ircreceive()
    	line = currentSocket:receive()
    	if line:match("^PING") then
    		send(line:gsub("PING","PONG"))
    	elseif line:match("^:(.*) KICK (.*) "..username.." :(.*)") then
    		local _, channel, kickreason = line:match("^:(.*) KICK (.*) "..username.." :(.*)") 
    		join(channel)
    	end
	    return line
    end
    local connected = false
    --[[while not connected do
        local line = ircreceive()
        if line ~= nil then
            connected = true
        else
            print(line)
        end
    end]]
    print(type(currentSocket))
    currentSocket:send("NICK "..nickname)
    currentSocket:send("USER "..username .." ~ :"..realname)
    local modeset = false
    --[[while not modeset do
	    local line = ircreceive()
	    local inputTable = splitToTable(line, "%S+")
	    --if line:match("^:"..username.." MODE "..username.." :") then
	    if (inputTable[1] == ":"..username) and (inputTable[2] == "MODE") and (inputTable[3] == username) then
		    modeset = true
    		print("Matching!")
    	else
    		print(line)
    	end
    end
    ]]
    if password ~= nil then
    	print("Password set, identifying...")
    	currentSocket:send("PRIVMSG NickServ :identify ".. password)
    	local identified = false
	end
    --if currentInstance["socket"].isAlive() then
    return currentInstance
    --else
    --    return nil
   -- end
end