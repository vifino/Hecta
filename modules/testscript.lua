local replies = {"Hello","Hi","Ohia","Hey"}

function testScript(text,nick,channel)
    if text:lower():match("hello") then
        return replies[math.random(#replies)] ..", "..nick
    end
end

commands["test"] = testScript