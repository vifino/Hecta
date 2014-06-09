-- Youtube API
-- Made by vifino
youtube = {}
socket = require("socket")
http = require("socket.http")
function youtube.title(vidid)
	local youtubedataurl = "https://gdata.youtube.com/feeds/api/videos/"..vidid.."?alt=json"
	local data,err=http.request(youtubedataurl)
	if data and data:match('"title":{"$t":"(.+)","type":"text"') then
		local title = data:match(',"title":{"$t":"(.*)","type":"text"},"content":{')
		return title
	end
end