-- General Functions: Useful collection
function splitToTable(text, seperator)
	local returnTable = {}
	for word in text:gmatch(seperator) do table.insert(returnTable, word) end
	return returnTable
end
string.splitToTable = splitToTable
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
	if type(s) ~= "string" then
		return string.find(s,'^%s*$') and '' or string.match(s,'^%s*(.*%S)')
	else
		return s
	end
end
string.trim = trim
-- trim whitespace from left end of string
function triml(s)
	if type(s) ~= "string" then
		--return string.match(s,'^%s*(.*)')
		return string.gsub(s,'^%s+',"")
	else
		return s
	end
end
string.triml = triml
-- trim whitespace from right end of string
function trimr(s)
	if type(s) ~= "string" then
		return string.find(s,'%s*$') and '' or s:match(s,'^(.*%S)')
	else
		return s
	end
end
string.trimr = trimr
local http = require("socket.http")
function putHastebin(text)
	if not text or text == "" then text = nil err = "Not enough arguments" end
	local newtext = text:gsub("\\n", string.char(10))
	local data,err=http.request("http://hastebin.com/documents",newtext)
	if data and data:match('{"key":"(.-)"') then
		local id = data:match('{"key":"(.-)"')
		return "http://hastebin.com/"..id
	end
	return "Error: "..err
end
function getHastebin(code)
	if not code or code == "" then code = nil err = "Not enough arguments" end
	local data,err=http.request("http://hastebin.com/raw/"..code)
	if data and code then
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
	for line in text:gmatch("[^\r\n]+") do
		table.insert(returnTable, line)
	end
	return returnTable
end
string.splitbyLines = splitbyLines
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
function maxval(tbl)
	local mx=0
	for k,v in pairs(tbl) do
		if type(k)=="number" then
			mx=math.max(k,mx)
		end
	end
	return mx
end
function flipkv(t)
	local nt = {}
	for k,v in pairs(t) do
		nt[v] = k
	end
	return nt
end
local hex2bint = {
	["0"] = "0000",
	["1"] = "0001",
	["2"] = "0010",
	["3"] = "0011",
	["4"] = "0100",
	["5"] = "0101",
	["6"] = "0110",
	["7"] = "0111",
	["8"] = "1000",
	["9"] = "1001",
	["a"] = "1010",
	["b"] = "1011",
	["c"] = "1100",
	["d"] = "1101",
	["e"] = "1110",
	["f"] = "1111"
}
local bin2hext = flipkv(hex2bint)
function hex2bin(s)
	return string.gsub(s:gsub(" ",""),"(.)", function(i)
		return hex2bint[1]
	end)
end
function dec2hexOLD(str,devider)
	return (string.gsub(str,"(.)",function (c)
		return string.format("%X",string.byte(c), devider or " ")
	end))
end
function bin2dec(s)
	local num = 0
	local ex = string.len(s) - 1
	local l = 0
	l = ex + 1
	for i = 1, l do
		b = string.sub(s, i, i)
		if b == "1" then
			num = num + 2^ex
		end
		ex = ex - 1
	end
	return string.format("%u", num)
end
function dec2bin(dec)
	local result = ""
	repeat
		local divres = dec / 2
		local int, frac = math.modf(divres)
		dec = int
		result = math.ceil(frac) .. result
	until dec == 0
	return result
end
function hex2dec(s)
	return tonumber(s:gsub(" ",""), 16)
end
function dec2hex(dec)
	dec = tonumber(dec)
	local result = ""
	local base16 = {"A","B","C","D","E","F"}
	repeat
		local remainder = dec % 16
		if remainder >= 10 then
			remainder = base16[remainder - 9]
		end
		result = remainder .. result
		dec = math.modf(dec / 16)
	until dec == 0
	return result
end
function searchTable(t,val)
	for k,v in pairs(t) do
		if v == val then
			return true,k
		end
	end
	return false
end
function string.split(s, p)
    local temp = {}
    local index = 0
    local last_index = string.len(s)
    while true do
        local i, e = string.find(s, p, index)
        if i and e then
            local next_index = e + 1
            local word_bound = i - 1
            table.insert(temp, string.sub(s, index, word_bound))
            index = next_index
        else
            if index > 0 and index <= last_index then
                table.insert(temp, string.sub(s, index, last_index))
            elseif index == 0 then
                temp = nil
            end
            break
        end
    end
    return temp
end
function splitBySentence(text)
	return string.split(text:gsub("\n",""):gsub("\r",""),"[^%.!?]*")
end
