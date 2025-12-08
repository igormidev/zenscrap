Great. Now, there was another route that was also using that mcp that you should refactor. First, read the files bellow and understand what they do:
- @zenscrap_server/lib/src/core/auto_fix/auto_fix_prompt_builder.dart
- @zenscrap_server/lib/src/core/auto_fix/auto_fix_session_handler.dart
- @zenscrap_server/lib/src/core/auto_fix/periodic_auto_fix_scrappables.dart

You will see that `buildAutoFixSystemPrompt` of @zenscrap_server/lib/src/core/auto_fix/auto_fix_prompt_builder.dart also uses the key in the prompt...

Do the same thing of the other prompt, remove that variable and any reference to key in the prompt... ultrathink to do this with excellence

By the way, see if any there is any change that will be need to be done in @zenscrap_server/lib/src/core/auto_fix/auto_fix_session_handler.dart that makes the request to the scrapapble...