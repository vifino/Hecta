--Simple module
--AI code
local escaped_nickname = escape_lua_pattern(nickname)
local replies = {"Hello","Hi","Ohia","Hey"}
local postfixes = {"!","..."," :D"}
local function think(text, user)
    local r = ""
    print(text)
    if text:match(escaped_nickname) ~= nil then
        seed()
        if text:match(escaped_nickname) ~= nil then
            local r = replies[math.random(#replies)] ..", "..nick
            if math.random(0,3) == 0 then
                r = r..postfixes[math.random(#postfixes)]
            end
            return r
        end
    end
    return ""
end
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