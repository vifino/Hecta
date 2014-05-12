--AI code
local escaped_nickname = escape_lua_pattern(nickname)
local replies = {"Hello","Hi","Ohia","Hey"}
local postfixes = {"!","..."," :D"}
local function think(text, user, channel)
    print(text)
    if text:match(escaped_nickname) == nickname then
        ---[[
		print("Nick matched")
        if text:lower():match("hello") == "hello" then
            print("Hello found")
            seed()
            local r = replies[math.random(#replies)] ..", "..user
            if math.random(3) == 1 then
                r = r..postfixes[math.random(#postfixes)]
            end
            return r
        end
		--]]
		--return http.request("86.165.120.243:27076/" .. text:gsub("^"..escaped_nickname,""):gsub(" ","%%20"))
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
            local reply = think(txt, nick, channel)
            reply = think(txt, nick, channel)
            if reply == "" then
                print("Reply empty")
            else
                print("Sent reply")
                send("PRIVMSG "..channel.." :"..reply)
            end
        end
    end
end
function init(text,nick,channel)
    if (isPrivileged(nick)) then
        if enabled == true then
            enabled = false
            return "AI stopped"
        else 
            enabled = true
            return "AI started"
        end
    else
        return no()
    end
end
commands["ai"] = init
loopCalls["ai"] = ai
