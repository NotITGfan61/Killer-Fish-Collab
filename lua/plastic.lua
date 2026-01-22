--code goes here here :)
--??. Batman 1
	for pn = 1, 2 do
		ease{64-1.5, 3, inOutCubic, scx*(2*pn-3), 'x', plr = pn}
	end

	func{64+1.5, function()
		for pn = 1, 2 do
			PP[pn]:hidden(1)
		end
	end, persist=true}
	set{64+1.5, 0, 'x'}
	
	--batman panel aft setups
	apanel.frame:xy(scx, scy)
	apanel.frame:fov(RealFov(45))
	apanel.frame:hidden(1)
	
	bpanel.frame:xy(scx, scy)
	bpanel.frame:fov(RealFov(45))
	bpanel.frame:hidden(1)
	
	apanel.bg:xywh(0, 0, sw, sh)
	apanel.bg:diffuse(1, 0, 0, 1)
	bpanel.bg:xywh(0, 0, sw, sh)
	bpanel.bg:diffuse(0, 0, 1, 1)
	
	PP_BA:SetTarget(P[1]:GetChild('NoteField'))
	PP_BB:SetTarget(P[2]:GetChild('NoteField'))
	
	for i = 1, #apanel.aft do
		apanel.aft[i]:hidden(1)
		bpanel.aft[i]:hidden(1)
	end
	
	for i = 1, #batman.nozbuf do
		batman.nozbuf[i]:xywh(scx, scy, sw, sh)
		batman.nozbuf[i]:diffusealpha(0)
		batman.nozbuf[i]:clearzbuffer(1)
	end
	
	--polygon texture functions
	local function npot(val)
		local out = 2
		while out < val do
			out = out*2
		end
		return out
	end
	
	local function polytex(xpos, ypos)
		tc_x = (scx + xpos)*(dw/sw)/npot(dw)
		tc_y = (scy - ypos)*(dh/sh)/npot(dh)
		
		return tc_x, tc_y
	end
	
	--batman panel setup
	batman.bg:xywh(scx, scy, sw, sh)
	batman.bg:diffuse(0, 0, 0, 1)
	batman.bg:clearzbuffer(1)
	batman.bg:hidden(1)
	
	batman.frame:xy(scx, scy)
	batman.frame:hidden(1)
	
	local panel_wd = 600
	local panel_ht = 240
	
	for i = 1, #batman.panel do
		batman.panelbg[i]:SetNumVertices(4)
		batman.panelbg[i]:SetPolygonMode(0)
		batman.panelbg[i]:SetDrawMode('quads')
		
		batman.panelbg[i]:xy( panel_wd/4*(2*i-3), 0)
		batman.panelbg[i]:zoom(0.95)
	
		batman.panel[i]:SetNumVertices(4)
		batman.panel[i]:SetPolygonMode(0)
		batman.panel[i]:SetDrawMode('quads')
		
		batman.panel[i]:xy( panel_wd/4*(2*i-3), 0)
		batman.panel[i]:zoom(0.95)
	end
	
	local v_apanel = {
		{-panel_wd/4, -panel_ht/2},
		{          0,           0},
		{          0,           0},
		{-panel_wd/4,  panel_ht/2}
	}
	
	local v_bpanel = {
		{ panel_wd/4, -panel_ht/2},
		{          0,           0},
		{          0,           0},
		{ panel_wd/4,  panel_ht/2}
	}
	
	definemod{'comicscroll', 'comicalpha', function(yp, alp)
		batman.frame:y(scy - yp)
		batman_ypos = yp
		batman_alpha = alp/100
	end}
	
	local panelalphatbl = {0, 0, 0, 0, 0, 0}
	definemod{'panelalpha1a', 'panelalpha1b', 'panelalpha2a', 'panelalpha2b', 'panelalpha3a', 'panelalpha3b',
		function(a1a, a1b, a2a, a2b, a3a, a3b)
		
		panelalphatbl[1] = a1a/100
		panelalphatbl[2] = a1b/100
		
		panelalphatbl[3] = a2a/100
		panelalphatbl[4] = a2b/100
		
		panelalphatbl[5] = a3a/100
		panelalphatbl[6] = a3b/100
	end}
	
	local function modulo(a, b)
		return a - math.floor(a/b)*b;
	end
		
	local function randomXD(t)
		if t == 0 then return 0.5 else
		return modulo(math.sin(t * 3229.3) * 43758.5453, 1) end
	end
	
	local function draw_panels()
		batman.bg:Draw()
	
		local nS = 1 + math.floor( batman_ypos/panel_ht )
		local nE = nS + 2
	
		for i = nS, nE do
			local dir = 1-2*(i%2)
		
			local panel_off1 = 64*randomXD(688*i)
			local panel_off2 = 64*randomXD(564*i)
			
			v_apanel[2] = { panel_wd/4+panel_off1*dir, -panel_ht/2}
			v_apanel[3] = { panel_wd/4-panel_off2*dir,  panel_ht/2}
			
			v_bpanel[2] = {-panel_wd/4+panel_off1*dir, -panel_ht/2}
			v_bpanel[3] = {-panel_wd/4-panel_off2*dir,  panel_ht/2}
			
			for v = 0, 3 do
				local vx_a, vy_a = v_apanel[v+1][1], v_apanel[v+1][2]
				local vx_b, vy_b = v_bpanel[v+1][1], v_bpanel[v+1][2]
				
				local tx_a, ty_a = polytex(vx_a, vy_a)
				local tx_b, ty_b = polytex(vx_b, vy_b)
				
				batman.panelbg[1]:SetVertexPosition(v, vx_a, vy_a, 0)
				batman.panelbg[2]:SetVertexPosition(v, vx_b, vy_b, 0)
				
				batman.panel[1]:SetVertexPosition(v, vx_a, vy_a, 0)
				batman.panel[1]:SetVertexTexCoord(v, tx_a, ty_a, 0)
				batman.panel[2]:SetVertexPosition(v, vx_b, vy_b, 0)
				batman.panel[2]:SetVertexTexCoord(v, tx_b, ty_b, 0)
			end
			
			batman.panel[1]:SetTexture(apanel.aft[ (i-1)%3+1 ]:GetTexture())
			batman.panel[2]:SetTexture(bpanel.aft[ (i-1)%3+1 ]:GetTexture())
			
			for n = 1, 2 do
				batman.panelbg[n]:y(-120 + panel_ht*(i-1))
				batman.panelbg[n]:diffusealpha(batman_alpha)
				batman.panelbg[n]:Draw()
				
				batman.panel[n]:y(-120 + panel_ht*(i-1))
				batman.panel[n]:diffusealpha( panelalphatbl[ 2*((i-1)%3)+n ] )  
				batman.panel[n]:Draw()
			end
		end
	end
	
	batman.frame:SetDrawFunction(draw_panels)
	
	func{64, function()
		apanel.frame:hidden(0)
		bpanel.frame:hidden(0)
		
		batman.bg:hidden(0)
		batman.frame:hidden(0)
	end, persist=true}
	
	function InLinOut(b, inInfo, l_lin, outInfo, amt, mod, pn)
		local n_i, l_i =  inInfo[1],  inInfo[2]
		local n_o, l_o = outInfo[1], outInfo[2]
		
		local coef_in, coef_out = l_i/l_lin/n_i, l_o/l_lin/n_o
		
		local amt_lin = amt / (coef_in + 1 + coef_out)
		local amt_in, amt_out = amt_lin*coef_in, amt_lin*coef_out
			
		if n_i == 2 then
			add{b          , l_i,  inQuad, amt_in , mod, plr = pn}
		elseif n_i == 3 then
			add{b          , l_i,  inCubic, amt_in , mod, plr = pn}
		elseif n_i == 4 then
			add{b          , l_i,  inQuart, amt_in , mod, plr = pn}
		end
		
		add{b+l_i, l_lin, linear, amt_lin, mod, plr = pn}
			
		if n_o == 2 then
			add{b+l_i+l_lin, l_o, outQuad, amt_out, mod, plr = pn}
		elseif n_o == 3 then
			add{b+l_i+l_lin, l_o, outCubic, amt_out, mod, plr = pn}
		elseif n_o == 4 then
			add{b+l_i+l_lin, l_o, outQuart, amt_out, mod, plr = pn}
		end
	end
	
	--scrolling down
	for i = 80, 120, 8 do
		add{i-3, 6, inOutCubic, panel_ht, 'comicscroll', plr = 1}
	end
	
	--panel alphas
	ease{64-2, 4, inOutCubic, 100, 'comicalpha', plr = 1}
	
	for i = 68, 128, 8 do
		local np = 1 + ( (i-68)/8 )%3
	
		func{i-2, function() apanel.aft[np]:hidden(0) end, persist=true}
		ease{i-2, 4, inOutCubic, 100, 'panelalpha'..np..'a', plr = 1}
		
		func{i+2, function() bpanel.aft[np]:hidden(0) end, persist=true}
		ease{i+2, 4, inOutCubic, 100, 'panelalpha'..np..'b', plr = 1}
		
		func{i+4, function() apanel.aft[np]:hidden(1) end, persist=true}
		func{i+8, function() bpanel.aft[np]:hidden(1) end, persist=true}
		
		if i < 116 then
			set{i+12+2, 0, 'panelalpha'..np..'a', 0, 'panelalpha'..np..'b', plr = 1}
		end
	end
	
	--batman placeholder mods for check
	set{66, 50, 'mini', 64, 'y'}
	
	ease{66, 66, linear,  360*4, 'coolrotationy', plr = 1}
	ease{66, 66, linear, -360*4, 'coolrotationy', plr = 2}
	
	--RESET
	func{132, function()
		for pn = 1, 2 do
			PP[pn]:hidden(0)
		end
		
		apanel.frame:hidden(1)
		bpanel.frame:hidden(1)
		
		batman.bg:hidden(1)
		batman.frame:hidden(1)
	end, persist=true}

	reset{132}

	drop3fade.aft:hidden(1)
	drop3fade.sprite:hidden(1)
	
	drop3scroll.aft:hidden(1)
	drop3scroll.sprite:hidden(1)
	
	drop3glitch.aft:hidden(1)
	drop3glitch.sprite:hidden(1)

--??. Drop 2???
	--ActorProxies for this section
	drop2.ppframe:xy(scx, scy)
	drop2.ppframe:fov(RealFov(90))
	drop2.ppframe:SetFarDist(9E9)
	drop2.ppframe:zbuffer(1)
	drop2.ppframe:hidden(1)
	
	for pn = 1, 2 do
		PP_D2[pn]:SetTarget(P[pn]:GetChild('NoteField'))
	end

	--trying out the transition
	ease{272, 4, inExpo, 25, 'aboverotx', plr = 1}
	ease{274, 2, inExpo, -400, 'aboveypos', plr = 1}

	set{272, 0.75, 'oceanspdy', plr = 1}

	--phase 2 in underwater!!
	func{276, function()
		under.frame:hidden(0)
		under.aft:hidden(0)
		under.aftsp:hidden(0)
		
		itgfish.frame:hidden(0)
		modelzoom(itgfish.model, 8)
		itgfish.frame:z(-128)
		
		for pn = 1, 2 do
			PP[pn]:hidden(1)
		end
		drop2.ppframe:hidden(0)
		
	end, persist=true}
	set{276, 2,'itgfishamp', 60,'itgfishperiod', 1,'itgfishspeed', plr = 1}
	
	set{276, 2, 'waterheight', 25, 'waterrotx', plr = 1}
	
	add{276, 64, linear, -100, 'waterposz', plr = 1}
	ease{276, 4, outCubic, 7, 'waterheight', 0, 'waterrotx', plr = 1}
	
	reset{276, exclude={'waterheight', 'waterposz', 'waterrotx'}}
	
	--fish spellcard attack
	func{277, function()
		casting.frame:hidden(0)
	end, persist=true}
	
	--castSound(570)
	castSound(277)
	
	set{277, 40, 'spellcirczoom', plr = 1}
	
	ease{277, 6, inOutSine, 360, 'spellcircrotz', plr = 1}
	
	ease{277, 1, inOutCubic, 100, 'spellcircalpha', plr = 1}
	ease{282, 1, inOutCubic,   0, 'spellcircalpha', plr = 1}

	func{283, function()
		casting.frame:hidden(1)
	end, persist=true}
	
	--drop 2 mods
	set{276, 3, 'xmod', 50, 'flip', 90, 'coolrotationx', 200, 'zoomz', 100, 'wave', 60, 'brake', 100, 'orient'}
	set{276, 50, 'drawsize', 100, 'sudden',  200, 'suddenoffset', -10, 'shrinklinear', -10, 'shrinklinearz'}
	for c = 0, 3 do
		set{276, 1000, 'bumpyxperiod'..c, 1000, 'bumpyzperiod'..c}
	end
	set{276, 0, 'tornadoperiod', 0, 'tornadozperiod', 100, 'dark', 100, 'hidenoteflashes'}
	
	definemod{'d2circsize', 'd2circoffset', function(sz, off)
		d2_circsize = sz/64 * 100
		d2_circoff = off * math.pi/180
	end}
	
	set{276, 160, 'd2circsize', plr = 1}
	
	perframe{276, 20, function(beat, poptions)
		for pn = 1, 2 do
			poptions[pn].tornado  = 25 * math.cos( 2*math.pi * ( ( 4*(pn-1)+ 1.5 )/8 + ((beat-276)/8) ) + d2_circoff )
			poptions[pn].tornadoz = 25 * math.sin( 2*math.pi * ( ( 4*(pn-1)+ 1.5 )/8 + ((beat-276)/8) ) + d2_circoff )
		
			for c = 0, 3 do
				local ang = 2*math.pi * ( ( 4*(pn-1)+c )/8 + ((beat-276)/8) ) + d2_circoff
			
				poptions[pn]['movex'..c] = d2_circsize * math.cos( ang )
				poptions[pn]['movez'..c] = d2_circsize * math.sin( ang )
				
				poptions[pn]['bumpyx'..c] = -225 * math.cos( ang )
				poptions[pn]['bumpyz'..c] = -225 * math.sin( ang )
			end
		end
	end}
	
	func{296, function()
		for pn = 1, 2 do
			PP_D2[pn]:hidden(1)
		end
	end, persist=true}
	
	func{308, function()
		for pn = 1, 2 do
			PP_D2[pn]:hidden(0)
		end
	end, persist=true}
	
	set{308, 0, 'd2circoffset', plr = 1}
	perframe{308, 16, function(beat, poptions)
		for pn = 1, 2 do
			poptions[pn].tornado  = -25 * math.cos( 2*math.pi * ( ( 4*(pn-1)+ 1.5 )/8 - ((beat-308)/8) ) + d2_circoff )
			poptions[pn].tornadoz = -25 * math.sin( 2*math.pi * ( ( 4*(pn-1)+ 1.5 )/8 - ((beat-308)/8) ) + d2_circoff )
		
			for c = 0, 3 do
				local ang = 2*math.pi * ( ( 4*(pn-1)+c )/8 - ((beat-308)/8) ) + d2_circoff
			
				poptions[pn]['movex'..c] = d2_circsize * math.cos( ang )
				poptions[pn]['movez'..c] = d2_circsize * math.sin( ang )
				
				poptions[pn]['bumpyx'..c] = -225 * math.cos( ang )
				poptions[pn]['bumpyz'..c] = -225 * math.sin( ang )
			end
		end
	end}
	
	--arpeggiooooooooooooo
	set{276, 200, 'arrowpathgirth'}
	
	ease{277, 1, inOutCubic, 25, 'arrowpath'}
	ease{278, 1, inOutCubic,  0, 'arrowpath'}
	
	local fluct = 1
	for i = 280, 292, 1/6 do
		ease{i, 1/6, flip(outSine), 25, 'stealth'}		
		add{i, 0, instant, 360/32, 'd2circoffset', plr = 1}
		
		local c = math.floor( ((i-280)*6)%4 )
		ease{i, 2/3, flip(outCubic), 50, 'arrowpath'..c}
	end
	
	local fluct = 1
	for i = 312, 324, 1/6 do
		ease{i, 1/6, flip(outSine), 25, 'stealth'}		
		add{i, 0, instant, -360/32, 'd2circoffset', plr = 1}
		
		local c = math.floor( ((324-i)*6)%4 )
		ease{i, 2/3, flip(outCubic), 50, 'arrowpath'..c}
	end
	
	--accents
	set{276, -50, 'bumpyzperiod'}
	
	for i = 280, 292, 2 do
		ease{i, 1, flip(outCubic), -200, 'tiny', -200, 'tinyz'}
		if i % 4 > 1 then
			ease{i, 1, flip(outCubic), 50, 'bumpyz'}
		end
	end
	
	for i = 312, 324, 2 do
		ease{i, 1, flip(outCubic), -200, 'tiny', -200, 'tinyz'}
		
		if i % 4 > 1 then
			ease{i, 1, flip(outCubic), 50, 'bumpyz'}
		end
	end
	
	--hide everything that's not roll
	for pn = 1, 2 do
		P[pn]:SetHiddenRegions( { { 292.5, 308 } } )
	end
	
	--Playfield coming from sides
	for pn = 3, 4 do
		P[pn]:SetAwake(true)
		P[pn]:SetInputPlayer(pn-3)
	end
	
	for pn = 1, 2 do
		PP_D2plus[pn]:SetTarget(P[pn+2]:GetChild('NoteField'))
		PP_D2plus[pn]:hidden(1)
	end
	
	func{288, function()
		for pn = 1, 2 do
			PP_D2plus[pn]:z(-256)
			PP_D2plus[pn]:hidden(0)
		end
	end, persist=true}
	
	func{310, function()
		for pn = 1, 2 do
			PP_D2plus[pn]:hidden(1)
		end
	end, persist=true}
	
	definemod{'drop2orbitrad', 'drop2orbitangle', function(rd, ag, pn)
		local xp = rd * math.cos(ag * math.pi/180)
		local zp = rd * math.sin(ag * math.pi/180)
		
		return xp, zp
	end, 'x', 'z'}
	
	set{272, 3*scx, 'drop2orbitrad', plr = {3,4}}
	
	ease{288, 4, inOutCubic,   256, 'drop2orbitrad', plr = {3,4}}
	ease{306, 4, inOutCubic, 3*scx, 'drop2orbitrad', plr = {3,4}}
	
	set{272,  180, 'drop2orbitangle', plr = 3}
	set{272,    0, 'drop2orbitangle', plr = 4}
	
	InLinOut(288, {2, 2}, 14, {2, 2}, 180, 'drop2orbitangle', {3,4})
	
	for pn = 3, 4 do
		ease{288, 2,  inCubic, -100, 'tinyx', 50*(2*pn-7), 'skewx', plr = pn}
		ease{290, 2, outCubic,    0, 'tinyx', 0, 'skewx', plr = pn}
		
		ease{306, 2,  inCubic, -100, 'tinyx', 50*(7-2*pn), 'skewx', plr = pn}
		ease{308, 2, outCubic,    0, 'tinyx', 0, 'skewx', plr = pn}
		
	end
	
	local fluct = 1
	for i = 292, 306, 2 do
		ease{i, 1, flip(outCubic), -150, 'tiny', -150, 'tinyz', plr = {3,4}}
		
		if i % 4 > 1 then
			ease{i, 2, flip(outCubic), 200*fluct, 'tipsy', -628*fluct, 'confusionzoffset', plr = {3,4}}
			add{i, 2, outCubic, 45, 'drop2orbitangle', plr = {3,4}}
			
			set{i, 50, 'stealth', plr = {3,4}}
			ease{i, 1, outCubic, 40*(1+fluct), 'stealth', 50*(1+fluct), 'invert', plr = 3}
			ease{i, 1, outCubic, 40*(1-fluct), 'stealth', 50*(1-fluct), 'invert', plr = 4}
			
			for c = 0, 3 do
				local amt = -157/2
				local dir = 1-2*(math.floor( (c+1)/2 )%2)
				
				ease{i, 1, outCubic, amt*dir*(1+fluct), 'confusionzoffset'..c, plr = 3}
				ease{i, 1, outCubic, amt*dir*(1-fluct), 'confusionzoffset'..c, plr = 4}
			end
			
			fluct = fluct * -1
		end
	end
	
	for i = 304, 305.5, 0.75 do
		ease{i, 0.75, flip(outCubic), -150, 'boost', plr = {3,4}}
	end
	
	--last mods part
	perframe{324, 16, function(beat, poptions)
		for pn = 1, 2 do
			poptions[pn].tornado  = -25 * math.cos( 2*math.pi * ( ( 4*(pn-1)+ 1.5 )/8 - ((324-308)/8) ) + d2_circoff )
			poptions[pn].tornadoz = -25 * math.sin( 2*math.pi * ( ( 4*(pn-1)+ 1.5 )/8 - ((324-308)/8) ) + d2_circoff )
		
			for c = 0, 3 do
				local ang = 2*math.pi * ( ( 4*(pn-1)+c )/8 - ((324-308)/8) ) + d2_circoff
			
				poptions[pn]['movex'..c] = d2_circsize * math.cos( ang )
				poptions[pn]['movez'..c] = d2_circsize * math.sin( ang )
				
				poptions[pn]['bumpyx'..c] = -225 * math.cos( ang )
				poptions[pn]['bumpyz'..c] = -225 * math.sin( ang )
			end
		end
	end}
	
	local fluct = 1
	for i = 325.5, 333.5, 4 do
		add{i    , 1, outCubic, 90 * fluct, 'd2circoffset', plr = 1}
		add{i+1.5, 1, outCubic, 90 * fluct, 'd2circoffset', plr = 1}
		
		set{i, 50, 'stealth'}
		ease{i, 1, outCubic,  0, 'stealth',   0, 'confusionzoffset', plr = 1}
		ease{i, 1, outCubic, 80, 'stealth', 314, 'confusionzoffset', plr = 2}
		
		set{i+1.5, 50, 'stealth'}
		ease{i+1.5, 1, outCubic, 80, 'stealth', 314, 'confusionzoffset', plr = 1}
		ease{i+1.5, 1, outCubic,  0, 'stealth',   0, 'confusionzoffset', plr = 2}
		
		ease{i    , 1, flip(outCubic),  50, 'bumpyz'}
		ease{i+1.5, 1, flip(outCubic), -50, 'bumpyz'}
		
		fluct = fluct * -1
	end
	
	local d2lastnd = P[1]:GetNoteData(324, 335.75)
	for i, v in ipairs(d2lastnd) do
		ease{v[1], 0.5, flip(outCubic), -250, 'tiny', -250, 'tinyz', 25, 'arrowpath'}
	end
	
	--resetting stuffs for nitgfan
	func{340, function()
		under.frame:hidden(1)
		under.aft:hidden(1)
		under.aftsp:hidden(1)
		
		itgfish.frame:hidden(1)
		modelzoom(itgfish.model, 0)
		itgfish.frame:z(0)
		
		drop2.ppframe:hidden(1)
	end, persist=true}
	
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
	
	PP_D4plus:SetTarget(P[3]:GetChild('NoteField'))
	
	definemod{'drop4rotz', function(rz)
		drop4.ppframe:rotationz(rz)
	end}
	
	--happens at underwater??
	func{568, function()
		under.frame:hidden(0)
		under.aft:hidden(0)
		under.aftsp:hidden(0)
		
		itgfish.frame:hidden(0)
		modelzoom(itgfish.model, 8)
		itgfish.frame:z(-128)

		for pn = 1, 2 do
			PP[pn]:hidden(1)
		end
		drop4.ppframe:hidden(0)
	end, persist=true}
	set{568, 2,'itgfishamp', 60,'itgfishperiod', 1,'itgfishspeed', plr = 1}
	
	func{632, function()
		under.frame:hidden(1)
		under.aft:hidden(1)
		under.aftsp:hidden(1)
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
		P[pn]:SetXSpline(0, -1,-500*amt, -100, -1)	
		P[pn]:SetXSpline(1, -1,       0,  100, -1)
		P[pn]:SetXSpline(2, -1, -20*amt,  400, -1)
		
		P[pn]:SetRotZSpline(0, -1, -100*amt,-100, -1)
		P[pn]:SetRotZSpline(1, -1,   20*amt, 200, -1)
		P[pn]:SetRotZSpline(2, -1,        0, 400, -1)
		
		P[pn]:SetZSpline(0, -1, 3000*amt, -500, -1)
		P[pn]:SetZSpline(1, -1,        0,  500, -1)
	end
	
	set{568, 30, 'flip', 100, 'wave', -512, 'z', 3, 'xmod', 100, 'sudden', 400, 'suddenoffset', 100, 'drawsize', 50, 'movey'}
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
		
		itgfish.model:x( -96*sinBeat*amt )
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
		
		itgfish.model:x( -96*sinBeat*amt )
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
		
		for c = 0, 3 do
			ease{i, 2, flip(outCubic), 400, 'bumpyx'..c, 400, 'bumpyz'..c, plr = 3}
		end
		
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
	
	func_ease{624, 8, inCubic, -128, 64, 'itgfish.frame:z', plr = 1}
	
	--hiding stuffs
	func{632, function()
		drop4.ppframe:hidden(1)
		itgfish.frame:hidden(1)
		modelzoom(itgfish.model, 0)
		itgfish.frame:z(0)
		
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