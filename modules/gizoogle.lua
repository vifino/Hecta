-- Gizoogle! Fo Shizzles!
-- Made by vifino
http = require"socket.http"
ltn12 = require"ltn12"
gizoogle = {}
function gizoogle.textilize(text)
	local s=http.request("http://www.gizoogle.net/textilizer.php","translatetext="..text)
	return s:match("<textarea type=\"text\" name=\"translatetext\" style=\"width: 600px; height:250px;\"/>(.-)</textarea>")
end
function gizoogle.textilize2(text)
	if text then
		local reqbody = "translatetext="..tostring(text)
		local respbody = {} -- for the response body
		local result, respcode, respheaders, respstatus = http.request {
			method = "POST",
			url = "http://www.gizoogle.net/textilizer.php",
			source = ltn12.source.string(reqbody),
			headers = {
				["content-type"] = "text/plain",
				["content-length"] = tostring(#reqbody)
			},
			sink = ltn12.sink.table(respbody)
		}
		-- get body as string by concatenating table filled by sink
		respbody = table.concat(respbody)
		return respbody
	else
		return nil
	end
end
commands["gizoogle"] = gizoogle.textilize