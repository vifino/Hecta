-- Lua Admin Shell, and lua sandbox
-- Made by ping and vifino
do
	local function maxval(tbl)
		local mx=0
		for k,v in pairs(tbl) do
			if type(k)=="number" then
				mx=math.max(k,mx)
			end
		end
		return mx
	end
	local sbox
	local usr
	local out
	local function rst()
		local tsbox={}
		sbox={
			_VERSION=_VERSION,
			assert=assert,
			error=error,
			getfenv=function(func)
				if tsbox[func] then
					return false,"Nope."
				end
				local res=getfenv(func)
				if res==_G then
					return sbox
				end
				return res
			end,
			getmetatable=getmetatable,
			ipairs=ipairs,
			load=function(func,name)
				local out=""
				while true do
					local n=func()
					if not n or n=="" then
						return out
					end
					out=out..n
				end
				return sbox.loadstring(out,name)
			end,
			loadstring=function(txt,name)
				if txt:sub(1,1)=="\27" then
					return false,"Nope."
				end
				local func,err=loadstring(txt,name)
				if func then
					setfenv(func,sbox)
				end
				return func,err
			end,
			next=next,
			pairs=pairs,
			pcall=pcall,
			print=function(...)
				for k,v in pairs({...}) do
					out=out..tostring(v).."\n"
				end
			end,
			rawequal=rawequal,
			rawget=rawget,
			rawset=rawset,
			select=select,
			setfenv=function(func,env)
				if tsbox[func] then
					return false,"Nope."
				end
				return setfenv(func,env)
			end,
			setmetatable=setmetatable,
			tonumber=tonumber,
			tostring=tostring,
			type=type,
			unpack=unpack,
			xpcall=xpcall,
			os={
				clock=os.clock,
				date=os.date,
				difftime=os.difftime,
				execute=function(txt)
					local cmd,tx=txt:match("^(.-) (.+)$")
					cmd=cmd or txt
					if cmd=="slap" or cmd=="jenkins" or cmd=="j" or cmd=="beta" or cmd=="build" or cmd=="short" or cmd=="s" then -- spammy / slow
						return false,"Nope."
					end
					return hook.queue("command_"..(cmd or txt),usr,usr.chan,tx or "")
				end,
				exit=function()
					error()
				end,
				time=os.time,
			},
			io={
				write=function(...)
					out=out..table.concat({...})
				end,
			},
		}
		for k,v in pairs({
			coroutine=coroutine,
			math=math,
			table=table,
			string=string,
		}) do
			sbox[k]={}
			for n,l in pairs(v) do
				sbox[k][n]=l
			end
		end
		for k,v in pairs(sbox) do
			if type(v)=="table" then
				for n,l in pairs(v) do
					tsbox[l]=true
				end
			elseif type(v)=="function" then
				tsbox[v]=true
			end
		end
		sbox._G=sbox
	end
	rst()
	commands["resetlua"]=function()
		rst()
		return "Sandbox reset."
	end
	commands["lua"]=function(txt,nick,chan)
		local user={nick=nick,chan=chan}
		usr=user
		out=""
		local func,err=loadstring("return "..txt,"=lua")
		if not func then
			func,err=loadstring(txt,"=lua")
			if not func then
				return err:gsub("^[\r\n]+",""):gsub("[\r\n]+$",""):gsub("[\r\n]+"," | "):sub(1,440)
			end
		end
		local func=coroutine.create(setfenv(func,sbox))
		debug.sethook(func,function()
			debug.sethook(func)
			debug.sethook(func,function()
				error("Time limit exeeded.",0)
			end,"",1)
			error("Time limit exeeded.",0)
		end,"",20000)
		local res={coroutine.resume(func)}
		local o
		for l1=2,maxval(res) do
			o=(o or "")..tostring(res[l1]).."\n"
		end
		return (out..(o or "nil")):gsub("^[\r\n]+",""):gsub("[\r\n]+$",""):gsub("[\r\n]+"," | "):sub(1,440)
	end
	commands[">>"]=function(txt,nick,chan)
		if isPrivileged(nick) then
			local func,err=loadstring("return "..txt,"=lua")
			if not func then
				func,err=loadstring(txt,"=alua")
				if not func then
					return err
				end
			end
			local res={pcall(func)}
			local o
			for l1=2,maxval(res) do
				o=(o or "")..tostring(res[l1]).."\n"
			end
			return o or "nil"
		else
			return "Nope."
		end
	end
	commands["aluafile"]=function(text,nick,channel)
		local inputTable = splitToTable(text, "%S+")
		if inputTable[1] then
			for i,item in pairs(splitbyLines(text)) do
				commands[">>"](item,nick,channel)
			end
		else
			return "Error: Can't execute nothing!"
		end
	end
	commands["luafile"]=function(text,nick,channel)
		local inputTable = splitToTable(text, "%S+")
		if inputTable[1] then
			for i,item in pairs(splitbyLines(text)) do
				commands["lua"](item,nick,channel)
			end
		else
			return "Error: Can't execute nothing!"
		end
	end
end
