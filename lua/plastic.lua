--code goes here here :)
--??. Drop 4 : Arrow Torpedo
	--ActorProxies for this section
	drop4.ppframe:xy(scx, scy)
	drop4.ppframe:fov(RealFov(90))
	drop4.ppframe:SetFarDist(9E9)
	drop4.ppframe:zbuffer(1)
	drop4.ppframe:hidden(1)
	
	for pn = 1, 2 do
		PP_D4[pn]:SetTarget(P[pn]:GetChild('NoteField'))
	end
	
	definemod{'drop4rotz', function(rz)
		drop4.ppframe:rotationz(rz)
	end}
	
	--happens at underwater??
	func{568, function()
		under.frame:hidden(0)
		
		for pn = 1, 2 do
			PP[pn]:hidden(1)
		end
		drop4.ppframe:hidden(0)
	end, persist=true}
	
	add{568, 64, linear, -100, 'waterposz', plr = 1}
	
	func{632, function()
		under.frame:hidden(1)
	end, persist=true}
	
	--player hidden stuffs
	for i = 572, 592, 4 do
		local pn = 2 - ((i-572)/4)%2
		
		P[pn]:SetHiddenRegions( { {i, i+4} } )
	end
	
	for i = 604, 628, 4 do
		local pn = 2 - ((i-572)/4)%2
		
		P[pn]:SetHiddenRegions( { {i, i+4} } )
	end
	
	--torpedo mods??
	function forbiddenspline(pn, amt)
		P[pn]:SetXSpline(0,-1,-500*amt,-100,-1)	
		P[pn]:SetXSpline(1,-1,0,100,-1)
		P[pn]:SetXSpline(2,-1,-20*amt,400,-1)
		P[pn]:SetRotZSpline(0,-1,-100*amt,-100,-1)
		P[pn]:SetRotZSpline(1,-1,20*amt,200,-1)
		P[pn]:SetRotZSpline(2,-1,0,400,-1)
		P[pn]:SetZSpline(0,-1,3000*amt,-500,-1)
		P[pn]:SetZSpline(1,-1,0,500,-1)
	end
	
	set{568, 30, 'flip', 100, 'wave', -512, 'z', 3, 'xmod', 100, 'sudden', 200, 'suddenoffset', 100, 'drawsize', 50, 'movey'}
	set{568, -90, 'rotationz',  157, 'confusionzoffset', plr = 1}
	set{568,  90, 'rotationz', -157, 'confusionzoffset', plr = 2}
	
	func{568, function()
		forbiddenspline(1, 1)
		forbiddenspline(2, 1)
	end, persist=true}
	
	add{568, 28, linear,  360, 'drop4rotz', plr = 1}
	add{568, 28, linear, -628, 'confusionzoffset'}
	
	add{604, 28, linear,  360, 'drop4rotz', plr = 1}
	add{604, 28, linear, -628, 'confusionzoffset'}
	
	--hiding stuffs
	func{632, function()
		drop4.ppframe:hidden(1)
		
		for pn = 1, 2 do
			PP[pn]:hidden(0)
			for c = 0, 3 do
				P[pn]:ResetXSplines(c)
				P[pn]:ResetYSplines(c)
				P[pn]:ResetZSplines(c)
				P[pn]:ResetRotZSplines(c)
			end
		end
	end, persist=true}