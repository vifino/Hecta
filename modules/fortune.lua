-- Very simple module, should be used as a reference or something...
-- Made by vifino and Csstform
local function fortuneOld(text, nick, channel) -- Csstform...
	local say = {
	[1]="Play Minecraft.",
	[2]="Go home, you're drunk.",
	[3]="VIFIIIINOOOOOOO!!!! I'M WATCHING YOU!!!!",
	[4]="WOOF!",
	[5]="Meow!",
	[6]="Don't cry because it's over, smile because it happened.",
	[7]="You only live once, but if you do it right, once is enough.",
	[8]="Behind every great man, there is a woman rolling her eyes.",
	[9]="A day without sunshine is like, you know, night.",
	[10]="Housework can't kill you, but why take the chance?"
	}

	local pick = math.random(1,10)
	print("user "..nick.." got fortune "..pick)

	return say[pick]
end
local function fortune(text,nick,channel)
    return system.cmd("fortune")
end
commands["fortune"] = fortune