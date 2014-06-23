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
			if number > 255 or number < 0 then number = 0 end
			if char == "d" then
				number = number - 1
			elseif char == "i" then
				number = number + 1
			elseif char == "o" then
				output = output..tostring(number)
			elseif char == "s" then
				number = number * number
			end
		end)
		return output
	end
end
commands["deadfish"] = deadfish
commands["df"] = deadfish
function deadfishplus(input) -- is only improved, or extended deadfish
	if type(input) == "string" then
		local output = ""
		local number = 0
		local partString = ""
		local interpretedString = "local output2 = \"\" local out = \"\" local number = 0 output2=output2..out out,number = evaldfp(\""
		function evaldfp(input) 
			string.gsub(string.lower(input),".",function(char)
				if number > 255 or number < 0 then number = 0 end
				if char == "d" then
					number = number - 1
				elseif char == "i" then
					number = number + 1
				elseif char == "o" then
					output = output..tostring(number)
				elseif char == "s" then
					number = number * number
				elseif char == "c" then
				output = output..string.char(number)
				elseif char == "r" then
					number = 0
				elseif string.match(char,"[0-9]") then
					number = number + tonumber(char)
				end
			end)
			print(number)
			print(type(number))
			return output,number
		end
		string.gsub(string.lower(input),".",function(char)
			--[[if char == "[" then
				interpretedString = interpretedString .. "\") for i=0,number,1 do output2=output2..out out,number = evaldfp(\""
				partString = ""
			elseif char == "]" then
				interpretedString = interpretedString.."\") end output2=output2..out out,number = evaldfp(\""
			else
				interpretedString = interpretedString .. char
			end]]
			if char == "[" then
				interpretedString = interpretedString .. "\") for i=1,number,1 do output2=output2..out out,number = evaldfp(\""
				partString = ""
			elseif char == "]" then
				interpretedString = interpretedString.."\") end output2=output2..out out,number = evaldfp(\""
			elseif char == "{" then
				interpretedString = interpretedString .. "\") while number > 1 do output2=output2..out out,number = evaldfp(\""
				partString = ""
			elseif char == "}" then
				interpretedString = interpretedString.."\") end output2=output2..out out,number = evaldfp(\""
			else
				interpretedString = interpretedString .. char
			end
		end)
		interpretedString = interpretedString .. "\") return output2"
		print(interpretedString)
		local func,err=loadstring(interpretedString)
		if not func then
			return err
		end
		--local func=coroutine.create(setfenv(func,_G))
		local func=coroutine.create(func)
		debug.sethook(func,function() error("Time limit exeeded.",0) end,"",200000)
		local err,res=coroutine.resume(func)
		evaldfp = nil
		return output
	end
end
commands["deadfish+"] = deadfishplus
commands["df+"] = deadfishplus
function dfpencoder(input)
	local base = 81
	local output = "9s"
	local currentnum = base
	string.gsub(input,".",function(char)
		local relative = string.byte(char) - currentnum
		if relative > 0 then -- Positive
			--local nines = relative - math.floor(relative/9)*9
			--output = output..string.rep("9", nines)
			--currentnum = currentnum + (9 * nines)
			local relative = string.byte(char) - currentnum
			currentnum = currentnum + relative
			output = output..string.rep("i",relative).."c"
		else --Negative
			local relative = math.abs(relative)
			currentnum = currentnum - relative
			output = output..string.rep("d",relative).."c"
		end
	end)
	return output
end
commands["df+enc"] = dfpencoder
local swagStorage = {}
function swaglang(input)
	local output = ""
	local currentCell = 0
	local number = 0
	local charbuff = ""
	local finalOut = ""
	local number = 0
	local partString = ""
	local interpretedString = "local output2 = \"\" local out = \"\" local number = 0 output2=output2..out number,out,currentCell,swagStorage = evalswag(\""
	function round(num, idp)
	  local mult = 10^(idp or 0)
	  return math.floor(num * mult + 0.5) / mult
	end
	function evalswag(input) 
		string.gsub(string.lower(input),".",function(char)
			number = round(number,0)
			if number > 255 or number < 0 then number = 0 end
			if currentCell > 255 or currentCell < 0 then currentCell = 0 end
			if char == "-" then
				number = number - 1
			elseif char == "+" then
				number = number + 1
			elseif char == ";" then
				output = output..string.char(number)
			elseif char == "^" then
				number = number * number
			elseif char == "#" then
				swagStorage[currentCell] = number
			elseif char == "*" then
				number = 0
			elseif string.match(char,"[0-9]") then
				currentCell = tonumber(char)
			elseif char == "_" then
				number = swagStorage[currentCell] or 0
			elseif char == ">" then
				currentCell = currentCell + 1
			elseif char == "<" then
				currentCell = currentCell - 1
			elseif char == "=" then
				if number == swagStorage[currentCell] then number = 1 else number = 0 end
			elseif char == ":" then
				output = output .. tostring(number)
			elseif char == "d" then
				number = number + number
			elseif char == "h" then
				number = number / 2
			end
			--number = round(number)
		end)
		return number,output,currentCell,swagStorage
	end
	string.gsub(string.lower(input),".",function(char)
		if char == "[" then
			interpretedString = interpretedString .. "\") for i=1,number,1 do output2=output2..out number,out,currentCell,swagStorage = evalswag(\""
			partString = ""
		elseif char == "]" then
			interpretedString = interpretedString.."\") end output2=output2..out number,out,currentCell,swagStorage = evalswag(\""
		elseif char == "{" then
			interpretedString = interpretedString .. "\") while number > 1 do output2=output2..out number,out,currentCell,swagStorage = evalswag(\""
			partString = ""
		elseif char == "}" then
			interpretedString = interpretedString.."\") end output2=output2..out number,out,currentCell,swagStorage = evalswag(\""
		elseif char == "?" then
			interpretedString = interpretedString .. "\") if swagStorage[currentCell] == number then output2=output2..out number,out,currentCell,SwagStorage = evalswag(\""
		elseif char == "." then
			interpretedString = interpretedString .."\") end output2=output2..out number,out,currentCell,swagStorage = evalswag(\""
		elseif char == "!" then
			interpretedString = interpretedString .. "\") else output2=output2..out number,out,currentCell,swagStorage = evalswag(\""
		else
			interpretedString = interpretedString .. char
		end
	end)
	interpretedString = interpretedString .. "\") output2=output2..out print(swagStorage[currentCell]) return output2"
	print(interpretedString)
	local func,err=loadstring(interpretedString)
	if not func then
		return err
	end
	local func=coroutine.create(setfenv(func,_G))
	--local func=coroutine.create(func)
	debug.sethook(func,function() error("Time limit exeeded.",0) end,"",200000)
	local err,res=coroutine.resume(func)
	return output
end
commands["swaglang"] = swaglang
function swagcoder(input)
	local base = 81
	local output = "+++++++++^"
	local currentnum = base
	string.gsub(input,".",function(char)
		local relative = string.byte(char) - currentnum
		if relative > 0 then -- Positive
			local relative = string.byte(char) - currentnum
			currentnum = currentnum + relative
			output = output..string.rep("+",relative)..";"
		else --Negative
			local relative = math.abs(relative)
			currentnum = currentnum - relative
			output = output..string.rep("-",relative)..";"
		end
	end)
	return output
end
commands["swagcoder"] = swagcoder