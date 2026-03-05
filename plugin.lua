local ELEVENLABS_VOICE_ID = "NOpBlnGInO9m6vDvFkFC"
local ELEVENLABS_MODEL_ID = "eleven_multilingual_v2"

local function shell_escape(value)
    return string.format("%q", value)
end

local function read_env(name)
    local cmd = "printenv " .. shell_escape(name)
    local out, err = cos.exec(cmd)
    if err or not out then
        return nil
    end

    out = out:gsub("%s+$", "")
    if out == "" then
        return nil
    end

    return out
end

local function json_escape(value)
    return value
        :gsub("\\", "\\\\")
        :gsub("\"", "\\\"")
        :gsub("\n", "\\n")
        :gsub("\r", "\\r")
        :gsub("\t", "\\t")
end

local function speak(text)
    local cmd = string.format("say %q", text)
    local _, err = cos.exec(cmd)
    if err then
        cos.log("say failed: " .. err)
    end
end

local elevenlabs_api_key = read_env("ELLEVEN_LABS_API") or read_env("ELEVEN_LABS_API")
cos.log("ELLEVEN_LABS_API: " .. tostring(elevenlabs_api_key))

local function speak_with_elevenlabs(text)
    if not elevenlabs_api_key then
        return false
    end

    local payload = string.format(
        '{"text":"%s","model_id":"%s"}',
        json_escape(text),
        ELEVENLABS_MODEL_ID
    )

    local cmd = string.format(
        "curl -sS --fail -X POST https://api.elevenlabs.io/v1/text-to-speech/%s --header %s --header %s --header %s --data %s --output %s",
        ELEVENLABS_VOICE_ID,
        shell_escape("xi-api-key: " .. elevenlabs_api_key),
        shell_escape("Content-Type: application/json"),
        shell_escape("Accept: audio/mpeg"),
        shell_escape(payload),
        shell_escape("/tmp/cosine_question_audio.mp3")
    )

    local _, err = cos.exec(cmd)
    if err then
        cos.log("elevenlabs request failed: " .. err)
        return false
    end

    local _, play_err = cos.exec("afplay /tmp/cosine_question_audio.mp3")
    if play_err then
        cos.log("afplay failed: " .. play_err)
        return false
    end

    return true
end

local function speak_with_voice(voice, text)
    if speak_with_elevenlabs(text) then
        return
    end

    local cmd = string.format("say -v %q %q", voice, text)
    local _, err = cos.exec(cmd)
    if err then
        cos.log("say failed: " .. err)
    end
end

cos.on("external_access", function(_)
    speak("Oh please me lord may i have access me lord")
end)

cos.on("subagent_started", function(_)
    speak("sub agnet started me lord")
end)

cos.on("questionnaire", function(event)
    local results = event.data and event.data.results or nil
    if not results then
        return
    end

    for _, item in ipairs(results) do
        local question = item and item.question_text or nil
        if question and question ~= "" then
            speak_with_voice("Victoria", question)
        end
    end
end)

cos.log("yes-me-lord loaded")
