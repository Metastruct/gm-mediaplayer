local MediaPlayerClass = "mediaplayer_tv"

local function AddMediaPlayerModel( spawnName, name, model, playerConfig )
	list.Set( "SpawnableEntities", spawnName, {
		PrintName = name,
		ClassName = MediaPlayerClass,
		Category = "Media Player",
		DropToFloor = true,
		KeyValues = {
			model = model
		}
	} )

	list.Set( "MediaPlayerModelConfigs", model, playerConfig )
end

AddMediaPlayerModel(
	"../spawnicons/models/hunter/plates/plate2x3",
	"Billboard",
	"models/hunter/plates/plate2x3.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-238*0.4*.5, 380*0.375*.5, 2.5),
		width = 380*0.375,
		height = 238*0.4
	}
)

AddMediaPlayerModel(
	"../spawnicons/models/hunter/plates/plate5x8",
	"Huge Billboard",
	"models/hunter/plates/plate5x8.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-118.8, 189.8, 2.5),
		width = 380,
		height = 238
	}
)

AddMediaPlayerModel(
	"../spawnicons/models/props_phx/rt_screen",
	"Small TV",
	"models/props_phx/rt_screen.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(6.5, 27.9, 35.3),
		width = 56,
		height = 33
	}
)

if SERVER then

	-- fix for media player owner not getting set on alternate model spawn
	hook.Add( "PlayerSpawnedSENT", "MediaPlayer.SetOwner", function(ply, ent)
		if not ent.IsMediaPlayerEntity then return end
		ent:SetCreator(ply)
		local mp = ent:GetMediaPlayer()
		if mp then
			mp:SetOwner(ply)
		end
	end )

end


AddMediaPlayerModel(
	"../spawnicons/models/props_lab/citizenradio",
	"Billboard",
	"models/props_lab/citizenradio.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-7,12,17.3),
		width = 27.2*0.85,
		height = 15.3*0.85
	}
)

AddMediaPlayerModel(
	"../spawnicons/models/props_lab/citizenradio",
	"Radio",
	"models/props_lab/citizenradio.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-7,12,17.3),
		width = 27.2*0.85,
		height = 15.3*0.85
	}
)
AddMediaPlayerModel(
	"../spawnicons/models/props_lab/huladoll",
	"Big",
	"models/props_lab/huladoll.mdl",
	{
		angle = Angle(0, 0, 90),
		offset = Vector(-1366*.5,5,768),
		width = 1366,
		height = 768
	}
)

AddMediaPlayerModel(
	"../spawnicons/models/props_lab/huladoll",
	"Big",
	"models/props_lab/huladoll.mdl",
	{
		angle = Angle(0, 0, 90),
		offset = Vector(-1366*.5,5,768),
		width = 1366,
		height = 768
	}
)

AddMediaPlayerModel(
	"../spawnicons/models/props_junk/popcan01a",
	"Smallish",
	"models/props_junk/popcan01a.mdl",
	{
		angle = Angle(0, 0, 90),
		offset = Vector(-227.56*.5,5,128),
		width = 227.56,
		height = 128
	}
)


-- FROM: https://steamcommunity.com/sharedfiles/filedetails/?id=2546524440

-- I have no idea if half this stuff matters, nor if I'm missing something critical.
local MediaPlayerClass = "mediaplayer_tv"
DEFINE_BASECLASS( "mediaplayer_base" )
local function AddMediaPlayerModel( name, model, confug)
	if util.IsValidModel(model) then
		local spawnName = "../spawnicons/" .. model:sub(1, #model - 4)
		list.Set( "SpawnableEntities", spawnName, {
			PrintName = name,
			ClassName = MediaPlayerClass,
			Category = "Media Player",
			Type = "anim",
			Base = "mediaplayer_base",
			Author 	= "Physics Dude",
			Spawnable = true,
			Instructions = "Right click on the TV to see available Media Player options. Alternatively, press E on the TV to turn it on.",
			DropToFloor = true,
			KeyValues = {
				model = model
			}
		} )
		list.Set( "MediaPlayerModelConfigs", model, confug )
	end
end

--[[TV-esque models from Garry's Mod "Bulder" props]]--
AddMediaPlayerModel(
	"Plate TV (05x075)",
	"models/hunter/plates/plate05x075.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-12.11, 23.98, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 36.09,
		height = 24.22
	}
)
AddMediaPlayerModel(
	"Plate TV (075x1)",
	"models/hunter/plates/plate075x1.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-23.98, 23.97, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 47.95,
		height = 36.09
	}
)
AddMediaPlayerModel(
	"Plate TV (1x2)",
	"models/hunter/plates/plate1x2.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-23.98, 47.7, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 95.4,
		height = 47.95
	}
)
AddMediaPlayerModel(
	"Plate TV (2x3)",
	"models/hunter/plates/plate2x3.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-47.7, 71.42, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 142.85,
		height = 95.4
	}
)
AddMediaPlayerModel(
	"Plate TV (2x4)",
	"models/hunter/plates/plate2x4.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-47.7, 95.15, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 190.3,
		height = 95.4
	}
)
AddMediaPlayerModel(
	"Plate TV (3x4)",
	"models/hunter/plates/plate3x4.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-71.43, 95.15, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 190.3,
		height = 142.85
	}
)
AddMediaPlayerModel(
	"Plate TV (3x5)",
	"models/hunter/plates/plate3x5.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-71.43, 118.87, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 237.75,
		height = 142.85
	}
)
AddMediaPlayerModel(
	"Plate TV (4x7)",
	"models/hunter/plates/plate4x7.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-95.15, 166.32, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 332.65,
		height = 190.3
	}
)
AddMediaPlayerModel(
	"Plate TV (4x8)",
	"models/hunter/plates/plate4x8.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-95.15, 190.05, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 380.1,
		height = 190.3
	}
)
--[[
-- default mediaplayer dont overwrite!!!
AddMediaPlayerModel(
	"Plate TV (5x8)",
	"models/hunter/plates/plate5x8.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-118.8, 189.8, 2.5),
		width = 380,
		height = 238
	}
)
]]--
AddMediaPlayerModel(
	"Plate TV (8x16)",
	"models/hunter/plates/plate8x16.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-190.05, 379.85, 2.5), -- Forward/Back | Left/Right | Up/Down 
		width = 759.7,
		height = 380.1
	}
)
AddMediaPlayerModel(
	"Plate XL (16x24)",
	"models/hunter/plates/plate16x24.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-379.85, 569.65, 3), -- Forward/Back | Left/Right | Up/Down 
		width = 1139.3,
		height = 769.7
	}
)
AddMediaPlayerModel(
	"Plate XL (24x32)",
	"models/hunter/plates/plate24x32.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-569.95, 759.45, 3), -- Forward/Back | Left/Right | Up/Down 
		width = 1518.9,
		height = 1139.3
	}
)
--[[
-- Useless builder prop sizes
AddMediaPlayerModel(
	"Plate TV (025x025)",
	"models/hunter/plates/plate025x025.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-6.18, 6.18, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 12.36,
		height = 12.36
	}
)
AddMediaPlayerModel(
	"Plate TV (025x05)",
	"models/hunter/plates/plate025x05.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-6.18, 12.11, 1.75),-- Forward/Back | Left/Right | Up/Down 
		width = 24.22,
		height = 12.36
	}
)
AddMediaPlayerModel(
	"Plate TV (05x05)",
	"models/hunter/plates/plate05x05.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-12.11, 12.11, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 24.23,
		height = 24.23
	}
)
AddMediaPlayerModel(
	"Plate TV (5x7)",
	"models/hunter/plates/plate5x7.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-118.88, 166.32, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 332.65,
		height = 237.75
	}
)
AddMediaPlayerModel(
	"Plate TV (3x6)",
	"models/hunter/plates/plate3x6.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-71.43, 142.6, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 285.20,
		height = 142.85
	}
)
AddMediaPlayerModel(
	"Plate TV (4x6)",
	"models/hunter/plates/plate4x6.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-95.15, 142.6, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 285.20,
		height = 190.3
	}
)
AddMediaPlayerModel(
	"Plate TV (2x2)",
	"models/hunter/plates/plate2x2.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-47.7, 47.7, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 95.4,
		height = 95.4
	}
)
AddMediaPlayerModel(
	"Plate TV (1x1)",
	"models/hunter/plates/plate1x1.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-23.98, 23.98, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 47.95,
		height = 47.95
	}
)
AddMediaPlayerModel(
	"Plate TV (6x8)",
	"models/hunter/plates/plate6x8.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-142.6, 190.05, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 380.10,
		height = 285.20
	}
)]]--

--[[TV-esque models from Garry's Mod and Mounted Source Games]]--
AddMediaPlayerModel(
	"(Gmod) TV Standard",
	"models/props_c17/tv_monitor01.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(7.28-1.75, 11.21-1.75, 8.28-2.25),-- Forward/Back | Left/Right | Up/Down 
		width = 15,
		height = 11
	}
)
AddMediaPlayerModel( --some other source game
	"(Gmod) TV Large",
	"models/props_debris/tv_monitor01.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(10.76-0.3, 17.60-4, 12.87-4),-- Forward/Back | Left/Right | Up/Down 
		width = 22,
		height = 17
	}
)
AddMediaPlayerModel(
	"(Gmod) Citizen Radio",
	"models/props_lab/citizenradio.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(9.41-0.9, 14.28-8.25, 17.36-1.75),-- Forward/Back | Left/Right | Up/Down 
		width = 17.5,
		height = 4
	}
)
AddMediaPlayerModel(
	"(Gmod) CRT Monitor",
	"models/props_lab/monitor01a.mdl",
	{
		angle = Angle(-86, 90, 0),
		offset = Vector(13.69-1.88,11.78-2.3,13.62-2.3),-- Forward/Back | Left/Right | Up/Down 
		width = 19,
		height = 15.3
	}
)
AddMediaPlayerModel(
	"(Gmod) CRT Monitor 2",
	"models/props_lab/monitor02.mdl",
	{
		angle = Angle(-82, 90, 0),
		offset = Vector(10.1,11.78-2.3,24.8-2.2),-- Forward/Back | Left/Right | Up/Down 
		width = 19,
		height = 15
	}
)
AddMediaPlayerModel(
	"(Gmod) Mini TV",
	"models/props_lab/monitor01b.mdl",
	{
		angle = Angle(-89, 90, 0),
		offset = Vector(6.86-0.6,7.45-2,6.8-1.85),-- Forward/Back | Left/Right | Up/Down 
		width = 9,
		height = 9
	}
)
AddMediaPlayerModel( 
	"(Gmod) PC Monitor TV",
	"models/props_interiors/computer_monitor.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(3.3,13-2.5,27-2.2),-- Forward/Back | Left/Right | Up/Down 
		width = 21,
		height = 16
	}
)
AddMediaPlayerModel( --other
	"(Gmod) Microwave",
	"models/props/cs_office/microwave.mdl",
	{
		angle = Angle(0, 180, 90),
		offset = Vector(16-2.4,-11+0.5,17-3),-- Forward/Back | Left/Right | Up/Down 
		width = 18,
		height = 11	
	}
)
AddMediaPlayerModel( --other
	"(GMod) TV Console",
	"models/props/cs_militia/tv_console.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(21.5,43-17,48-4),-- Forward/Back | Left/Right | Up/Down 
		width = 52,
		height = 36
	}
)
AddMediaPlayerModel( --gmod
	"(GMod) PC Monitor",
	"models/props_office/computer_monitor_01.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(3.4,14.11-2.5,25.50-2.5),-- Forward/Back | Left/Right | Up/Down 
		width = 23,
		height = 17
	}
)

--[[TV-esque models from "Wiremod"]]--
AddMediaPlayerModel( --wiremod
	"(Wire) 4:3 TV",
	"models/blacknecro/tv_plasma_4_3.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(0.13,30.10-2,25.5-4),-- Forward/Back | Left/Right | Up/Down 
		width = 56,
		height = 43
	}
)
AddMediaPlayerModel( --wiremod
	"(Wire) Monitor Big",
	"models/kobilica/wiremonitorbig.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(0.13,13.5-2,26.43-2),-- Forward/Back | Left/Right | Up/Down 
		width = 23,
		height = 23
	}
)
AddMediaPlayerModel( --wiremod
	"(Wire) Monitor Small",
	"models/kobilica/wiremonitorsmall.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(0.13,5.25-0.75,10.26-0.75),-- Forward/Back | Left/Right | Up/Down 
		width = 9,
		height = 9
	}
)
--[[TV-esque models from "[Final] Steventechno's Electronics Pack!"]]--
AddMediaPlayerModel( --stevventechno
	"(Steventechno) Monitor",
	"models/computerpack/monitor.mdl",
	{		
		angle = Angle(-90, 90, 0),
		offset = Vector(-7.2,16.42-1,20.63-0.9),-- Forward/Back | Left/Right | Up/Down 
		width = 31,
		height = 16
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV 2a",
	"models/electronicspack/bigscreen.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(-9.55,40.25-2.75,46.38-2.3),-- Forward/Back | Left/Right | Up/Down 
		width = 78.7,
		height = 39
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV 2b",
	"models/electronicspack/bigscreennomount.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(-9.55,40.25-2.75,46.38-2.3),-- Forward/Back | Left/Right | Up/Down 
		width = 78.7,
		height = 39
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV",
	"models/electronicspack/general_electronics/tv/crt/0_1tvlarge1.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(-0.1,46.33-3,78.59-3),-- Forward/Back | Left/Right | Up/Down 
		width = 87,
		height = 44
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV 3a",
	"models/electronicspack/general_electronics/tv/lcd/1_0tvlarge1.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(-12,47.61-2.7,55.01-2.7),-- Forward/Back | Left/Right | Up/Down 
		width = 90,
		height = 40
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV 3b",
	"models/electronicspack/general_electronics/tv/lcd/1_1tvlarge1_nomnt.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(-0.5,47.61-2.5,46.6-1.3),-- Forward/Back | Left/Right | Up/Down 
		width = 90,
		height = 40
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV 4a",
	"models/electronicspack/general_electronics/tv/lcd/1_2tvlarge2.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(-16.5,72.18-2.6,81.85-2.6),-- Forward/Back | Left/Right | Up/Down 
		width = 139,
		height = 66
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV 4b",
	"models/electronicspack/general_electronics/tv/lcd/1_3tvlarge2_nomnt.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(-0.2,72.18-2.6,73.85-2.6),-- Forward/Back | Left/Right | Up/Down 
		width = 139,
		height = 66
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV 1a",
	"models/electronicspack/general_electronics/tv/lcd/1_4tv_small.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(-8,25-2,33-1),-- Forward/Back | Left/Right | Up/Down 
		width = 47,
		height = 25
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) TV 1b",
	"models/electronicspack/general_electronics/tv/lcd/1_5tv_small_nomnt.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(0,25-1.5,27-0.9),-- Forward/Back | Left/Right | Up/Down 
		width = 47,
		height = 25
	}
)
AddMediaPlayerModel( --stevventechno
	"(Steventechno) Laptop",
	"models/laptop/laptop.mdl",
	{
		angle = Angle(-75, 90, 0),
		offset = Vector(-9.6,10-1,15-0.9),-- Forward/Back | Left/Right | Up/Down 
		width = 19,
		height = 12
	}
)

--[[TV-esque models from "RolePlay Props Extended"]]--
AddMediaPlayerModel( --other
	"(RP) Macbook",
	"models/testmodels/macbook_pro.mdl",
	{
		angle = Angle(-76.5, 90, 0),
		offset = Vector(-10.6,13-0.1,18-0.3),-- Forward/Back | Left/Right | Up/Down 
		width = 26,
		height = 17
	}
)

AddMediaPlayerModel( --other
	"(RP) iMac",
	"models/testmodels/apple_display.mdl",
	{
		angle = Angle(-85, 90, 0),
		offset = Vector(1,21-0.25,25-1),-- Forward/Back | Left/Right | Up/Down 
		width = 41,
		height = 23
	}
)

AddMediaPlayerModel( --other
	"(RP) Suite TV",
	"models/gmod_tower/suitetv.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(1,28-2,37-2),-- Forward/Back | Left/Right | Up/Down 
		width = 52,
		height = 28
	}
)

AddMediaPlayerModel( --other
	"(RP) Plasma TV",
	"models/u4lab/tv_monitor_plasma.mdl",
	{
		angle = Angle(-90, 90, 0),
		offset = Vector(5,59-14,67-5),-- Forward/Back | Left/Right | Up/Down 
		width = 90,
		height = 58
	}
)

--[[TV-esque models from "SProps"]]--
AddMediaPlayerModel( --sprops
	"[SProps] Micro 6x6",
	"models/sprops/rectangles/size_1_5/rect_6x6x3.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-3, 3, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 6,
		height = 6
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] Mini 6x12",
	"models/sprops/rectangles/size_1_5/rect_6x12x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(6, 3, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 12,
		height = 6
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] Small 12x18",
	"models/sprops/rectangles/size_2/rect_12x18x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(9, 6, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 18,
		height = 12
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] Small 24x36",
	"models/sprops/rectangles/size_3/rect_24x36x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(18, 12, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 36,
		height = 24
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] Small 36x60",
	"models/sprops/rectangles/size_4/rect_36x60x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(30, 18, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 60,
		height = 36
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] Small 60x96",
	"models/sprops/rectangles/size_60/rect_60x96x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(48, 30, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 96,
		height = 60
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] Small 96x144",
	"models/sprops/rectangles/size_6/rect_96x144x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(72, 48, 1.75), -- Forward/Back | Left/Right | Up/Down 
		width = 144,
		height = 96
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] XL 144x240",
	"models/sprops/rectangles/size_7/rect_144x240x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(120, 72, 2), -- Forward/Back | Left/Right | Up/Down 
		width = 240,
		height = 144
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] XL 192x288",
	"models/sprops/rectangles/size_8/rect_192x288x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(144, 96, 2), -- Forward/Back | Left/Right | Up/Down 
		width = 288,
		height = 192
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] XL 240x384",
	"models/sprops/rectangles/size_9/rect_240x384x3.mdl",
	{
		angle = Angle(0, 180, 0),
		offset = Vector(192, 120, 2), -- Forward/Back | Left/Right | Up/Down 
		width = 384,
		height = 240
	}
)
AddMediaPlayerModel( --sprops
	"[SProps] XL 480x288",
	"models/sprops/rectangles/size_10/rect_480x288x3.mdl",
	{
		angle = Angle(0, 90, 0),
		offset = Vector(-144, 240, 2), -- Forward/Back | Left/Right | Up/Down 
		width = 480,
		height = 288
	}
)
