-- Make Wolfram API Calls
-- Supply APPID via wa.setAppID(id)
-- Made by vifino
print("Initializing Wolfram API")
wa = {}
local version = "v2"
local appid = "XXXX"
http = require("socket.http")
function wa.setVersion(ver)
	version = "v"..ver
end
function wa.setAppID(id)
	appid = id
end
local decode = function(str)
	-- Output tends to have double spaces.
	str = str:gsub('%s+', ' ')
	-- Convert the WA unicode escaping into HTML.
	str = str:gsub('\\:([0-9a-z][0-9a-z][0-9a-z][0-9a-z])', '&#x%1;')
	return (html2unicode(str))
end
local parseXML = function(xml)
	local results = {}
	for args, pod in xml:gmatch('<pod([^>]+)>(.-)</pod>') do
		local title = args:match("title='([^']+)'")
		local id = args:match("id='Input'")
		if(not id) then
			local sub = {}
			for args, subpod in pod:gmatch('<subpod([^>]+)>(.-)</subpod>') do
				local plain = subpod:match('<plaintext>(.-)</plaintext>')
				if(plain and #plain > 0) then
					table.insert(sub, decode(plain))
				end
			end

			if(#sub > 0) then
				table.insert(results, string.format('\002%s\002: %s', decode(title), table.concat(sub, '; ')))
			end
		end
	end

	return results
end
function wa.query(str)
	local data, err = http.request("http://api.wolframalpha.com/"..version.."/query?format=plaintext&input=".. url.escape(str).."&appid=" .. appid)
	local results = parseXML(data)
	return results
end