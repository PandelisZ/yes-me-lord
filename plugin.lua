local function speak(text)
    local cmd = string.format("say %q", text)
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

cos.log("yes-me-lord loaded")
