-- Functions for ]-[, provide basic IRC Functions
-- Made by vifino
function send(txt)
	server:send(txt.."\r\n")
end
function getMsgType(line)
	if line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :ACTION(.*)") then
		local user,channel,action=line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :ACTION(.*)")
		print("* "..user..action)
		return "action",user,channel,action
	elseif line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :PING (.*)") then
		local user,channel,pingmsg=line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :PING (.*)")
		return "ctcp-ping",user,channel,pingmsg
	elseif line:match("^PING") then
		return "ping",nil,nil,line:match("^PING")
	elseif line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :(.*)") then
		local user,channel,message=line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :(.*)")
		return "msg",user,channel,message
	elseif line:match(":(%S+)!%S+@%S+ NOTICE (.-) :(.*)") then
		local user,to,notice=line:match(":(%S+)!%S+@%S+ NOTICE (.-) :(.*)")
		return "notice",user,nil,notice
	elseif line:match(":(%S+)!%S+@%S+ NICK :(.*)") then
		local user,newnick=line:match(":(%S+)!%S+@%S+ NICK :(.*)")
		return "nickChange",user,nil,newnick
	end
end
function printPretty(line)
	if line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :ACTION(.*)") then
		local user,channel,action=line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :ACTION(.*)")
		print("* "..user..action)
	elseif line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :PING (.*)") then
			local user,channel,pingmsg=line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :PING (.*)")
			msg(use, "PONG "..pingmsg)
	elseif line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :(.*)") then
		local user,channel,message=line:match(":(%S+)!%S+@%S+ PRIVMSG (.-) :(.*)")
		print(user.." -> "..channel..": "..message)
	elseif line:match(":(%S+)!%S+@%S+ NOTICE (.-) :(.*)") then
		local user,to,notice=line:match(":(%S+)!%S+@%S+ NOTICE (.-) :(.*)")
		print("--- "..user..": "..notice)
	elseif line:match(":(%S+)!%S+@%S+ NICK :(.*)") then
		local user,newnick=line:match(":(%S+)!%S+@%S+ NICK :(.*)")
		print("User "..user.." is now known as "..newnick)
	else
		print(line)
	end
end
function isPrivileged(nick)
	local privileged = false
	for i,name in pairs(admins) do
		if name == nick then
			privileged = true
		end
	end
	return privileged 
end
function isBlacklisted(nick)
	local blacklisted = false
	for i,name in pairs(blacklist) do
		if name == nick then
			blacklisted = true
		end
	end
	return blacklisted 
end
function setFlags(user,channel,flags)
	msg("ChanServ", "FLAGS "..channel.." "..user.." "..flags)
end
function join( channel )
	print("Joining "..channel)
	--table.insert(channels,channel)
	send("JOIN "..channel)
end
function joinChannels()
	local channelList = channels
	for i,channel in pairs(channelList) do
		join(channel)
	end
end
function part( channel )
	print("Parting "..channel)
	--table.insert(channels,channel)
	send("PART "..channel)
end
function msg(channel, msg)
	if (channel and msg) then
		local newmsg = msg
		--local newmsg = msg:gsub("[\r\n]", "|")
		local privmsgStr = "PRIVMSG "..channel.." :"
		for i,item in pairs(splitn(newmsg,512-#privmsgStr-4)) do
			print(username.." -> "..channel..": "..item)
			send("PRIVMSG "..channel.." :"..item)
		end
	else
		print("Error: Not enough arguments.")
	end
end
function action( channel, text)
	print("* "..username.." "..text)
	send("PRIVMSG "..channel.." :\01ACTION "..text.."\01")
end
function kick(channel,nick,msg)
	if msg then
		send("KICK "..channel.." "..nick.." :"..msg.."\r\n")
	else
		send("KICK "..channel.." "..nick.."\r\n")
	end
end
function userList(channel)
	local users = {}
	users["nicknames"] = {}
	users["hostnames"] = {}
	users["realnames"] = {}
	send("WHO "..channel.." %hna")
	local finished
	while not finished do
		local line = receive()
		if line:match(":(.*) 315 "..escape_lua_pattern(username).." "..escape_lua_pattern(channel).." :End of /WHO list.") then
			finished = true
		else
			local ircServer,userhost, usernick, userreal = line:match(":(.*) 354 "..escape_lua_pattern(username).." (.*) (.*) (.*)")
			if (ircServer ~= nil and userreal ~= nil) then
				table.insert(users["nicknames"], usernick)
				table.insert(users["hostnames"], userhost)
				if userreal == "0" then
					table.insert(users["realnames"], usernick)
				else
					table.insert(users["realnames"], userreal)
				end
			end
		end
	end
	return users
end
function getTopic(channel)
	if not channel then return nil end
	local topicText = ""
	send("TOPIC "..channel)
	local finished = false
	while not finished do
		local line = receive()
		if line:match(":(.*) 332 "..escape_lua_pattern(username).." "..escape_lua_pattern(channel).." :(.*)") then
			local ircserver,topicText = line:match(":(.*) 332 "..escape_lua_pattern(username).." "..escape_lua_pattern(channel).." :(.*)")
			print("server: "..ircserver)
			print("Topic: "..topicText)
			return topicText
		end
	end
end
function setTopic(channel,topic)
	if not channel then return nil end
	send("TOPIC "..channel.." :"..topic)
end
function notice(channel,text)
	send("NOTICE "..channel.." :"..text)
end
-- End IRC Functions