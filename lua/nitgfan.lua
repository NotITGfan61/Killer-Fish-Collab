--code goes here here :)
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