# yes-me-lord

A Cosine CLI plugin that speaks honorific voice lines on specific events.

## Events

- `external_access` → says: `Oh please me lord may i have access me lord`
- `subagent_started` → says: `sub agnet started me lord`

## Requirements

- macOS (uses the built-in `say` command)
- Cosine CLI plugin support

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
