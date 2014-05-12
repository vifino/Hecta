commands["drama"] = function(user,chan,txt)
	local dat,err=http.request("http://asie.pl/drama.php?plain")
	return dat or "Error "..err
end