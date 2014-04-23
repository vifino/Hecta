--Simple module

local escaped_nickname = escape_lua_pattern(nickname)
enabled = false
function ai(line)
    if enabled == true then --Enabled
        local typemsg,nick,channel,txt=getMsgType(line)
        if not txt then return nil end --Has content
        if not txt:match("^"..commandPrefix.."(.*)") then --Not a command
            local reply = ""
            reply = Think(txt, nick)
            if not reply == "" then
                send("PRIVMSG "..channel.." :"..reply)
            end
        end
    end
end
function aiInit(text,nick,channel)
    if enabled == true then
        enabled = false
        return "AI stopped"
    else 
        enabled = true
        return "AI started"
    end
end
commands["ai"] = aiInit
loopCalls["aiWatcher"] = ai

--AI code
local replies = {"Hello","Hi","Ohia","Hey"}
local postfixes = {"!","..."," :D"}
local function Think(text, user)
    if not string.find(text,escaped_nickname) == nil then
        seed()
        if not string.find(text,escaped_nickname) == nil then
            local r = replies[math.random(#replies)] ..", "..nick
            if math.random(0,3) == 0 then
                r = r..postfixes[math.random(#postfixes)]
            end
            return r
        end
    end
    return ""
end
