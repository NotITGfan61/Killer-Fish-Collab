if not P1 or not P2 then
	backToSongWheel('Two Player Mode Required')
	return
end

function RealFov(fov)
	return 360 / math.pi * math.atan(math.tan(math.pi * fov / 360) * DISPLAY:GetDisplayWidth() / DISPLAY:GetDisplayHeight() * 0.75)
end

-- judgment / combo proxies
for pn = 1, 2 do
	setupJudgeProxy(PJ[pn], P[pn]:GetChild('Judgment'), pn)
	setupJudgeProxy(PC[pn], P[pn]:GetChild('Combo'), pn)
end
-- player proxies
for pn = 1, #PP do
	PP[pn]:SetTarget(P[pn])
	P[pn]:hidden(1)
	P[pn]:SetFarDist(100000)
end

do
	local renderdistancefront = THEME:GetMetric('Player', 'StopDrawingAtPixels')
	aux 'drawsizepixels'
	node {'drawsizepixels', 'drawsize', function(p, d)
		return (p / renderdistancefront - 1) * 100 + d
	end, 'drawsize'}
	local renderdistanceback = THEME:GetMetric('Player', 'StartDrawingAtPixels')
	aux 'drawsizebackpixels'
	node {'drawsizepbackixels', 'drawsizeback', function(p, d)
		return (p / renderdistanceback - 1) * 100 + d
	end, 'drawsizeback'}
end
definemod {'fov', function(fov, pn)
	local adjustedfov = 360 / math.pi * math.atan(math.tan(math.pi * fov / 360) * SCREEN_WIDTH / SCREEN_HEIGHT * 0.75)
	P[pn]:fov(adjustedfov)
	P[pn]'Judgment':fov(adjustedfov)
	P[pn]'Combo':fov(adjustedfov)
end}




setdefault {2, 'xmod', 410, 'drawsizepixels', -114, 'drawsizebackpixels', 90, 'fov', 100, 'dizzyholds', 100, 'stealthpastreceptors', 100, 'zbuffer', 100, 'modtimer', 100,'cover'}

--[[easelist
SineS, CubicS, QuintS, CircS, ElasticS, QuadS, QuartS, ExpoS, BackS, BounceS,SmoothS
SineO, CubicO, QuintO, CircO, ElasticO, QuadO, QuartO, ExpoO, BackO, BounceO,SmoothO
SineI, CubicI, QuintI, CircI, ElasticI, QuadI, QuartI, ExpoI, BackI, BounceI,SmoothI
]]

require('nitgfan')
require('plastic')

--------------------------------------------------------------------------------------------BG AND SHADER STUFF GOES HERE--------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------DEFINEMOD STUFF GOES HERE----------------------------------------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------------FUNCTION STUFF GOES HERE-----------------------------------------------------------------------------------------------------------------------

reset{60}


--------------------------------------------------------------------------------------------------SETUP ENDS HERE----------------------------------------------------------------------------------------------------------------------------
