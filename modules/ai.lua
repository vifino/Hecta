--AI code
local escaped_nickname = escape_lua_pattern(nickname)
local replies = {"Hello","Hi","Ohia","Hey"}
local postfixes = {"!","..."," :D"}
local function think(text, user)
    send("PRIVMSG "..channel.." :1 "..text)
    send("PRIVMSG "..channel.." :2 "..escaped_nickname)
    send("PRIVMSG "..channel.." :3 "..text:match(escaped_nickname))
    send("PRIVMSG "..channel.." :4 "..text:lower():match("hello"))
    if text:match(escaped_nickname) ~= nil then
        seed()
        if text:lower():match("hello") ~= nil then
            local r = replies[math.random(#replies)] ..", "..user
            if math.random(3) == 1 then
                r = r..postfixes[math.random(#postfixes)]
            end
            return r
        end
    end
    return ""
end

--Simple module

enabled = false
function ai(line)
    if enabled then --Enabled
        local typemsg,nick,channel,txt=getMsgType(line)
        if not typemsg == "msg" then return nil end
        if not txt then return nil end --Has content
        if not txt:match("^"..commandPrefix.."(.*)") then --Not a command
            local reply = ""
            reply = think(txt, nick)
            if not reply == "" then
                send("PRIVMSG "..channel.." :"..reply)
            end
        end
    end
end
function init(text,nick,channel)
    if enabled == true then
        enabled = false
        return "AI stopped"
    else 
        enabled = true
        return "AI started"
    end
end
commands["ai"] = init
loopCalls["ai"] = ai
