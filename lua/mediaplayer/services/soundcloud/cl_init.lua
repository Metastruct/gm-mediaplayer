include "shared.lua"

local async = assert(require("async") or _G.async)
local http = assert(require("async/http") or _G.async.http)
local json = assert(require("json") or _G.json)

function SERVICE:Play()
	-- Replace the url before passing to audiofile
	async.runTask(function()
		-- Get the soundcloud metadata
		local resp = assert(self:GetSoundcloudMetadata(self.url):await())
		if not resp or not resp.body or not resp.sound then
			local msg = ("Failed to load soundcloud metadata '%s'"):format( self.url )
			LocalPlayer():ChatPrint( msg )
			return
		end
		resp = resp.sound

		local stream
		if resp.media and resp.media.transcodings then
			for _, t in pairs(resp.media.transcodings) do
				if t.format.protocol == "progressive" then
					local client_id = self:GetSoundcloudClientId(resp.body):await()
					local stream_info_body = assert(
						http.get(t.url .. "?track_authorization=" .. resp.track_authorization .. "&client_id=" .. client_id):await()
					)
					stream = json.decode(stream_info_body).url
					break
				end
			end
		end

		if not stream then
			local msg = ("Failed to get soundcloud stream url '%s'"):format( self.url )
			LocalPlayer():ChatPrint( msg )
		end

		self.url = stream

		baseclass.Get("mp_service_af").Play( self )
	end)
end
