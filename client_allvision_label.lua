function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end

addEventHandler("onClientRender", root, 
    function ()
        for k,v in ipairs(getElementsByType("player")) do
            if getElementData(v, "ID") ~= getElementData(getLocalPlayer(), "ID") then
                dxDrawTextOnElement(v, getElementData(v, "NAME") .. " [" .. getElementData(v, "ID") .. "]", 1, 20, 0, 0, 255, 255, 2, "sans")
            end
	    end
end)
