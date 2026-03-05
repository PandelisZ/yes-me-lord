local function speak(text)
    local cmd = string.format("say %q", text)
    local _, err = cos.exec(cmd)
    if err then
        cos.log("say failed: " .. err)
    end
end

local function speak_with_voice(voice, text)
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
