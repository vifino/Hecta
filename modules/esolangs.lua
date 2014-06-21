-- Esolangs, may require extra software
-- Made by vifino
function lolcode(text,nick,channel)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] then
		if text == "-v" then
			return system.cmd("lci -v")
		else
			local command = "echo \'"..text.."\' > /tmp/lolcodefile"
			system.cmd(command)
			local lolreturn = system.cmd("lci /tmp/lolcodefile")
			system.cmd("rm /tmp/lolcodefile")
			return lolreturn
		end
	else
		return "Error: Not enough Argumens."
	end
end
if enable_lolcode then
	commands["lolcode"] = lolcode
end
function coffeescript(text,nick,channel)
	if text == "-v" then
		return system.cmd("coffee -v")
	else
		local command = "echo \'"..text.."\' > /tmp/coffeecodefile"
		system.cmd(command)
		local lolreturn = system.cmd("coffee /tmp/coffeecodefile")
		system.cmd("rm /tmp/coffeecodefile")
		return lolreturn
	end
end
--commands["coffeescript"] = coffeescript
function brainfuck(txt) -- Originally by ping, I dunno understand this brainfucking logic.
	return loadstring(
		"local s,p,o={},0,\"\""..txt
		:gsub("[^%[%]%+%-+.%,<>]","")
		:gsub("%]"," end")
		:gsub("%["," while (s[p] or 0)~=0 do")
		:gsub("[%+%-]+",function(txt)
			return " s[p]=((s[p] or 0)"..txt:sub(1,1)..#txt..")%256"
		end)
		:gsub("[<>]+",function(txt)
			return " p=p"..(txt:sub(1,1)==">" and "+" or "-")..#txt
		end)
		:gsub("%."," o=o..string.char(s[p] or 0)")
		:gsub(","," error(\"Input not supported.\")")
	.." return o","=brainfuck")
end
function bf(txt,nick,channel)
	local inputTable = splitToTable(txt, "%S+")
	if inputTable[1] then
			local func,err=brainfuck(txt)
			if not func then
			return err
			end
			local func=coroutine.create(setfenv(func,_G))
			debug.sethook(func,function() error("Time limit exeeded.",0) end,"",200000)
			local err,res=coroutine.resume(func)
			return res
	else
		return "Error: Not enough Arguments."
	end
end
commands["bf"] = bf
function encodebf(text)
	local newtext = text:gsub("\'",""):gsub("\"","")
	local command = 'python '..root..'utils/str2bf.py -s'
	system.cmd(command)
	local bfreturn = system.cmd(command.." "..newtext)
	return bfreturn
end
function encbf(txt,nick,channel)
	local inputTable = splitToTable(txt, "%S+")
	if inputTable[1] then
			local retval = encodebf(txt)
			if not retval then
				return "Error: Unknown."
			else
				return retval
			end
	else
		return "Error: Not enough Arguments."
	end
end
commands["encbf"] = encbf
function rubyeval(text,nick,channel)
	if text == "-v" then
		return system.cmd("ruby -v")
	else
		--local rubycode = 'require "sandbox"\nsand = Sandbox::Safe.new\nsand.eval <<-RUBY\nrequire "bundler"\Bundler.require :sandbox\nRUBY\nsand.activate!\nsand.eval \''..text..'\''
		local rubycode = '$SAFE = 4\neval(\''..text..')\''
		local command = "echo \'"..rubycode.."\' > /tmp/rubyfile"
		system.cmd(command)
		local rubyreturn = system.cmd("ruby /tmp/rubyfile")
		system.cmd("rm /tmp/rubyfile")
		return rubyreturn
	end
end
--commands["ruby"] = rubyeval
function deadfish(input)
	if type(input) == "string" then
		local output = ""
		local number = 0
		string.gsub(input,".",function(char)
			if char == "d" then
				number = number - 1
			elseif char == "i" then
				number = number + 1
			elseif char == "o" then
				output = output..tostring(no)
			elseif char == "s" then
				number = number * number
			end
		end)
		return output
	end
end
commands["deadfish"] = deadfish