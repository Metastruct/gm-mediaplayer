AddCSLuaFile "shared.lua"
include "shared.lua"


function SERVICE:GetMetadata( callback )
	if self._metadata then
		callback( self._metadata )
		return
	end

	local cache = MediaPlayer.Metadata:Query(self)

	if MediaPlayer.DEBUG then
		print("MediaPlayer.GetMetadata Cache results:")
		PrintTable(cache or {})
	end

	if cache then

		local metadata = {}

		metadata.title = cache.title
		metadata.duration = tonumber(cache.duration)
		metadata.thumbnail = cache.thumbnail

		self:SetMetadata(metadata)

		if self:IsTimed() then
			MediaPlayer.Metadata:Save(self)
		end

		callback(self._metadata)

	else
		local videoId = self:GetYouTubeVideoId()

		local instance = self.Cvars.InvidiousInstance:GetString()
		-- Use invidious serverside
		if instance:Trim() ~= "" then
			local videoUrl = instance .. "/api/v1/videos/" .. videoId

			self:Fetch( videoUrl,
				-- On Success
				function( body, length, headers, code )
					if code ~= 200 then
						callback(false, "Fetch(invidious) failed http error "..tostring(code).."")

						if MediaPlayer.DEBUG then
							print(body)
						end
						return
					end
					
					local metadata, data = {}, util.JSONToTable(body)

					metadata.title = data.title
					metadata.thumbnail = data.videoThumbnails[1].url
					metadata.duration = not data.liveNow and data.lengthSeconds or 0

					-- html couldn't be parsed
					if not metadata.title or not isnumber(metadata.duration) then
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
				end,
				-- Headers
				{
					["User-Agent"] = "Googlebot"
				}
			)
		-- Use YouTube serverside
		else
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
	end
end



function SERVICE:NetReadRequest()
	if MediaPlayer.DEBUG then
		print("attempting prefetching metadata from client")
	end
	if not self.PrefetchMetadata then return end

	local metadata = net.ReadTable()
	if not metadata or not next(metadata) then return end
	if MediaPlayer.DEBUG then
		print("got metadata request")
	end
	
	self:SetMetadata(metadata, true)

	if self:IsTimed() then
		MediaPlayer.Metadata:Save(self)
	end

end
