---
name: yes-me-lord
description: Speaks honorific messages for external access and subagent start events
version: "0.1.0"
events:
  - external_access
  - subagent_started
  - session_title_updated
  - questionnaire
---

# yes-me-lord

Speaks messages for configured Cosine events.

For `questionnaire` events, if `ELLEVEN_LABS_API` is set, the plugin uses ElevenLabs voice `NOpBlnGInO9m6vDvFkFC`. Otherwise it uses macOS `say`.
