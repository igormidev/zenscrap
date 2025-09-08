Context:
Zenscrap is a saas where the user talks to an AI that generates web scrappers that can be used with scrapping bee extract rules feature.

Currently, that chat happends mainly in @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart . But I wan't to completly remove it to start using gemini sdk instead.

The reason for this is because It is to complex and to be honest it is not the best...
Currently, I attach the html and a screenshot of the site and example of past requests and it tries to create a extract rule with that and I will mannualy call scrapping bee to check if the generated json is correct - this is probabbly not the best path...

I think a much better way to do this is:
Use a agentic cli tool! For that, I created the gemini_cli_sdk.
My ideia is: I plugged in two very important mcp's;
- the puppeteer mcp, at @web_scrapper_generator/lib/src/puppeteer_setup.dart
- the scrapping bee mcp, at @web_scrapper_generator/lib/src/scraping_bee_mcp.dart
This way the cli tool can open the site by it self and see the html in any time and all javascript functions - so the AI will be able to think in flows that require tapping a field, changing a filter checkbox and waiting for the result to then call the scrapping bee with the extract rules and also the js_scenario of fields that need to be fullfilled. So I won't need to call the scrapping be api mannualy, the gemini_cli can call it how many time he wants until the task is done.

So, to-do so, I will need to implement the  in @web_scrapper_generator

So, instead, I will use gemini cli with two very important mcps to generate the scrapping rules.
The first mcp is Puppeteer, with proxy to get access to more complex sites, to understand the logic of what the user whants. That mcp already exists and you can see its configuration mainly in @web_scrapper_generator/lib/src/puppeteer_setup.dart 

The other is that I need you to build is the scraping bee mcp. This mcp does not exist and will need to be built from zero.
You should build a mcp that will be used by the gemini cli in @web_scrapper_generator/lib/web_scrapper_generator.dart later on... So when I call the sendMessage function of WebScrapperGeneratorController, that I will implement later, it will have access to that mcp like it has access to the scrapping bee mcp today. You will set this mcp in the WebScrapperGeneratorController.init and you should create all mcp logic in  @web_scrapper_generator/lib/src/scraping_bee_mcp.dart file that is currently empty.

This mcp will basicly have only 1 functionality: Give the hability to the api to test a extract rule that it will create by calling the mcp that will make a request to scrapping bee.

So schemas that the mcp will have as input is:
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

This mcp should call the scraping bee by http package with all the parameters above and will give the response to the AI.
This mcp MUST be done in dart. You MUST use the package "https://pub.dev/packages/dart_mcp" to make implementation more easy. Ultra think and web research the documentation. Use dio to make the requests - use @zenscrap_server/lib/src/core/scraping_bee.dart as reference but with all the fields above. The dart_mcp has support to schemas - use it so the gemini cli will has the knowlage of all parameters. Also make a schema as response.

My scraping api key is "37N8150Q1JBVN85NS4RUOUIUYZ2AEUFX69QBM0X74VD13M9TLNRVOFWS7HZMKRG1X4SOH4BKJT5EUN6K".

So you should create the mcp and ensure it is available for the gemini cli

So your task is only to build the scrapping bee mcp - you should NOT do anything else.