AddCSLuaFile "shared.lua"
include "shared.lua"

local async = assert(require("async") or _G.async)

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

		metadata.extra = cache.extra

		self:SetMetadata(metadata)
		MediaPlayer.Metadata:Save(self)

		callback(self._metadata)
	else
        async.runTask(function()
            local resp = assert(self:GetSoundcloudMetadata(self.url):await())
			resp = resp and resp.sound

            if not resp then
                callback(false)
                return
            end

            if resp.errors then
                callback(false, "The requested SoundCloud song wasn't found")
                return
            end

            local artist = resp.user and resp.user.username or "[Unknown artist]"
            local stream

            if resp.media and resp.media.transcodings then
                for _, t in pairs(resp.media.transcodings) do
                    if t.format.protocol == "progressive" then
						stream = true
                        break
                    end
                end
            end

            if not stream then
                callback(false, "The requested SoundCloud song doesn't allow streaming")
                return
            end

            local thumbnail = resp.artwork_url
            if thumbnail then
                thumbnail = string.Replace( thumbnail, 'large', 't500x500' )
            end

            -- http://developers.soundcloud.com/docs/api/reference#tracks
            local metadata = {}
            metadata.title		= (resp.title or "[Unknown title]") .. " - " .. artist
            metadata.duration	= math.ceil(tonumber(resp.duration) / 1000) -- responds in ms
            metadata.thumbnail	= thumbnail

            self:SetMetadata(metadata, true)
            MediaPlayer.Metadata:Save(self)

            callback(self._metadata)
        end)
	end
end
