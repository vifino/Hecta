-- ]-[ IRC Bot
--  ____              ____
-- / __ \            / __ \
-- |/  \ \          / /  \|
--      | |        | |
--      | |        | |
--      | |________| |
--      |  ________  |
--      | |        | |           ________
--      | |        | |          /   An   \
--      | |        | |         /  IRC bot \
-- |\__/  |        |  \__/|   /  YOUR way  \
-- \_____/          \_____/   \____________/
-- Made by vifino
local socket=require("socket")
if not socket then error("Please install LuaSocket.") end
root = arg[0]:gsub("main.lua","")
LastSaidline = ""
loopCalls = {}
function receive()
	local line=server:receive()
	LastSaidline = line
	if line:match("^PING") then
		send(line:gsub("PING","PONG"))
	elseif line:match("^:(.+) KICK (.+)") then
		local _, channel = line:match("^:(.+) KICK (.+)")
		join(channel)
	end
	return line
end
function loadFiles()
	dofile(root.."settings.lua")
	local oldUsername = username
	dofile(root.."generalFunc.lua")
	dofile(root.."libs/system.lua")
	dofile(root.."libUtil.lua")
	libUtil.loadDir(root.."libs")
	dofile(root.."commandParser.lua")
	libUtil.loadDir(root.."modules")
	initCommands()
end
loadFiles()
server=socket.connect(address,port)
function executeCommand(user,channel,txt)
	local returnVal = ""
	local returnTable = {}
	local funcSuccess,funcOutput=pcall(evalCommand,user, channel, txt)
	if funcSuccess then
		returnVal = string.gsub(funcOutput,"[\r\n]", "|")
	else
		returnVal = "Error: Please open an issue at ]-['s Github: "..putHastebin(funcOutput).."."
	end
	print(returnVal)
	returnTable = splitToTable(returnVal, "%S+")
	if returnTable[1] ~= nil then
		return returnVal
	end
end
function commandHandeler(user,channel,txt)
	local corfunc=coroutine.create(function()
		return executeCommand(user,channel,txt)
	end)
	local _,result=coroutine.resume(corfunc)
	print(_)
	print(result)
	if result then msg(channel,"> "..result) end
end
function botLogic(line)
	local typemsg,user,channel,txt=getMsgType(line)
	if typemsg == "msg" then
		if txt==commandPrefix.."ping" then
			send("PRIVMSG "..channel.." :Pong!")
		elseif txt==commandPrefix.."reload" then
			if isPrivileged(user) then
				loadFiles()
				joinChannels()
				msg(channel, "Reloaded.")
			else
				msg(channel, no())
			end
		elseif (txt:match("^"..escape_lua_pattern(commandPrefix).."(.*)") and txt ~= "$") then
			if isBlacklisted(user) then msg(channel,"> "..no()) else
				print(channel)
				print(user)
				if channel == nickname then
					commandHandeler(user,user,txt:match("^"..escape_lua_pattern(commandPrefix).."(.*)"))
				else
					commandHandeler(user,channel,txt:match("^"..escape_lua_pattern(commandPrefix).."(.*)"))
				end
			end
		end
	end
end
seed()
send("NICK "..username)
send("USER "..username .." ~ ~ :I am a robot")
local modeset = false
while not modeset do
	local line = receive()
	local inputTable = splitToTable(line, "%S+")
	--if line:match("^:"..username.." MODE "..username.." :") then
	if (inputTable[1] == ":"..username) and (inputTable[2] == "MODE") and (inputTable[3] == username) then
		modeset = true
		print("Matching!")
	else
		print(line)
	end
end
if password ~= nil then
	print("Password set, identifying...")
	send("PRIVMSG NickServ :identify ".. password)
	local identified = false
	--[[while not identified do
		local line = receive()
		if line:match("^:NickServ!NickServ@(.*) NOTICE "..username.." :You are now identified for ") then
			identified = true
		end
	end]]
	if nickname ~= nil then
		send("NICK "..nickname)
	end
end
joinChannels()
function startBot()
	while true do
		line=receive()
		printPretty(line)
		botLogic(line)
		for i,func in pairs(loopCalls) do
		   func(line)
		end
	end
end
startBot()