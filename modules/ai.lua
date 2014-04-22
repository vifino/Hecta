-- WIP Useless AI
-- Made by vifino
aiStorage = {}
aiStorage["wordtypes"] = {}
aiStorage["attacks"] = {"smacks","smacked","wrecked","wrecks","reks","rek","shoot","shoots","kicks","kicked","slaps","slaped","swats","bitchslaps","bitchslaped","roundhouses","whacks","whacked"}
aiStorage["users"] = {}
local aiInstances = {}
local saidCurrent = ""
local saidLast = ""
local mineLast = ""
local function stripchars( str, chr )
    local s = ""
    for g in str:gmatch( "[^"..chr.."]" ) do
 	s = s .. g
    end
    return s
end
local function aiBasic(text)
    if text:lower():match("cats") then
        print("Caaaaats!")
        return "I <3 Cats!"
    end
end
function aialize(text)
    local typetext = ""
    for i,v in pairs(aiStorage["wordtypes"]) do
        if i == text then
           typetext = v
        end
    end
    return typetext
end
local function ai(inputRaw)
    local typemsg,user,channelmsg,txt=getMsgType(line)
    if typemsg ~= "msg" then return nil end
    local inputTable = splitToTable(txt, "%S+")
    local inputAnalized = {}
    local response = ""
    saidCurrent = inputRaw
    for i,v in pairs(inputTable) do
        if v == "is" then
            print("Is statement!")
            -- learn the new item
            local object,content = stripchars(txt,"?!."):match("(.*) is (.*)")
            if object and content then
                aiStorage["wordtypes"][object] = content
            end
            break
        elseif v == "What" then
            local object = stripchars(txt,"?!."):match("What is (.*)")
            if object then
                if aiStorage["wordtypes"][object] then
                    return object.." is "..aiStorage["wordtypes"][object]
                else
                    return "I dunno what "..object.." is. Sorry!"
                end
                elseif stripchars(txt,"?!."):match("What are (.*)") then
                local object = stripchars(txt,"?!."):match("What are (.*)")
                if aiStorage["wordtypes"][object] then
                    return object.." is "..aiStorage["wordtypes"][object]
                else
                    return "I dunno what "..object.." is. Sorry!"
                end
            end
        elseif inTableVal(aiStorage["attacks"],v) and inTableVal(inputTable,username) then
            action(channelmsg, slap(user))
            return nil
        end
    end
    if not specialCase then
        for i,v in pairs(inputTable) do
            table.insert(inputAnalized,aialize(v))
        end
    end
    -- Logix here plz
    saidLast = inputRaw
    mineLast = response
    return response
end
function aiWatcher(line)
    local typemsg,user,channelmsg,txt=getMsgType(line)
    if not txt then return nil end
    if not txt:match("^"..commandPrefix.."(.*)") then
        for i,v in pairs(aiInstances) do
            if i == channelmsg then
                local aiAnswer = v(line)
                if aiAnswer ~= nil then
                    send("PRIVMSG "..channelmsg.." :"..aiAnswer)
                end
            else
                return nil
            end
        end
    end
end
local function aiSpawner(channel)
    if not aiInstances[channel] then
        aiInstances[channel] = ai
        aiStorage["users"][channel] = userList(channel)
        return "AI Started!"
    else
        return "Error: AI already started"
    end
end
local function aiTerminator(channel)
    aiInstances[channel] = nil
end
function aiInit(text,nick,channel)
    local inputTable = splitToTable(text, "%S+")
    if inputTable[1] == nil then
        return "Error: Please specify action."
    elseif inputTable[1] == "start" then
        if inputTable[2] == nil then
            return "Please specify a channel"
        else
            return aiSpawner(inputTable[2])
        end
    elseif inputTable[1] == "stop" then
        aiTerminator(inputTable[2])
        return "AI stopped."
    else
        return "Error: Please specify an Action."
    end    
end
commands["ai"] = aiInit
loopCalls["aiWatcher"] = aiWatcher 