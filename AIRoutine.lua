AIRoutine = { }

AIRoutine.initDelay = function(init)
	local result = {}
	setmetatable(result,
			{__len = function(array) return #init() end,
			__unm = function(array) return -init() end,
			__index = function(array,value) return init()[value] end,
			__newindex = function(array,key,value) init()[key] = value end,
			__call = function() init()() end,
			__tostring = function(array) return tostring(init()) end,
			__add = function(array,b) return init() + b end,
			__sub = function(array,b) return init() - b end,
			__mul = function(array,b) return init() * b end,
			__div = function(array,b) return init() / b end,
			__mod = function(array,b) return init() % b end,
			__pow = function(array,b) return init() ^ b end,
			__concat = function(array,b) return init() .. b end,
			__eq = function(array,b) return init() == b end,
			__lt = function(array,b) return init() < b end,
			__le = function(array,b) return init() <= b end,
			__next = function(array,b) return next(init(),b) end,
			__ipairs = function(array) return ipairs(init()) end,
			__pairs = function(array) return pairs(init()) end})
	return result
end

AIRoutine.findMatches = function(candidates,match)
	local result = {}
	for i=1,#candidates,1 do if match(candidates[i]) == true then result[#result + 1] = candidates[i] end end
	return result
end

AIRoutine.findMatch = function(candidates,match,better)
	local result = nil
	for i=1,#candidates,1 do 
		if match(candidates[i]) == true and (result == nil or better(result,candidates[i]) == false) then result = candidates[i] end 
	end
	return result
end

AIRoutine.findBest = function(candidates,better)
	local result = candidates[1]
	for i=2,#candidates,1 do if better(result,candidates[i]) == false then result = candidates[i] end end
	return result
end
	
AIRoutine.normalized = function(pos1,pos2)
	local rad = AIRoutine.rad(pos1,pos2)
	return {x = math.sin(rad),z = math.cos(rad)}
end

AIRoutine.rad = function(pos1,pos2)
	if pos2.z > pos1.z then
		if pos1.x < pos2.x then return math.acos(AIRoutine.distance({x=pos1.x,z=pos1.z},{x=pos1.x,z=pos2.z})/AIRoutine.distance(pos1,pos2))
		else return 6.283185307 - math.acos(AIRoutine.distance({x=pos1.x,z=pos1.z},{x=pos1.x,z=pos2.z})/AIRoutine.distance(pos1,pos2)) end
	else 
		if pos1.x < pos2.x then return 1.570796327 + math.acos(AIRoutine.distance({x=pos1.x,z=pos2.z},{x=pos2.x,z=pos2.z})/AIRoutine.distance(pos1,pos2))
		else return 4.712388980 - math.acos(AIRoutine.distance({x=pos1.x,z=pos2.z},{x=pos2.x,z=pos2.z})/AIRoutine.distance(pos1,pos2)) end
	end
end
	
AIRoutine.pos = function(pos,rad,range)
	return {x = pos.x + math.sin(rad) * range, z = pos.z + math.cos(rad) * range}
end
	
AIRoutine.distance = function(pos1,pos2)
	return math.sqrt((pos1.x - pos2.x)^2 + (pos1.z - pos2.z)^2)
end
	
AIRoutine.project = function(linePos1,linePos2,dotPos)
	local dotRad = AIRoutine.rad(linePos1,dotPos)
	local lineRad = AIRoutine.rad(linePos1,linePos2)
	local distance = math.cos(lineRad - dotRad) *  AIRoutine.distance(linePos1,dotPos)
	return AIRoutine.pos(linePos1,lineRad,distance)
end
	
AIRoutine.test = function()
	local array = nil
	array = AIRoutine.initDelay(function() array = {1,2,3,4,5,6,7,8,9,0} return array end)
	if #array ~= 10 then return "AIRoutine.initDelay failed" end
	local norma = AIRoutine.normalized({x=0,z=0},{x=1000,z=0})
	if norma.x > 1.025  or norma.x < 0.975 or norma.z > 0.025 or norma.x < -0.025 then return "AIRoutine.normalized failed" end
	local degree = math.deg(AIRoutine.rad({x=0,z=0},{x=-1333,z=0}))
	if degree < 267.5 or degree > 272.5 then return "AIRoutine.rad failed" end
	local distance = AIRoutine.distance({x=0,z=0,valid = true},{x=1000000,z=0,valid = true})
	if distance < 999999 or distance > 1000001 then return "AIRoutine.distance failed"  end
	local pos = AIRoutine.pos({x=0,z=0},math.rad(180),100)
	if pos.x < -0.025 or pos.x > 0.025 or pos.z < -100.25 or pos.z > -99.75 then return "AIRoutine.pos failed"  end
	local project = AIRoutine.project({x=-1000,z=0},{x = 1000,z = 0}, { x = 0, z = -9999}) 
	if project.x < -0.025 or project.x > 0.025 or project.z < -0.025 or project.z > 0.025 then return "AIRoutine.pos failed"  end
	return "OK"
end

--UPDATEURL=
--HASH=BAD444B833AE44F528CCAD1465C0C32D
