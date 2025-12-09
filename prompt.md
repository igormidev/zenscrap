In @zenscrap_flutter/lib/src/ui/scrap_session/view/initial_chat_view.dart I want to make a giant refactor in the first page that apears for the user - the `InitialChatPage` of @zenscrap_flutter/lib/src/ui/scrap_session/pages/initial_chat_page.dart . Understand how the structure works today so we can make a general refactor on it (do not jump this step, understand how the UI works and the providers currently integrate between each other to then do the refactor I will ask you to)

Well, I want to make a complete refactor of this page. It will now act as a landing page as well. 

# Context:
I am ready to launch this project that is a saas that helps users to create web scrappers in a no-code way - they just talk to ai in a chat interface format asking where they will provide a link and then ask to the AI what they want to extract from that site and under the hood, like magic, it will generate a web scrapper for him. 

I have two main differentiators from the competition:

## Difference number 1: ULTRA FOCUSED on praticity, a extremely fast no-brainer way to create a web scrapper
Literally everything is automated. The unique input the user gives is the url of the site that we wants to scrap a info, and a text description of what he want to extract from that link.
That literally it - nothing more. Normally in this type of site the user will need to put a title, a description of the scrappable, maybe select a category and probably will need to explain what are the dynamic parts of the link and more (etc..). With my saas, it does everything automaticly (creates a name, generates a description and even pics a category for better organization). Take a deep look in the creation flow of a scrappable in the file @zenscrap_server/lib/src/endpoints/public/create_scrappable.dart

Potential clients:

