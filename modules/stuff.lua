function w00t()
	return "W00T! UMAD BRO?!?" 
end
commands["woot"] = w00t
commands["w00t"] = w00t
function l33tify(text)
	local loweredText = string.lower(text)
	local l33tWord = loweredText:gsub("is","iz"):gsub("What","W00T"):gsub("porn","Pr0N"):gsub("at","@"):gsub("am","m"):gsub("hacker","H@XX0R"):gsub("leet","L33T"):gsub("noob","N00B"):gsub("nn","nN"):gsub("me","M3h"):gsub("pro","PR0"):gsub("cash","$$$"):gsub("got","9OT"):gsub("ass","@$$"):gsub("you","Y0"):gsub("to","2"):gsub("are","Rx")
	local l33tChar = l33tWord:gsub("e","3"):gsub("t","7"):gsub("e","3"):gsub("t","7"):gsub("l","1"):gsub("a","4"):gsub("o","0"):gsub("f","F"):gsub("y","Y"):gsub("cks","xx"):gsub("ck","x"):gsub("b","8"):gsub("g","9"):gsub("z","2"):gsub("s","$")
	return l33tChar
end
commands["l33t"] = l33tify
commands["leet"] = l33tify
commands["1337"] = l33tify
function aeiou(text)
	return text:gsub("U","A"):gsub("O","U"):gsub("I","O"):gsub("E","I"):gsub("A","E"):gsub("u","a"):gsub("o","u"):gsub("i","o"):gsub("e","i"):gsub("a","e")
end
commands["aeiou"] = aeiou
function sienes(text,nick,channel)
	if not text then text = "" end
	seed()
	return text.."http://sieni.es/"..tostring(math.random(1,240))
end
commands["sienes"] = sienes
function z0r(text,nick,channel)
	seed()
	return text.."http://z0r.de/"..tostring(math.random(0,6050))
end
commands["z0r"] = z0r
function isUp(site)
	local data,code = http.request(site)
	print(code)
	print(type(code))
	if data then
		return true
	else
		return false
	end
end
function isDownCMD(text,nick,channel)
	if text == nil or text =="" then return "Can't check nothing!" end
	local inputTable = splitToTable(text, "%S+")
	local up = isUp(inputTable[1])
	if not up then
		return "Oh noes! Its down!"
	else
		return "Looks fine from here..."
	end
end
commands["isdown"] = isDownCMD
function bestEvah()
	seed()
	local best = {"http://z0r.de/5934","http://sieni.es/34","http://sieni.es/118","http://z0r.de/1882","http://z0r.de/5339","http://z0r.de/4546","http://z0r.de/3042","http://z0r.de/4954","http://z0r.de/4590","http://z0r.de/4682","http://z0r.de/4768","http://z0r.de/4547"}
	return best[math.random(1,#best)]
end
commands["best"] = bestEvah