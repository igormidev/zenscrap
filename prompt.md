This saas is all about the user talking to AI models that will create deterministic web scrappers for him.

Ultrathink and deeply understand the flow of chating between user and ai that is make by the :
- @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart
- @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_openai_sdk_impl.dart
- @zenscrap_server/lib/src/endpoints/public/scrappable_chat_session.dart
- @zenscrap_server/lib/src/endpoints/public/chat_controller/openai_prompt_builder.dart

The above part is MANDATORY: do not continue without deeply understanding the flow where the user talks to ai and each nuance of the script - mainly how we deal with not autenticated users. We give support for not autenticated users to test the app before having a account so they can have a idea of the value the product has and how fast it generates a scrappable. But we don't want to let users abuse on top of that... Now, we already make a limit by session - so a session of a not logged in user can't waste more then 10 dollar. But not autenticated user can still create infinite sessions by refreshing the page... We will do a thing that will mitigate that: limit max amount of dollars a IP can spend.

So, create a ".spy.yaml" model that represents the dollar spent by a user in the last 7 days. Add the double that represents the value and also the createdAt datetime. Each call of a not autenticated user you will check if that model exists and if it does not exist you will create it and save in the database. And for each call you will run the AI and in the end you will update the value of that model. If that value passes 17.50 dollars ( make this a constant in @zenscrap_server/lib/src/core/consts.dart )

Then, lets add a FutureCall that will be a cleaner function that will run from hour to hour... and it will seek for each of those models that already passed 7 days and will delete them so the next time the user tries to use the scrappable chat model will not find a model for that ip (because it was cleaned) and the user will be able to continue to use the app - so it will allways reset after 7 days.

To display to the user that he had pass this limit, please create a new implementation of `ChatResponse` ( @zenscrap_client/lib/src/protocol/entities/redraft_scrappable_session/chat_response.dart ) inside folder @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/ - this implementation will have the date of duration of how many time the user needs to wait in order to create a new message in the chat (send a Duration model) and I think this will be the only thing... Run "serverpod generate" command to generate the new models...

You should implement the frontend as well. ultrathink and deeply analyse the file @zenscrap_flutter/lib/src/ui/scrap_session/sections/scrappable_chat_message_stream_section.dart and how other types of `ChatResponse` set different types of "chat bubbles" and by that you will make a diferent ui that will show a counter of how much time the user needs to wait (show days, hours and minutes). Also display a respectfull message that says to the user for him to create a account and add a CTA button that will redirect him to login with `unawaited(context.push('/auth'));`

Also, analyse the @zenscrap_flutter/lib/src/providers/posthog_provider.dart and add a tracking for anytime the server returns that message - I want to track the event that a user received this message. I also want to track when we clicks in the CTA button.

Please make sure that there is no static analysis errors by the end - no errors in the server and no errors in the client/flutter app.