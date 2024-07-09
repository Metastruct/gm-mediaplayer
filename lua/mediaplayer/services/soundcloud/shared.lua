DEFINE_BASECLASS( "mp_service_base" )
local SERVICE = SERVICE -- Allow functions to use the service table

local async = assert(require("async") or _G.async)
local http = assert(require("async/http") or _G.async.http)
local json = assert(require("json") or _G.json)

local SOUNDCLOUD_HOMEPAGE = "https://soundcloud.com/"
local MAX_JS_SCRIPT_CHECKS = 4 -- How many of the last js scripts should be checked for client_id
local CLIENT_ID_LENGTH = 32 -- Length of a soundcloud client id

SERVICE.Name 	= "SoundCloud"
SERVICE.Id 		= "sc"
SERVICE.Base 	= "af"

SERVICE.PrefetchMetadata = false

function SERVICE:New( url )
	local obj = BaseClass.New(self, url)

	-- TODO: grab id from /tracks/:id, etc.
	obj._data = obj.urlinfo.path or '0'

	return obj
end

function SERVICE:Match( url )
	return string.match( url, "soundcloud.com" )
end

function SERVICE:GetSoundcloudClientId(body)
    return async.runTask(function()
		-- Enable client id cache
		if SERVICE.client_id then return SERVICE.client_id end

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

		SERVICE.client_id = client_id

        return client_id
    end)
end

function SERVICE:GetSoundcloudMetadata(url)
	return async.runTask(function()
		local body = assert(http.get(self.url):await())

		-- Find the hydration json
		local hydration_json = assert(string.match(body, "<script>window%.__sc_hydration%s*=%s*(.+)</script>"))
		local hydration = json.decode(hydration_json)

		local resp = { body = body }
		for _, h in pairs(hydration) do
			resp[h["hydratable"]] = h["data"]
		end
		return resp
	end)
end
