function w00t()
	return "W00T! UMAD BRO?!?" 
end
commands["woot"] = w00t
commands["w00t"] = w00t
function l33tify(text)
	local loweredText = string.lower(text)
	local l33tWord = loweredText:gsub("is","iz"):gsub("at","@"):gsub("am","m"):gsub("hacker","H@XX0R"):gsub("leet","L33T"):gsub("noob","N00B"):gsub("nn","nN"):gsub("me","M3h"):gsub("pro","PR0"):gsub("cash","$$$"):gsub("got","9OT"):gsub("ass","@$$"):gsub("you","Y0"):gsub("to","2"):gsub("are","Rx")
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