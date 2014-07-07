-- libUtil.lua
-- Made by vifino
libUtil = {}
function libUtil.loadDir(dir)
	print("LibUtils loading "..dir)
	local libFiles = {}
	for i,file in pairs(system.ls(dir)) do
		print("-> "..file)
		--if file ~= ".DS_Store" and file ~= ".git" and file ~= "README.md"  then
		if file:match("(.*)%.lua")  then
			if not dofile then
				libFiles[file] = require(dir.."/"..file)
			else 
				libFiles[file] = dofile(dir.."/"..file)
			end
		end
	end
	for k,v in pairs(libFiles) do
		_G[k] = v
	end
	print("Done.")
	return libFiles
end
return libUtil