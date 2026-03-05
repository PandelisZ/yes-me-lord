# yes-me-lord

A Cosine CLI plugin that speaks honorific voice lines on specific events.

## Events

- `external_access` → says: `Oh please me lord may i have access me lord`
- `subagent_started` → says: `sub agnet started me lord`

## Requirements

- macOS (uses the built-in `say` command)
- Cosine CLI plugin support

## Questionnaire voice configuration

For `questionnaire` events, the plugin can use ElevenLabs text-to-speech.

- Set `ELLEVEN_LABS_API` in your environment to enable ElevenLabs.
- Voice ID is fixed to `NOpBlnGInO9m6vDvFkFC`.
- If the key is not set (or ElevenLabs fails), the plugin falls back to macOS `say -v Victoria`.

Example:

```bash
export ELLEVEN_LABS_API="your_api_key"
```

## Local setup

1. Create the plugin directory if needed:

   ```bash
   mkdir -p ~/.cosine/plugins
   ```

2. Copy this folder into your local plugins directory:

   ```bash
   cp -R yes-me-lord ~/.cosine/plugins/yes-me-lord
   ```

3. Start Cosine CLI.

When `external_access` or `subagent_started` events fire, macOS will speak the configured message.

## Files

- `PLUGIN.md` — plugin manifest
- `plugin.lua` — event handlers
