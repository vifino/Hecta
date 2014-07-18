-- Gizoogle! Fo Shizzles!
-- Made by vifino
gizoogle = {}
function gizoogle.translate(text)
	local s=http.request("http://www.gizoogle.net/textilizer.php","translatetext="..text)
	return s:match("<textarea type=\"text\" name=\"translatetext\" style=\"width: 600px; height:250px;\"/>(.-)</textarea>"
end
commands["gizoogle"] = gizoogle.translate