--https://wow.gamepedia.com/API_C_Texture.GetAtlasInfo

C_Texture = {}
local AtlasInfo = {}

function C_Texture.GetAtlasInfo(atlas)
wipe(AtlasInfo)

	for k,v in pairs(ATLAS_INFO_DATA) do
		if v[atlas] then
			AtlasInfo = {
				["width"] = v[atlas][1],
				["height"] = v[atlas][2],
				["leftTexCoord"] = v[atlas][3],
				["rightTexCoord"] = v[atlas][4],
				["topTexCoord"] = v[atlas][5],
				["bottomTexCoord"] = v[atlas][6],
				["tilesHorizontally"] = v[atlas][7],
				["tilesVertically"] = v[atlas][8],
				["file"] = tostring(k),
				["filename"] = tostring(k),
				}
			return AtlasInfo
		end
	end
print("Error: atlas doesn't exist!")
return AtlasInfo
end

function C_Texture.GetAtlasTextCoord(atlas)
	return C_Texture.GetAtlasInfo(atlas).leftTexCoord, C_Texture.GetAtlasInfo(atlas).rightTexCoord, C_Texture.GetAtlasInfo(atlas).topTexCoord, C_Texture.GetAtlasInfo(atlas).bottomTexCoord
end

function SetAtlas(texture, atlas, size)
	if tonumber(size) then
		texture:SetSize(C_Texture.GetAtlasInfo(atlas).width * tonumber(size), C_Texture.GetAtlasInfo(atlas).height * tonumber(size))
	else
		texture:SetSize(C_Texture.GetAtlasInfo(atlas).width, C_Texture.GetAtlasInfo(atlas).height)
	end
	texture:SetTexture(C_Texture.GetAtlasInfo(atlas).filename)
	texture:SetTexCoord(C_Texture.GetAtlasTextCoord(atlas))
end


--https://www.townlong-yak.com/framexml/32494/Helix/AtlasInfo.lua
--https://github.com/Resike/BlizzardInterfaceResources/blob/master/Resources/Data/AtlasInfo.lua

--[[Returns
AtlasInfo
Key	Type	Description
width	number	
height	number	
leftTexCoord	number	
rightTexCoord	number	
topTexCoord	number	
bottomTexCoord	number	
tilesHorizontally	boolean	
tilesVertically	boolean	
file	number?	FileID of parent texture
filename	string?]]

---https://wow.tools/files/#search=&page=1&sort=0&desc=asc