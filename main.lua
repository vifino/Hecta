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
root = arg[0]:gsub("main.lua","")
function sleep(sec)
    socket.select(nil, nil, sec)
end
local exited = false
while not exited do
	local success,error= pcall(dofile,root.."hecta.lua")
	if success then
		local _,exited = pcall(startBot)
	else
		print("Error: "..error)
		local f = assert(io.popen("cd "..root.." && git pull", 'r'))
		local s = assert(f:read('*a'))
		f:close()
		-- Do something with git output
		sleep(60)
	end
end