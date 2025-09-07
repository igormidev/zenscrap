I wan't to do a refactor in the create scrappable logic - We will add in @zenscrap_server/lib/src/entities/scrappable/scrappable.spy.yaml a field called jsSenario that will be a nullable string (it is not required)

My intent is to add the possibility to add in @zenscrap_server/lib/src/core/scraping_bee.dart the "js_scenario"

VERY IMPORTANT: Use you web search tool to find the documentation of scrapingbee js_scenario parameter. The documentation is here: "https://www.scrapingbee.com/documentation/js-scenario/
DO NOT follow without reading the documentation in the link above

So, with that new variable in scrappable model, you will now edit @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart 
Here will be great part of the task - you will need to edit the schema and ultra think hard to write good prompts that explain what is the js_scenario so gemini can know how to add one if needed (remembering that it is optional). I what to emphasis that this is very important.