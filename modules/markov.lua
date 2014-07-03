-- Markov Chain functions
-- Made by vifino
markov = {}
markovStorage = {}
markovStartStorage = {}
function markov.learn(input)
	local inputTable = splitToTable(input, "%S+")
	local startPart = inputTable[1].." "..inputTable[2]
	if not searchTable(markovStartStorage) then table.insert(markovStartStorage,startPart) end
	local lastWord,currentWord,currentPart,lastPart,nextWord = ""
	markovStartStorage[#markovStartStorage + 1] = startPart
	for k,v in pairs(inputTable) do --Learning part.
		currentWord = v
		nextWord = inputTable[k+1]
		print("Current Word: "..currentWord)
		print("Last Word: "..lastWord)
		if k > 1 then
			-- Logic here
			currentPart = lastWord.." "..currentWord
			if type(markovStorage[string.lower(currentPart)]) ~= "table" then markovStorage[string.lower(currentPart)] = {} end
			if nextWord and not searchTable(markovStorage[string.lower(currentPart)],nextWord) then table.insert(markovStorage[string.lower(currentPart)], nextWord) end
		end
		lastPart = curentPart
		lastWord = v
	end
end
function markov.generate()
	local start = markovStartStorage[math.random(1,#markovStartStorage)]
	print("Start "..start)
	local startTable = splitToTable(start, "%S+")
	local sentenceDone = false
	local lastPartEnding = startTable[2]
	local lastPart = start
	local output = start
	while not sentenceDone do
		local newPart = markov.nextPart(lastPart)
		print(lastPart)
		print(newPart)
		local newPartTable = splitToTable(newPart, "%S+")
		local lastPartTable = splitToTable(lastPart, "%S+")
		if newPartTable[2] ~= lastPartTable[2] then
			local partTable = splitToTable(newPart, "%S+")
			output = output.." "..newPartTable[2]
			print(output)
			lastPart = newPart
		else
			sentenceDone = true
			return output
		end
	end
end
function markov.nextPart(part)
	local partTable = splitToTable(part, "%S+")
	if type(markovStorage[part]) == "table" then
		if markovStorage[string.lower(part)][1] ~= nil then
			local partnum = math.random(1,#markovStorage[part])
			return partTable[2].." "..markovStorage[string.lower(part)][partnum]
		else
			return part
		end
	else
		return partTable[2]
	end
end
function markov.read(file)
	local content = io.open(file, "r")
	if not content then error("Can't read file!") end
	local contenttxt = content:read("*all")
	contenttable = splitbyLines(contenttxt)
	for k,v in pairs(contenttable) do
		print(v)
		markov.learn(v)
	end
	return "Done."
end
function markovCMD(text,nick,channel)
	local inputTable = splitToTable(text, "%S+")
	if inputTable[1] and not inputTable[2] then
		return "Please write a complete sentence."
	elseif inputTable[1] then
		markov.learn(text)
		return markov.generate()
	else
		return markov.generate()
	end
end
commands["markov"] = markovCMD
markov.learn("Hai, I am "..nickname..", nice to meet you!")
