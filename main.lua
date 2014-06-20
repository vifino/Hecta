-- Hectah Loader
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
inputmode = "socket"
local pipeConnector = "nc irc.esper.net 5555"
for _,text in pairs(arg) do
	if text == "-s" then inputmode = "socket" end
	if text == "-p" then inputmode = "pipe" end
	if text == "-h" then print("Commandline Options: [-s | -p] [-h]") os.exit(0) end
end -- Add legacy support once again.
root = arg[0]:gsub("main.lua","")
function sleep(sec)
    socket.select(nil, nil, sec)
end
local exited = false
while not exited do
	local success,error= pcall(dofile,root.."hecta.lua")
	if success then
		if inputmode = "socket" then
			local _,exited = pcall(startBot)
		else -- WIP
			io.popen("prog < $DIR/fifo |echo|lua $DIR/main.lua -p > $DIR/fifo"):gsub("prog",pipeConnector):gsub("$DIR/",root)
		end
	else
		print("Error: "..error)
		local f = assert(io.popen("cd "..root.." && git pull && git submodule update", 'r'))
		local s = assert(f:read('*a'))
		f:close()
		-- Do something with git output
		sleep(60)
	end
end