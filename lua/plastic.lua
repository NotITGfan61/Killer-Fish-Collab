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
	
	P[3]:SetAwake(true)
	PP_D4plus:SetTarget(P[3]:GetChild('NoteField'))
	
	definemod{'drop4rotz', function(rz)
		drop4.ppframe:rotationz(rz)
	end}
	
	--happens at underwater??
	func{568, function()
		under.frame:hidden(0)
		
		itgfishaf:hidden(0)
		modelzoom(itgfish, 8)
		itgfishaf:z(-128)

		for pn = 1, 2 do
			PP[pn]:hidden(1)
		end
		drop4.ppframe:hidden(0)
	end, persist=true}
	set{568, 2,'itgfishamp', 60,'itgfishperiod', 1,'itgfishspeed', plr = 1}
	
	func{632, function()
		under.frame:hidden(1)
	end, persist=true}
	
	--player hidden stuffs
	for i = 572, 592, 4 do
		local pn = 2 - ((i-572)/4)%2
		
		P[pn]:SetHiddenRegions( { {i, i+4} } )
	end
	
	for i = 604, 620, 4 do
		local pn = 2 - ((i-572)/4)%2
		
		P[pn]:SetHiddenRegions( { {i, i+4} } )
	end
	
	--janky holds needs to DIE 
	for pn = 1, 2 do
		P[pn]:SetHiddenRegions( { {597, 603}, {624, 632} } )
	end
	
	--you take care of those holds
	P[3]:SetHiddenRegions( { {572, 596}, {604, 624} } )
	
	--awesomefish arrow attack spell
	func{568, function()
		casting.frame:hidden(0)
		casting.frame:z(-128)
	end, persist=true}
	
	--fish spellcard attack
	castSound(570)
	
	set{570, 40, 'spellcirczoom', plr = 1}
	
	ease{570, 6, inOutSine, 360, 'spellcircrotz', plr = 1}
	
	ease{570, 1, inOutCubic, 100, 'spellcircalpha', plr = 1}
	ease{575, 1, inOutCubic,   0, 'spellcircalpha', plr = 1}
	
	func{576, function()
		casting.frame:hidden(1)
	end, persist=true}
	
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
	
	--holds mods
	set{568, 3, 'xmod', 100, 'spiralholds', 50, 'flip', 90, 'coolrotationx', 250, 'zoomz', 100, 'sudden', 200, 'suddenoffset', 100, 'drawsize', plr = 3}
	for col = 0, 3 do
		local boompi = 900
		local oz, ox = (3-col) * (boompi/4), (boompi*3/4) + (3-col) * (boompi/4)
			
		set{568, 200, 'bumpyx'..col, 200, 'bumpyz'..col, plr = 3}
		set{568, boompi-100, 'bumpyxperiod'..col, boompi-100, 'bumpyzperiod'..col, plr = 3}
		set{568, ox, 'bumpyxoffset'..col, oz, 'bumpyzoffset'..col, plr = 3}
	end
	ease{568, 4+64, linear, 360*2, 'coolrotationy', plr = 3}
	
	--camera movements
	add{568, 64, linear, -150, 'waterposz', plr = 1}
	
	perframe{572, 24, function(beat, poptions)
		local sinBeat = math.sin( 2*math.pi/8 * (beat-572) )
		local amt = 1
		if beat < 588 then
			amt = linear( (beat-572)/16 )
		elseif beat > 592 then
			amt = 1 - linear( (beat-592)/4 )
		end
	
		poptions[1]['waterrotz'] = 30*sinBeat*amt
		poptions[1]['drop4rotz'] = 30*sinBeat*amt
		poptions[1]['itgfishrotz'] = 30*sinBeat*amt
		
		itgfish:x( -96*sinBeat*amt )
	end}
	
	add{596-2, 4, inOutCubic, 360, 'waterrotz', plr = 1}
	
	perframe{604, 24, function(beat, poptions)
		local sinBeat = math.sin( 2*math.pi/8 * (beat-604) )
		local amt = 1
		if beat < 612 then
			amt = linear( (beat-604)/8 )
		elseif beat > 620 then
			amt = 1 - outCubic( (beat-620)/8 )
		end
	
		poptions[1]['waterrotz'] = 360 + 45*sinBeat*amt
		poptions[1]['drop4rotz'] = 45*sinBeat*amt
		poptions[1]['itgfishrotz'] = 45*sinBeat*amt
		
		itgfish:x( -96*sinBeat*amt )
	end}
	
	--accents
	for i = 572, 592, 4 do
		local pn = 1 + ((i-572)/4)%2
		local nd = P[pn]:GetNoteData(i, i+4)
		
		local fluct = 1
		for i, v in ipairs(nd) do
			ease{v[1], 0.25, flip(outCubic), 30*fluct, 'noteskewx', -75, 'tiny', plr = pn}
			
			fluct = fluct * -1
		end
	end
	
	set{587, -99.5, 'spiralxperiod', plr = 1}
	ease{587, 1, flip(outCubic), 50, 'spiralx', plr = 2}
	
	set{598, 1000, 'drunkzspeed', plr = 3}
	
	local fluct = 1
	for i = 598, 602, 2 do
		ease{i, 1, flip(outCubic), 50, 'stealth', 100*fluct, 'drunkz', plr = 3}
		ease{i, 2, flip(outCubic), -100, 'tiny', plr = 3}
		
		ease{i, 2, flip(outCubic), 80, 'itgfishperiod', plr = 1}
		
		fluct = fluct * -1
	end

	for i = 604, 620, 4 do
		local pn = 1 + ((i-604)/4)%2
		local nd = P[pn]:GetNoteData(i, i+4)
		
		local fluct = 1
		for i, v in ipairs(nd) do
			ease{v[1], 0.25, flip(outCubic), 30*fluct, 'noteskewx', -75, 'tiny', plr = pn}
			
			fluct = fluct * -1
		end
	end
	
	for i = 624, 627.5, 0.5 do
		ease{i,  0.5, flip(outCubic), -100, 'tiny', plr = 3}
	end
	
	for i = 628, 631.75, 0.25 do
		ease{i, 0.25, flip(outCubic), -200, 'tiny', plr = 3}
	end
	
	--final transition
	add{624, 8, inCubic, -25, 'waterposz', 1, 'itgfishamp', 0.02, 'itgfishspeed', plr = 1}
	
	func_ease{624, 8, inCubic, -128, 64, 'itgfishaf:z', plr = 1}
	
	--hiding stuffs
	func{632, function()
		drop4.ppframe:hidden(1)
		itgfishaf:hidden(1)
		modelzoom(itgfish, 0)
		itgfishaf:z(0)
		
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