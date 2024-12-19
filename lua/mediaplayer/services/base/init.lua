AddCSLuaFile "shared.lua"
include "shared.lua"

local MaxTitleLength = 128

function SERVICE:SetOwner( ply )
	self._Owner = ply
	self._OwnerName = ply:Nick()
	self._OwnerSteamID = ply:SteamID()
end

function SERVICE:GetMetadata( callback )

	if not self._metadata then
		self._metadata = {
			title 		= "Base service",
			duration 	= -1,
			url 		= "",
			thumbnail 	= ""
		}
	end

	callback(self._metadata)

end

function SERVICE:NetReadRequest()
	-- Read any additional net data here
end
