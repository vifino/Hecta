-- General Functions: Useful collection
function splitToTable(text, seperator)
	local returnTable = {}
	for word in text:gmatch(seperator) do table.insert(returnTable, word) end
	return returnTable
end
function concatTable(input, seperator)
	local concatString = ""
	if seperator ~= nil then
		for i,item in pairs(input) do
			concatString = concatString..seperator..item
		end
		return concatString
	else
		for i,item in pairs(input) do
			concatString = concatString..item
		end
		return concatString
	end
end
-- trim whitespace from both ends of string
function trim(s)
	if s ~= nil then
		return string.find(s,'^%s*$') and '' or string.match(s,'^%s*(.*%S)')
	else
		return s
	end
end

-- trim whitespace from left end of string
function triml(s)
	if s ~= nil then
		return string.match(s,'^%s*(.*)')
	else
		return s
	end
end

-- trim whitespace from right end of string
function trimr(s)
	if s ~= nil then
		return string.find(s,'^%s*$') and '' or s:match(s,'^(.*%S)')
	else
		return s
	end
end
local http = require("socket.http")
function putHastebin(text)
	local newtext = text:gsub("\\n", string.char(10))
	local data,err=http.request("http://hastebin.com/documents",newtext)
	if data and data:match('{"key":"(.-)"') then
		local id = data:match('{"key":"(.-)"')
		return "http://hastebin.com/"..id
	end
	return "Error: "..err
end
function getHastebin(code)
	local data,err=http.request("http://hastebin.com/raw/"..code)
	if data then
		return data
	else
		return "Error: "..err
	end
end
function splitn(txt,num)
	local o={}
	while #txt>0 do
		table.insert(o,txt:sub(1,num))
		txt=txt:sub(num+1)
	end
	return o
end
function splitbyLines(text)
	local returnTable = {}
	for line in string:gmatch("[^\r\n]+") do
		table.insert(returnTable, line)
	end
	return returnTable
end
function inTableKey(tablein,query)
    for i,v in pairs(tablein) do
       if i == query then return true end
    end
    return false
end
function inTableVal(tablein,query)
    if tablein == nil then return nil end
    for i,v in pairs(tablein) do
       if v == query then return true end
    end
    return false
end
escape_lua_pattern = nil
do
  local matches =
  {
    ["^"] = "%^";
    ["$"] = "%$";
    ["("] = "%(";
    [")"] = "%)";
    ["%"] = "%%";
    ["."] = "%.";
    ["["] = "%[";
    ["]"] = "%]";
    ["*"] = "%*";
    ["+"] = "%+";
    ["-"] = "%-";
    ["?"] = "%?";
    ["\0"] = "%z";
  }

  escape_lua_pattern = function(s)
    return (s:gsub(".", matches))
  end
end