AddCSLuaFile "shared.lua"
include "shared.lua"

local async = assert(require("async") or _G.async)
local http = assert(require("async/http") or _G.async.http)
local json = assert(require("json") or _G.json)

local SOUNDCLOUD_HOMEPAGE = "https://soundcloud.com/"
local MAX_JS_SCRIPT_CHECKS = 4 -- How many of the last js scripts should be checked for client_id
local CLIENT_ID_LENGTH = 32 -- Length of a soundcloud client id

function SERVICE:GetSoundcloudClientId(body)
    return async.runTask(function()
        local js_scripts = {}
        local homepage_body = body or assert(http.get(SOUNDCLOUD_HOMEPAGE):await()) -- Use existing body or homepage

        -- Get the js scripts # example https://a-v2.sndcdn.com/assets/51-a401fcb4.js
        for js_script in string.gfind(homepage_body, "https://a%-v%d%.sndcdn%.com/assets/[%a%d-]+%.js") do
            table.insert(js_scripts, js_script)
        end

        -- Look for client id in scripts
        local client_id
        for i=1, #js_scripts do
            local js_url = js_scripts[#js_scripts + 1 - i] -- Iterate downwards
            if i > MAX_JS_SCRIPT_CHECKS then
                break
            end

            local js_script = assert(http.get(js_url):await())
            for found_client_id in string.gfind(js_script, "['\"]?client_id['\"]?%s*:?%s*['\"]([%d%w]+)['\"]") do
                if #found_client_id == CLIENT_ID_LENGTH then
                    client_id = found_client_id
                    break
                end
            end

            -- Stop js script loop too when found
            if client_id then break end
        end

        if not client_id then
            error("Unable to get client_id from SoundCloud")
        end

        return client_id
    end)
end

local urllib = url

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

		if metadata.extra then
			local extra = json.decode(metadata.extra)

			if extra.stream then
				self.url = extra.stream
			end
		end

		callback(self._metadata)

	else
        async.runTask(function()
            local body = assert(http.get(self.url):await())

            -- Find the hydration json
            local hydration_json = assert(string.match(body, "<script>window%.__sc_hydration%s*=%s*(.+)</script>"))
            -- Parse it
            local hydration = json.decode(hydration_json)

            local resp
            for _, h in pairs(hydration) do
                if h["hydratable"] == "sound" then
                    resp = h["data"]
                    break
                end
            end

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
                        local client_id = self:GetSoundcloudClientId():await()
                        local stream_info_body = assert(
                            http.get(t.url .. "?track_authorization=" .. resp.track_authorization .. "&client_id=" .. client_id):await()
                        )
                        stream = json.decode(stream_info_body).url
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

            metadata.extra = {
                stream = stream
            }

            self:SetMetadata(metadata, true)
            MediaPlayer.Metadata:Save(self)

            self.url = stream

            callback(self._metadata)
        end)
	end
end
