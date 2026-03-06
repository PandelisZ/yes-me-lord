local ELEVENLABS_VOICE_ID = "NOpBlnGInO9m6vDvFkFC"
local ELEVENLABS_MODEL_ID = "eleven_multilingual_v2"
local ELEVENLABS_ENABLED = false

local function shell_escape(value)
    return string.format("%q", value)
end

local elevenlabs_api_key = nil
if type(cos.getenv) == "function" then
    elevenlabs_api_key = cos.getenv("ELEVEN_LABS_API")
end
local audio_file_sequence = 0

local function speak_with_elevenlabs(text)
    if not ELEVENLABS_ENABLED then
        return false
    end

    text = tostring(text or "")
    if text == "" then
        return false
    end

    if not elevenlabs_api_key then
        cos.log("elevenlabs skipped: ELEVEN_LABS_API is missing")
        return false
    end

    cos.log("elevenlabs: requesting audio")

    local payload = string.format(
        '{"text":%q,"model_id":%q}',
        text,
        ELEVENLABS_MODEL_ID
    )

    audio_file_sequence = audio_file_sequence + 1
    local audio_path = string.format("/tmp/cosine_question_audio_%d.mp3", audio_file_sequence)

    local cmd = string.format(
        "curl -sS --fail --show-error --http1.1 --retry 2 --retry-delay 1 --connect-timeout 10 --max-time 30 -X POST https://api.elevenlabs.io/v1/text-to-speech/%s --header %s --header %s --header %s --data %s --output %s",
        ELEVENLABS_VOICE_ID,
        shell_escape("xi-api-key: " .. elevenlabs_api_key),
        shell_escape("Content-Type: application/json"),
        shell_escape("Accept: audio/mpeg"),
        shell_escape(payload),
        shell_escape(audio_path)
    )

    local _, request_err = cos.exec(cmd)
    if request_err then
        cos.log("elevenlabs request failed: " .. tostring(request_err))
        return false
    end

    local _, stat_err = cos.exec("test -s " .. shell_escape(audio_path))
    if stat_err then
        cos.log("elevenlabs output missing or empty: " .. audio_path)
        return false
    end

    local _, play_err = cos.exec("afplay " .. shell_escape(audio_path))
    if play_err then
        cos.log("afplay failed: " .. play_err)
        return false
    end

    cos.log("elevenlabs: playback succeeded")

    cos.exec("rm -f " .. shell_escape(audio_path))

    return true
end

local function speak_with_voice(voice, text)
    text = tostring(text or "")
    if text == "" then
        return
    end

    if speak_with_elevenlabs(text) then
        return
    end

    local cmd = string.format("say -v %q %q", voice, text)
    local _, err = cos.exec(cmd)
    if err then
        cos.log("say failed: " .. err)
    end
end

local function speak(text)
    speak_with_voice("Victoria", text)
end

cos.on("external_access", function(_)
    speak("Oh please me lord may i have access me lord")
end)

cos.on("subagent_started", function(_)
    speak("sub agnet started me lord")
end)

cos.on("session_title_updated", function(event)
    local title = event.data and event.data.title or nil
    if not title or title == "" then
        return
    end

    speak("Now working on: " .. title .. " my lord")
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
