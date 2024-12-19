include "shared.lua"

local urllib = url

local htmlBaseUrl = MediaPlayer.GetConfigValue('html.base_url')

DEFINE_BASECLASS( "mp_service_browser" )

local cvSubtitles = CreateClientConVar("mediaplayer_subtitles", GetConVar("gmod_language"):GetString(), true, false)
local cvInvidiousInstance = CreateClientConVar("mediaplayer_invidious_instance", "", true, false)
local cvInvidiousEnable = CreateClientConVar("mediaplayer_invidious_enable", 0, true, false)

local JS_SetVolume = "if(window.MediaPlayer) MediaPlayer.setVolume(%s);"
local JS_Seek = "if(window.MediaPlayer) MediaPlayer.seek(%s);"
local JS_Play = "if(window.MediaPlayer) MediaPlayer.play();"
local JS_Pause = "if(window.MediaPlayer) MediaPlayer.pause();"

-- VideoJS for Invidious embeds
local VJS_SetVolume = "if(player) player.volume(%s / 100);"
local VJS_Seek = "var time = %s; if(player && !player.seeking() && Math.abs(player.cache_.currentTime - time) > 5) player.currentTime(time);"
local VJS_Play = "if(player) player.play();"
local VJS_Pause = "if(player) player.pause();"

local function YTSeek( self, seekTime )
	-- if not self.playerId then return end
	local js = (self:IsInvidiousEmbed() and VJS_Seek or JS_Seek):format( seekTime )
	if self.Browser then
		self.Browser:RunJavascript(js)
	end
end

function SERVICE:SetVolume( volume )
	local js = (self:IsInvidiousEmbed() and VJS_SetVolume or JS_SetVolume):format( (volume or MediaPlayer.Volume()) * 100 )
	self.Browser:RunJavascript(js)
end

function SERVICE:OnBrowserReady( browser )

	BaseClass.OnBrowserReady( self, browser )

	-- Resume paused player
	if self._YTPaused then
		local js = JS_Play
		if self:IsInvidiousEmbed() then js = VJS_Play end
		self.Browser:RunJavascript( js )
		self._YTPaused = nil
		return
	end

	local url_prefix = htmlBaseUrl .. "youtube.html"
	local invidious_cvar_sv = self.Cvars.InvidiousInstance
	if cvInvidiousEnable:GetBool() then
		url_prefix = htmlBaseUrl .. "invidious.html"
	elseif invidious_cvar_sv:GetString():Trim() ~= "" then
		url_prefix = invidious_cvar_sv:GetString() .. "/embed/" .. self:GetYouTubeVideoId()
		self._InvidiousEmbed = true
	end

	local url = url_prefix ..
				'?v=' .. self:GetYouTubeVideoId() ..
				'&timed=' .. (self:IsTimed() and '1' or '0') ..
				'&instance=' .. cvInvidiousInstance:GetString() ..
				'&subtitles=' .. cvSubtitles:GetString() ..
				'&volume=' .. self:Volume()

	if not self._YTPaused then
		url = url .. "&autoplay=1"
	end

	-- Add start time to URL if the video didn't just begin
	local currentTime = self:CurrentTime()
	if self:IsTimed() and currentTime > 3 then
		url = url .. "&start=" .. math.Round(currentTime)
	end

	browser:OpenURL(url)

end

function SERVICE:Pause()
	BaseClass.Pause( self )

	if ValidPanel(self.Browser) then
		self.Browser:RunJavascript(self:IsInvidiousEmbed() and VJS_Pause or JS_Pause)
		self._YTPaused = true
	end
end

function SERVICE:Sync()
	local seekTime = self:CurrentTime()
	if self:IsPlaying() and self:IsTimed() and seekTime > 0 then
		YTSeek( self, seekTime )
	end
end

function SERVICE:IsMouseInputEnabled()
	return IsValid( self.Browser )
end

function SERVICE:IsInvidiousEmbed()
	return self._InvidiousEmbed
end


function SERVICE:NetWriteRequest()
	if not self.PrefetchMetadata then return end
	net.WriteTable(self._metadata or {})
end

function SERVICE:PreRequest( _callback )
	local callback = function(ok, err, ...)
		if ok then
			_callback()
		else
			_callback(err or "unknown error")
		end
	end

	local videoId = self:GetYouTubeVideoId()
	if not videoId then
		callback(false, "no videoid")
		return
	end

	local videoUrl = "https://www.youtube.com/watch?v="..videoId

	self:Fetch( videoUrl,
		-- On Success
		function( body, length, headers, code )
			if code ~= 200 then
				callback(false, "Fetch(youtube) failed http error "..tostring(code).."")

				if MediaPlayer.DEBUG then
					print(body)
				end
				return
			end

			local status, metadata = pcall(self.ParseYTMetaDataFromHTML, self, body)

			-- html couldn't be parsed
			if not status or not metadata.title or not isnumber(metadata.duration) then
				-- Title is nil or Duration is nan
				if istable(metadata) then
					metadata = "title = "..type(metadata.title)..", duration = "..type(metadata.duration)
				end
				-- Misc error
				callback(false, "Failed to parse HTML Page for metadata: "..metadata)
				return
			end

			self:SetMetadata(metadata, true)

			if self:IsTimed() then
				MediaPlayer.Metadata:Save(self)
			end

			callback(self._metadata)
		end,
		-- On failure
		function( reason )
			callback(false, "Failed to fetch YouTube HTTP metadata [reason="..tostring(reason).."]")
			if MediaPlayer.DEBUG then
				print(reason)
			end
		end,
		-- Headers
		{
			["User-Agent"] = "Googlebot"
		}
	)
end