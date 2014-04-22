-- Answers to common situations
-- Made by vifino
function no()
	math.randomseed(os.time())
	math.random()
	math.random()
	local nou = {"No.", "Nou", "Nope!","nope.avi","http://not.inUrDreamz.com","Noo!","Nu.","Nu","No way.","Try better next time.", "lelno","Nupe!"}
	return nou[math.random(1,#nou)]
end
function yes()
	math.randomseed(os.time())
	math.random()
	math.random()
	local yes = {"Yes","Definitly","Sure","Yes!","Yup.","Yeah!"}
	return yes[math.random(1,#yes)]
end
function maybe()
	math.randomseed(os.time())
	math.random()
	math.random()
	local maybe = {"Maybe...","Depends...","May, under certain Situations."}
	return maybe[math.random(1,#maybe)]
end
function theAnswer()
	math.randomseed(os.time())
	math.random()
	math.random()
	local answers = {"42.", "Forty Two.","Forty 2.","40 + 2"}
	return answers[math.random(1,#answers)]
end