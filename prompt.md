# Context
Zenscrap is a saas where the user talks to an AI that generates web scrappers that can be used with scrapping bee extract rules feature.

Currently, that chat happends mainly in @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart . But I wan't to completly remove it to start using gemini sdk instead.

The reason for this is because It is to complex and to be honest it is not the best...
Currently, I attach the html and a screenshot of the site and example of past requests and it tries to create a extract rule with that and I will mannualy call scrapping bee to check if the generated json is correct - this is probabbly not the best path...

# The ideia

I think a much better way to do this is:
Use a agentic cli tool! For that, I created the gemini_cli_sdk.
My ideia is: I plugged in two very important mcp's;
- the playwright mcp, at @web_scrapper_generator/lib/src/playwright_setup.dart
- the scrapping bee mcp, at @web_scrapper_generator/lib/src/scraping_bee_mcp.dart
This way the cli tool can open the site by it self and see the html in any time and all javascript functions - so the AI will be able to think in flows that require tapping a field, changing a filter checkbox and waiting for the result to then call the scrapping bee with the extract rules and also the js_scenario of fields that need to be fullfilled. So I won't need to call the scrapping be api mannualy, the gemini_cli can call it how many time he wants until the task is done. This is great because I will not need to do any mannual validation...

Both mcp's are done. Now, I have to create the logic of the user "talking with ai". Mainly, your task is to implement "WebScrapperGeneratorController.sendMessage" in  @web_scrapper_generator/lib/src/web_scrapper_generator.dart  and ultra think for a long time to greate good prompts in @web_scrapper_generator/lib/src/prompts.dart

# System Prompt
Let's start with the system prompts. I writted just a initial version of "systemPrompt", but it should be much more bigger with all the logic that I explained above that it should use both mcp servers. The playwright to plan the extract_rules/js_scenario and the scrapping bee mcp to test of the created rules are correct.

Also, it should explain about all the possible schemas of the scrappable mcps (use web research to seek documentation and give a better description if needed):
- url (string): the target page URL to scrape
- extract_rules ( string (JSON-encoded) ): stringified JSON describing what to extract (CSS/XPath selectors, lists, attributes, tables, etc.)
- js_scenario ( string (JSON-encoded)? ): stringified JSON of scripted actions (click/type/scroll/infinite-scroll/etc.) to run before extraction
- render_js (bool): enable a headless browser to execute JavaScript before extraction
- wait (int?): add a fixed delay (milliseconds) before returning the response
- wait_for (int?): wait for a specific CSS/XPath selector to appear before returning
- wait_browser (string?): wait for a browser event (e.g., domcontentloaded) before returning
- premium_proxy (boolean): will use residencial proxy, for more scrapper-resident sites
- country_code (string?): proxy geolocation (e.g., us, de, br)
- session_id (int?): keep the same IP across multiple requests (sticky sessions).
- custom_google (bool?) — enable Google-specific handling, this should allways be true if the url is from a google domain

More infos about those fields can be found here: https://www.scrapingbee.com/documentation/

You MUST give emphasis one the following:
The AI must allways aim to have a lower scrapping bee cost to run.
Thats because some of the scrapping bee parameters charge extra credits to be used... They are:
- JavaScript rendering:
    render_js=true (the default) makes a request cost 5 credits on the rotating pool; turning it off (render_js=false) drops it to 1 credit. 
- Premium (residential) proxies:
    premium_proxy=true costs 10 credits (no JS) or 25 credits (with JS).
- Google domains (HTML API or Proxy Mode)
    If you target Google (e.g., google.com, news.google.com) with the HTML API by setting custom_google=true, or you reach Google through Proxy Mode, it’s a flat 20 credits per request (not additive with premium pricing).

So, while making tests to see if the extract_rules/js_scenario generated worked - it SHOULD YES call the mcp with premium_proxy as true and render_js as true as well - so everything works fine in testing. 
But after the AI finded a extract_rules/js_scenario that correctly brings the data that the user expects, and it is ready to return the ScrappingBeeFetchSettings schema (I will talk more about this schema later in the prompt), then it should try to call the same scraping bee mcp a few more times but this time trying to remove somethings. Example: First, remove the premium_proxy and see if it works - did it still work (still work equals that it is still the same exact json, char by chat, without changing nothing)? call a second time just to ensure... Did it work again? Great, so probably this site does not need any premium proxy... Now, try with render_js=false and see if it is still the same response json and if it is you can return render_js as false in ScrappingBeeFetchSettings response. So, you should guide AI to allways try a more cheeper approach after his tests so it will only set render_js and premium_proxy as true when they are really needed (more complex pages).

Ps: Don't forget to mention that if the target url is a google domain url, then custom_google must allways be default as true - without any testing needed (in the ai tests and in the ai final ScrappingBeeFetchSettings response).

Ps: You should tell ai to use the web search tool to find more info about that site so it can discover more things if needed.

Also, remember to tell ai that if a info the user is talking about is not apearing in the playwright html in a first moment, it can wait add a wait delay to scrapping bee so the page waits... It can also use wait_for or wait_browser if any of those are needed.

Note: This is very similar to systemprompt in @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart - so you can use it as reference (but do not copy letter by letter - its just a reference).

Note: The WebScrapperRequest, from @web_scrapper_generator/lib/src/web_scrapper_response.dart , is quite almost the same of of ScrappableRequest from @zenscrap_server/lib/src/entities/scrappable/scrappable_request.spy.yaml that is created in @zenscrap_server/lib/src/endpoints/public/create_scrappable.dart . This is intentional since I plan to map this object to a ScrappableRequest object later. This is great because currently in @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart there is no way to edit that query patams - and because of that, the url/query params for example, are defined once in the created function and the user does not have a way to edit them in the frontend. Now, the ai has the capability to edit them. Example, if the user asks to add a query param "filter=createdAt" or something like that in the url, the ai will be able to edit the model that will be later casted to a ScrappableRequest. So he can easy edit it by just asking the ai - for that you must explain that the ai can edit that field if needed or the user requested. Example: The user asks to add a query field in query params and with that field the ai should modify the scrapper to click in a field and type that query and wait for 3 seconds for example (with js_scenario variable) - now this is possible because the ai can edit the scrappable request. If the scrappable request does not need to be modified it will return null (null indicates no modification is needed). 

# Initial prompt
As you can see in the @web_scrapper_generator/lib/src/web_scrapper_generator.dart , there will allways be a some pre-prompts added before the user prompt in the first message. This is needed because - while system prompt gives general configs, this will give a more contextual config. 

If the user does not has any have previous created scrapping bee logic, it should generate from zero. So the AI will have a prompt that indicates that it will generate from zero.

And if the user did generate in the past already a scrapping bee logic and is just editing, there should be a initial prompt explaining that the user whan't to edit a scrappable and that that "currentFetchSettings" is how the api is currently beeing called - and it IS currently working, but I as a user whant to made some modifications (that will be the user prompt). This way the AI will have a starting point from a extract_rules/js_scenario/etc... that it already knows that works and can continue to build/iterate from that point.

Note: This is very similar to what is done in composeUserPromptIfNeeded in @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart - so you can use it as reference (but do not copy letter by letter - its just a reference).

# Response schema
The response should be a WebScrapperChatAIResponse, from @web_scrapper_generator/lib/src/web_scrapper_response.dart
This is very similar, if not equal, to what we have in: 
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/chat_response.spy.yaml
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/error_text_response.spy.yaml 
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/message_text_and_new_extract_rules_response.spy.yaml
- @zenscrap_server/lib/src/entities/redraft_scrappable_session/responses/message_text_response.spy.yaml

The ideia is the same, make the sdk communicate with us. We display this messages in the ui in the frontend app - and we display, for example, a error color for when the ai whants to indicate a text that explains that something whent wrong (example: the html is allways returning a captcha and it can not create any extract rules, for example).

Note: Since WebScrapperChatAIResponse is very close to ChatResponse, you can use as reference the prompts of  @zenscrap_server/lib/src/endpoints/public/chat_controller/ (but do not copy letter by letter - its just a reference and make improvements in the prompt if needed).

The gemini_cli_sdk has support to schemas, as you can view in the documentation on @gemini_cli_sdk/README.md 

# Final guide lines 
This is a very hard task - so you should ultra think and take you time to do this - you don't need to rush. Web research for references of good prompt engeniring so you can ultra think in good prompts so ai has a good ideia of what to do

So your task is only to structure/build the best prompts and create the sendMessage function - you should NOT do anything else - do not change @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart