messageStorage = {}
function tell(nick,from,message)
	if not messageStorage[nick] then messageStorage[nick] = {} end
	local tmpmsg = {}
	print(nick)
	print(from)
	print(message)
	table.insert(tmpmsg,nick)
	table.insert(tmpmsg,from)
	table.insert(tmpmsg,message)
	messageStorage[nick][(#messageStorage[nick]or 0)+1] = tmpmsg
end
function showTells(text,nick,channel)
	print(nick)
	print(messageStorage)
	print(messageStorage[nick])
	local messages = messageStorage[nick] or {}
	msg(nick, "You have "..tostring(#messages).." messages!")
	for i in pairs(messages) do
		local currentMessage = messages[i]
		local to = currentMessage[1]
		local from = currentMessage[2]
		local body = currentMessage[3]
		print(nick)
		print(from)
		print(body)
		msg(to,"Message from "..from..": "..body)
	end
	messageStorage[nick] = {}
end
commands["showtells"] = showTells
commands["tell"] = function(text,nick,channel,...)
	local args = {...}
	local to = args[1]
	print(to)	
	args[1] = ""
	local body = text:sub(#to+2)
	print(body)
	tell(to,nick,body)
	return "Your message has been stored."
end