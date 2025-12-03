@zenscrap_server/CLAUDE.md @zenscrap_server/README.md

Please ultrathink and deeply understand the structure of the chat and ALL THE STREAMING RESPONSES they send to the client.

For this, DO NOT CONTINUE withot deeply analysis each nuance of the following files:
- @zenscrap_server/lib/src/endpoints/public/scrappable_chat_session.dart
- @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart
- @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_openai_sdk_impl.dart 

And now, deeply understand how the streaming models work by seeing all files bellow (without exceptions, they are small files any way):
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/prompt_role_enum.spy.yaml
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/chat_response.spy.yaml 
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/candidate_extract_logic_update.spy.yaml
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/error_text_response.spy.yaml
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/message_text_response.spy.yaml
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/new_extract_rule_response.spy.yaml 
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/test_endpoint_called_error_response.spy.yaml
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/test_endpoint_called_success_response.spy.yaml
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/updated_scrappable_request_response.spy.yaml

I want you to now do the fix the loading of chat is broken...

To do this fix you should deeply understand the ui of the chat where the user interacts with ui that is in @zenscrap_flutter/lib/src/ui/scrap_session/sections/scrappable_chat_message_stream_section.dart file (read it) and the chat part is all done by the riverpod function @zenscrap_flutter/lib/src/states/chat_session/scrap_chat_session_provider.dart that sets the state at @zenscrap_flutter/lib/src/states/chat_session/scrap_chat_session_state.dart that you should look at ( also look at @zenscrap_flutter/lib/src/states/chat_session/scrap_chat_messages_provider.dart )

And now you can go to one of the main files you need to optimize, this file: @zenscrap_flutter/lib/src/states/chat_session/is_chat_loading_provider.dart - the major fixes will be done here

Note tha the UI has a `GenericLoadingBubble` - this is a thing that is not consistent at all.
Overview all files to understand the general flow so you can garantee that it only areas when it should... it should not apear when there is a thinking since thinking is a loading indicator as well but with more context of what is beeing loaded but when there is no thinking happenening BUT the api is still not done (example: it is validating the extract rules the api returned... so there is no thinking in this, just raw loading) it sometimes does not display the loading - mainly when a error occours and the "zen bot" will try again... 

So, because of that I think we can make a general refactor to make this responsability if there is a loading (async process) and a future message to yet come in the chat. This is your main goal witht his task. 

So I think you can add in `ChatResponse`, that is the base abstract class, a boolean of whether if there is a next message to come by the api side, or if it is done (and by done, I mean whether it is success or error in the response time but there will be no future processing).

That why I asked you to gave a great understanding of both sides (app and server). Dont forget to run the serverpod generate command and by the end ensure there are no static analysis errors in the flutter/serverpod site...