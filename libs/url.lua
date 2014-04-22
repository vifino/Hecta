-- URL API
-- Made by vifino
url = {}
function url.escape( s )
	return string.gsub( s, "([^A-Za-z0-9_])", function( c )
		return string.format( "%%%02x", string.byte( c ) )
	end )
end
function url.unescape( s )
    return string.gsub( s, "%%(%x%x)", function( hex )
        return string.char( tonumber( hex, 16 ) )
    end )
end