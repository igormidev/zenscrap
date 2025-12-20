> My scrapping bee key leaked... Lets change it in the both mcp's @playwright-mcp-railway/ and @scrapping_bee_mcp . My new scrapping bee key is "TEIPQ215C2NFOEBPAD5PRKNI270EGR15NI18RXOJPUE1C2ZP3H7ED2ERMJP0WLZ2T9YO8WEJDIAVGDUK" - I removed the last api key and created this new one
Also, talking with chatgpt it seems that the reason of the leek was because it was hardcoded... So, move all secrets to Railway Environment Variables.
You have access to railaway cli. Use it so I dont need to do anything, do all the settings by yourself of a new env variable for both mcps (yes, both are hosted in railaway)
Then, make those mcp's require a X-API-KEY to be used - use "9cdad40e-396e-455e-8df4-928bb8f97497" as thay x-api-key and dont forget to change the places that use the tool in the server (  @zenscrap_server/lib/src/core/auto_fix/auto_fix_session_handler.dart and @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_openai_sdk_impl.dart )
After you upload a new version of the railaway cli, sleep for a time (the deploy time) and then try to use the mcp to garantee the mcp is working

Before you start I will give you the general context of what happended: Today I started to receive uncoutless errors of scrapping bee and I saw that I was without credits and I saw in logs and analytics of scrapping bee site that there was some strange usage not made by me. Talking with chat gpt it explained me that since the mcp has the hardcoded key AND the mcp has no autentication to be used, probably some one discovered that mcp and used it to exaustion. So, please ultrathink and make a deep review if my 2 fixes will resolve or if I need to so something more. Just to resume the 3 fixes are:
  - change the key (just in case)
  - use key as environment instead of hardcoded in the code (most garanteed that will not leak if my code leaks)
  - make a autorization in the requests on my server ( that have private code ) by passing a uuid key that I am using as a X-API-KEY so this way even if someone finds my endpoint to the mcp he will not be able to use

Please, before making any change, garantee that this will work and there will be no security issues...