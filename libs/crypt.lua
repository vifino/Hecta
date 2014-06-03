-- Crypt.lua
-- Made by vifino
function rot13(str, num)
	return (str:gsub(".", function(char)
		local byte = char:byte() + num
		if(byte < 0) then
			byte = 255 + byte
		elseif(byte > 255) then
			byte = byte - 255
		end
		return string.char( byte )
	end))
end
function derot13(str, num)
	return rot13(str, -num)
end