--code goes here here :)

--0. BG Stuffs
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
	--above.ocean:hidden(1)
	
	above.oceanlight:xy(0, 768)
	above.oceanlight:z(-sky_size)
	above.oceanlight:SetWidth(sky_size)
	above.oceanlight:SetHeight(1600)
	above.oceanlight:diffuse(0.95, 0.95, 0.95, 1)
	above.oceanlight:fadetop(0.4)
	above.oceanlight:fadebottom(0.5)
	above.oceanlight:clearzbuffer(1)
	
	
	func{212, function()
		above.frame:hidden(0)
	end, persist=true}
	
	--conamera (underwater)
	under.frame:xy(scx,scy)
	under.frame:hidden(1)
	
	under.water:zoomto(sw,-sh)
	
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
	
	under.rays:xy(0, 0)
	under.rays:zoomto(sw, sh)
	
	definemod {'sunraypos', function(b)
        under.rays:GetShader():uniform1f('sunraypos', b)
    end}
	setdefault{80, 'sunraypos'}
	--[[
	func{212, function()
		under.frame:hidden(0)
	end, persist=true}
	--]]