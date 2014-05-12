function randomUser(text,nick,channel)
	users = userList(channel)
	usernum = math.random(#users["nicknames"]) 
	return text..users["nicknames"][usernum] 
end
commands["randomuser"] = randomUser