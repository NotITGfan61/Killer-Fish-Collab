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

--conamera (above)
above.frame:xy(scx, scy)
above.frame:fov(RealFov(45))
above.frame:SetFarDist(9E9)
above.frame:zbuffer(1)
above.frame:hidden(1)
	
local sky_size = 4096*20
tex_sky:hidden(1)
	
above.sky:y(768)
above.sky:rotationy(90)
above.sky:zoom( sky_size/640 ):zoomz( sky_size/640 )
above.sky:cullmode('front')
above.sky:SetTexture(0, tex_sky:GetTexture())
	
above.ocean:xy(0, 768)
above.ocean:SetWidth(sky_size*2)
above.ocean:SetHeight(sky_size*2)
above.ocean:rotationx(90)
above.ocean:customtexturerect(0, 0, 24, 24)
	
above.oceanlight:xy(0, 768)
above.oceanlight:z(-sky_size)
above.oceanlight:SetWidth(sky_size)
above.oceanlight:SetHeight(1600)
above.oceanlight:diffuse(0.95, 0.95, 0.95, 1)
above.oceanlight:fadetop(0.4)
above.oceanlight:fadebottom(0.5)
above.oceanlight:clearzbuffer(1)

-----------for testing purposes --------------
func{212, function()
	above.frame:hidden(0)
end, persist=true}
	
func{276, function()
	above.frame:hidden(1)
end, persist=true}
-----------------------------------------------
	
--conamera (underwater)
under.frame:xy(scx,scy)
under.frame:hidden(1)
	
under.water:zoomto(sw,-sh)
under.rays:xy(0, 0)
under.rays:zoomto(sw, sh)

----------------------------------------------------------------------------------------------DEFINEMOD STUFF GOES HERE----------------------------------------------------------------------------------------------------------------------

--underwater bg definemods
definemod {'waterfov', 'waterheight', function(fov, ht)
	under.water:GetShader():uniform1f('fov', fov)
	under.water:GetShader():uniform1f('waterheight', ht)
end}
setdefault{45, 'waterfov', 7, 'waterheight'}
	
definemod {'waterrotx', 'waterroty', 'waterrotz', function(rx, ry, rz)
	under.water:GetShader():uniform1f('rotx', rx)
    under.water:GetShader():uniform1f('roty', ry)
	under.water:GetShader():uniform1f('rotz', rz)
end}
	
definemod{'waterposx', 'waterposy', 'waterposz', function(xp, yp, zp)
	under.water:GetShader():uniform1f('positionx', xp)
	under.water:GetShader():uniform1f('positiony', yp)
	under.water:GetShader():uniform1f('positionz', zp)
end}

definemod {'sunraypos', function(b)
    under.rays:GetShader():uniform1f('sunraypos', b)
end}
setdefault{80, 'sunraypos'}

----------------------------------------------------------------------------------------------FUNCTION STUFF GOES HERE-----------------------------------------------------------------------------------------------------------------------

reset{60}

reset{632} -- Reset after Drop 4 (PlasticRainbow)

--------------------------------------------------------------------------------------------------SETUP ENDS HERE----------------------------------------------------------------------------------------------------------------------------
