--code goes here here :)

videogameflip = {
	{4.500,0,1},
	{5.500,3,1},
	{5.750,0,1},
	{6.500,3,1},
	{7.250,0,1},
	{7.750,3,1},
	{8.500,0,1},
	{9.500,3,1},
	{10.250,0,1},
	{11.500,3,1},
	{12.500,0,1},
	{13.500,3,1},
	{13.750,0,1},
	{14.500,3,1},
	{15.250,0,1},
	{15.750,3,1},
	{16.500,0,1},
	{17.500,3,1},
	{18.250,0,1},
	{19.500,3,1},
	{20.500,0,1},
	{21.500,3,1},
	{21.750,0,1},
	{22.500,3,1},
	{23.250,0,1},
	{23.750,3,1},
	{24.500,0,1},
	{25.500,3,1},
	{26.250,0,1},
	{27.500,3,1},
	{28.500,0,1},
	{29.500,3,1},
	{29.750,0,1},
	{30.500,3,1},
	{31.250,0,1},
	{31.750,3,1},
	{32.500,0,1},
	{33.500,3,1},
	{34.250,0,1},
	{35.500,3,1},
	{36.500,0,1},
	{37.500,3,1},
	{37.750,0,1},
	{38.500,3,1},
	{39.250,0,1},
	{39.750,3,1},
	{40.500,0,1},
	{41.500,3,1},
	{42.250,0,1},
	{43.500,3,1},
	{44.500,0,1},
	{45.500,3,1},
	{45.750,0,1},
	{46.500,3,1},
	{47.250,0,1},
	{47.750,3,1},
	{48.500,0,1},
	{49.500,3,1},
	{50.250,0,1},
	{51.500,3,1},
}

videogameflip2 = {
	{41.000,0,1},
	{41.750,3,1},
	{42.500,0,1},
	{43.000,3,1},
	{43.500,0,1},
	{44.000,3,1},
	{49.000,0,1},
	{49.750,3,1},
	{50.500,0,1},
	{50.750,3,1},
	{51.000,0,1},
	{51.250,3,1},
	{51.500,0,1},
	{52.000,3,1},
}

introspin = {
	{52.000,0,1},
	{53.000,3,1},
	{53.750,0,1},
	{54.500,3,1},
	{55.000,0,1},
	{55.500,3,1},
	{56.000,0,1},
	{56.333,3,1},
	{56.667,0,1},
	{57.000,3,1},
	{57.250,0,1},
	{57.500,3,1},
	{57.750,0,1},
	{58.000,3,1},
	{58.167,0,1},
	{58.333,3,1},
	{58.500,0,1},
	{58.667,3,1},
	{58.833,0,1},
	{59.000,3,1},
	{59.125,0,1},
	{59.250,3,1},
	{59.375,0,1},
	{59.500,3,1},
	{59.625,0,1},
	{59.750,3,1},
	{59.875,0,1},
	{60.000,3,1},
}

function swap2(t)
	t[1] = t[1] - (t[2]*0.5)
	return swap(t)
end

local function womp(beat)
	for i = beat,beat+4 do
		kick(i,0.25,1,'Expo','Expo',0,500,'drunkz')
		kick(i,0.25,1,'Expo','Expo',0,100,'drunk')
		kick(i,0.5,2,'Expo','Expo',0,-2000,'tinyz')
		kick(i,0.5,2,'Expo','Expo',0,-100,'cooltiny')
		kick(i,0.5,1,'Expo','Elastic',100,125,'zoomy')
	end
end

----------------- Intro Setup --------------------------------------
AfSetup(itgaf,90)
set{0,-50,'squarezperiod',100,'middle',0,'zoom',10000,'drunkzspeed',10000,'tipsyspeed',10000,'drunkspeed',500,'drunkspacing'}

func {0, function()
	itg:zoom(0)
end}

func_ease {3.5, 1, ExpoS, 0, 1, 'itg:zoom'}
ease2{4,1,ExpoS,100,'zoom'}

local f = 1
for i = 4,51 do
	kick(i,0.25,0.5,'Expo','Expo',0,400*f,'squarez')
	kick(i,0.25,0.5,'Expo','Expo',0,-100,'tiny')
	func_ease {i-0.25, 0.25, ExpoI, 0, 25, 'itg:z'}
	func_ease {i, 0.5, ExpoO, 25, 0, 'itg:z'}
f = f * -1
end

local f = 1
for i=1,table.getn(videogameflip) do
	local beat = videogameflip[i][1]
	local col = videogameflip[i][2]
	
	if col == 0 then
		ease2{beat,0.75,WiggleS,100,'movex1',-100,'movex2'}
	elseif col == 3 then
		ease2{beat,0.75,WiggleS,0,'movex1',0,'movex2'}
	end
	
f = f*-1
end

local f = 1
for i=1,table.getn(videogameflip2) do
	local beat = videogameflip2[i][1]
	local col = videogameflip2[i][2]
	
	if col == 0 then
		ease2{beat,0.75,WiggleS,300,'movex0',-300,'movex3'}
	elseif col == 3 then
		ease2{beat,0.75,WiggleS,0,'movex0',0,'movex3'}
	end
	
f = f*-1
end

local f = 1
for i=1,table.getn(introspin) do
	local beat = introspin[i][1]
	ease{beat,1,flip(ExpoO),-300,'cooltiny'}
	func_ease {beat, 1, ExpoO, 0, -25, 'itg:z2'}
	
f = f*-1
end

womp(36)
womp(44)


ease{36,24,ExpoI,0,'zoom',200,'zoomz',90,'coolrotationx'}
func_ease{36, 24, ExpoI, 1, 0, 'itg:zoom2'}

add{52,6,CubicI,360*3,'coolrotationy'}
add{58,2,linear,360*6,'coolrotationy'}
add{60,4,CubicO,360*3,'coolrotationy'}
set{64,0,'coolrotationy'}



func {60, function()
	itgaf:hidden(1)
end}













---------------------- Fin Setup ---------------------------------
AfSetup(endingaf,90)
finbg:zoomto(sw/1.5,sh/1.5)

ModelSetup(endfish,5)
endfish:y(sh/16)
endfish:rotationx(-25)
endfish:rotationz(-25)

endquad:zoomto(sw,sh)
endquad:diffuse(0,0,0,1)

endtext:zoomto(sw/2,sh/2)
endtext:y(-sh/4)

set{700,100,'hide'}

func {700, function()
	endingaf:hidden(0)
end}

func_ease {701.5, 16, outExpo, 360, 0, 'endingaf:z'}
func_ease {701.5, 16, outExpo, 1, 0, 'endquad:diffusealpha'}

func_ease {717-1, 2, ExpoS, 0, 1, 'endquad:diffusealpha'}