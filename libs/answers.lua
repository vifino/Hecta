-- Answers to common situations
-- Made by vifino
function no()
	seed()
	if math.random(2) == 0 then
		local nou = {"Nou", "Nope!","nope.avi","not.inUrDreamz.com","Noo!","Nu.","Nu","No way.", "lolno", nickname.." says no!"}
		return nou[math.random(1,#nou)]
	else
		return "No."
	end
end

function yes()
	--Yes doesn't require a chance for the original
	--As all the elements are used equally in chat
	seed()
	local yes = {"Yes","Definitly","Sure","Yes!","Yup.","Yeah!",nickname.." says yes!"}
	return yes[math.random(1,#yes)]
end

function maybe()
	seed()
	if math.random(3) == 0 then
		local maybe = {"Depends...","May, under certain situations.", "Perhaps", "May or may not"}
		return maybe[math.random(1,#maybe)]
	else
		return "Maybe..."
	end
end

function theAnswer()
	seed()
	if math.random(4) == 0 then
		--Variations, including randomised mathematics
		local d = math.random(5,100);
		local a = math.random(12,40);
		local answers = {"Forty Two.","Forty 2.","40 + 2",a.." + "..42-a, 42*d.." ÷ "..d}
		return answers[math.random(1,#answers)]
	else 
		--Original
		return "42."
	end
end
