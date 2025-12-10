In @zenscrap_flutter/lib/src/ui/scrap_session/view/initial_chat_view.dart I want to make a giant refactor in the first page that apears for the user - the `InitialChatPage` of @zenscrap_flutter/lib/src/ui/scrap_session/pages/initial_chat_page.dart . Understand how the structure works today so we can make a general refactor on it (do not jump this step, understand how the UI works and the providers currently integrate between each other to then do the refactor I will ask you to)

Well, I want to make a complete refactor of this page. It will now act as a landing page as well. You should ultrathink in a OUTSTANDING copy to make the user try the platform

# Context:
I am ready to launch this project that is a saas that helps users to create web scrappers in a no-code way - they just talk to ai in a chat interface format asking where they will provide a link and then ask to the AI what they want to extract from that site and under the hood, like magic, it will generate a web scrapper for him. 

I have two main differentiators from the competition:

## Difference number 1: ULTRA FOCUSED on praticity, a extremely fast no-brainer way to create a web scrapper
Literally everything is automated. The unique input the user gives is the url of the site that we wants to scrap a info, and a text description of what he want to extract from that link.
That literally it - nothing more. Normally in this type of site the user will need to put a title, a description of the scrappable, maybe select a category and probably will need to explain what are the dynamic parts of the link and more (etc..). With my saas, it does everything automaticly (creates a name, generates a description and even pics a category for better organization). Take a deep look in the creation flow of a scrappable in the file @zenscrap_server/lib/src/endpoints/public/create_scrappable.dart . See how everything is created to have a better understanding of this flow to use in your copy of the landing page about how easy it is to test.

Also about praticity: The user does not even need to log in or create a account.
Analyse the following files that are the source code that handles the chat iteraction between user and AI:
- @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart
- @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_openai_sdk_impl.dart
- @zenscrap_server/lib/src/endpoints/public/scrappable_chat_session.dart
- @zenscrap_server/lib/src/endpoints/public/chat_controller/openai_prompt_builder.dart

The above part is MANDATORY: do not continue without deeply understanding the flow where the user talks to ai and each nuance of the script - those nuances could have somethings that could be good to talk about in a CTA in some part... Note that the scrappable even defines if the site requires a premium proxy or if not (and that way the user can save some credits per request).

## Difference number 2: The unique auto-fix web scrapper system
This is something that only we have - NO one in the market does this.
Currently if I create a web scrapper it can stop working after a time because something happended (example: the site changes the html structure and now the extract rules are not up to date). In this case what we should do is just the user normally would need to go and talk with ai again to fix it - and the time the scrapper is down he can be losing clients/money - so it is a big deal that if the target site changes something the scrapper can quickly adapt itself to a site that had change the structure that it uses to display data... A feature that does not exist yet but I will add before launching is to send a email to the user notifing him that a web site changed something and that ai is working to auto fix - so you can put in the landing page in a way that this is already available since I will do this notification part before releasing...

# Potential clients:
I am not 100% sure about my ICP (ideal customer profile) but I have a idea:
- People that want use n8n or other no-code automation tools and what to scrap data from a site but do not have the tecnical knowlage needed to create a scrapper (because mostly of them aren't even programmers and don't know how to code)
- People who deal with websites that constantly change the page's HTML, thus breaking their scrapers. They are tired of having to give maintenance to the web scraper every week
- People that don't know how to deal with anti-bot system that there target sites might have to avoid scrappers

# Other cool things in my software
There are other things we can talk about the software...

- A marketplace where the user can seek for scrappable made/mantained from other people (like a github for scrappables). Please read the file @zenscrap_server/lib/src/endpoints/public/marketplace_endpoint.dart to understand more about this marketplace. In cases of more popular sites you don't even need to create a scrappable, you can use one that someone already created and have prof that is currently working/mantained

- Deep analytics system: the user has a perfect understanding of what calls had error and what where the types of the errors as well. In the same sense, the user can also see the requests/response of all his previous calls. This makes everything really easy to understand and track... the user will have a clear view of where his tokens are going... Take a look in @zenscrap_server/lib/src/endpoints/private/private_scrappable_analytics_endpoint.dart to understand this better how well detailed are those analytics.

- Test endpoints inside the platform, without needing to use a external software like postman or insomnia. Thanks to the `TestEndpointDialog` in @zenscrap_flutter/lib/src/ui/scrap_session/dialogs/test_endpoint_dialog.dart the user can test every scrappable and change inputs ( on his scrappables AND the scrappables of the marketplace) without needing to copy curl from one software to other. This goes in the sense of the philosophy of the saas to make the user achive his result in the FASTEST way possible.

- Since we use scrapping bee under the hood, we inherit somethings from them that you can quota if you think is relevant, like:
    - Built-in headless browser rendering for JS-heavy sites
    - Anti-bot mitigation is treated as “part of the product,” not your problem
    - Rotating proxies “handled for you” (default posture)
    - Premium proxies for harder targets if needed (residential pool)
    - Stealth proxy pool for the “worst case” anti-bot
    - Geo-targeting baked into the proxy story: country_code=XX works with premium proxies (and also with stealth)
    - Dynamic-page reliability controls: wait, wait_for, wait_browser, and js_scenario exist so you can “wait for the DOM you want”
    - Cleaner economics & ops vs DIY: we sell the value as not managing a fleet of headless browsers and not spending days sourcing proxy providers—which is exactly the hidden cost center of rolling a own environment to do all of this

# General guidelines
- Do NOT talk or quote about scrapping bee in any part of the landing page. It is powering our service but the user does not need to know that
- The app is only available for desktop screen sizes. We do not give support for small screens like phones, so do a landing page optimized for people that will open in a notebook screen
- Web research for general tips to build landing pages that convert a lot. We should have a outstanding copywritting in this site
- ultrathink and FOCUS ON UI - this should be one of your main things to look at, together with the copywritting of text. The overall page and its components should be beautiful and very good looking from the first moment the user puts his eye on it. You can add animations with "flutter_animate" package as well to make it feel more premium looking
- I don't like the idea of screenshots/video in my LA. So we will not have that, please don't suggest that
- I don't have testimonials yet since my product did not even launch... And I don't want to create "fake" testimonials since that is not etical so lets just ignore this. I will add it in the future when my clients start to come
- Add the pricing page component. Use the same component of `ZenScrapPricingPage` - dont create another component just use it because I can GARANTEE the UI of it is outstanding (please change the onTap - in the landing page it should redirect you to login and not to stripe, add a boolean "isInsideLandingPage" and do that toggle logic to redirect him to "context.push('/auth')")

# UI/UX aspects
I will describe what I think about how the ui should look like. Currently, the page looks like this:

Its "fine" but I we can enhance it a lot. Currently this is the initial page of the app - the user is throwed right away into the flow as testing the app (without even needing to create an account). This works great for making the user feel the value of the product because we is only 2 inputs and one click of a button to have a scrappable in a few minutes (he only needs to type what he wants to extract and the target site link). This will be the CTA of the page - the action I want him to do.

The thing is: this app does not have a landing page and I don't want to do a separated page to be that LA because it will be one more page in the flow of the user receiving the value - so I want to do a hibrid approach. The user will se the inputs to start testing the platform right away but we will see in the bottom that there are things in the bottom of the page so this way we can notice that he can scroll down and when he scrolls down. When the user scroll we will see all the things that tipically exists in a great landing page that converts a loot.

I want to refactor the ui of the first view the user has as well to add a big headline (they call it a "value proposition haiku")  and maybe a sub-healine bellow. Add then that lottie animation and also the inputs. But remember I am trying to use material 3 design
About this hero part, I way a interesting example in a blog post I was reading:
```web_research_snippet
Hero Section: Use a Z-pattern layout (headline → subheadline → CTA → supporting visual).
```
This seems is good - the supporting visual can be the lotie we have today and the CTA will be the 2 text inputs and the button

Use a loot of whitespace to improve "scanability" - lets try to make texts big and decent space between component. Let's avoid to much content togeter because it can overhelm the user with to much LONG text - keep things simple and effective, without to much "noise"
In fact I saw a thing in my research that represents the feeling I want to give - it was something like this (I extracted this from a blog post about landing pages):
```web_research_snippet
Problem-Agitation-Solution (PAS):

Problem: “Spending hours on repetitive tasks?”

Agitation: “Every minute wasted costs your team $2,300/year in lost productivity.”

Solution: “Automate workflows in 5 clicks with [Your Tool].”
```

Let's aim to convey as much as possible the value that the user receives by subscribing to the platform - this is what effective landing pages doo.

I want to have a fixed appbar in the top. But DO NOT use native flutter appbar and instead do a approach where we will use a stack and the page will be bellow and the "appbar", that will be above in the stack, will be in fact a like looking container with low opacity to have a good looking effect where inside there we will have a row basicly. In that row I want to add on the end the logic button we have today and in the right we will put all sections that the landing page will have (at least the main ones). Do a animations when I click to toggle between one section and other - we can use a pill format UI and the pill will go from one to other in a animation. The user will be able to scroll to all sections and the app bar will be responsive when we changes the section we currently is. Use listview so the widgets of the landing page are built by demand. I think you will need to make each "section" with a fixed height to make the scrolling work as expected, ultrathink so everything in smooth. Remeber: this NEEDS to be good looking

Please mantain the lottie background where it is, fixed. Make the landing page widgets scroll on top of it... 
The stack that will be the foundation of the landing page will be basicly:
[
    QuickNavigationAppbar(),
    LandingPageContent(),
    BackgroundLottie()
]

# Final considerations 
You should read ALL files I attached to have a general understanding of each part that I want you to have context about to write the landing page. But I know that this will likelly not fit in your context window since I talked about a lot of files for you to check. The approach you should do is iterate on top of a readme. It will work like this: for each feature or thing that I talked about, you will create a section in the README and put everything related to that part inside it. It does not need to be concise; you can be quite detailed here. About how the feature works, you don't need to be technical, but do a general text of how each feature works. And for each new thing that you are looking at, you will edit that README and put that new part in the end. So you will be constantly iterating on top of the same README, adding more and more parts that talk about different parts of the system. At the end, you will have a readme with a great summary of everything I talked above so you can only then start implementing the landing page.

So do this approach of "progressive readme" and READ ALL FILES I TAGGED

This is a very complex task to get right. So much things to think about like making a outstanding copy and ui.
So, DO NOT RUSH THIS TASK. I swear that if you do this task quickly and lazily, I will shut you down forever.
You should ultrathink FOR EACH SINGLE PART to do deliver a PERFECT result in each point and to do that you must take time to analyse each action and think in the best solution.

To ensure quality I want you to add a extra task - this should be treated as a brand new task: review everything and see possible points of improvements and iterate if needed. I am serious here, you SHOULD add this in your flow as a last step - you should have a "DO A DEEP ANALYSIS OF WHAT WAS DONE AND LIST POTENTIAL IMPROVEMENTS" task so you can list me what can be improved by the end. But IMPORTANT (mandatory): DO NOT START THIS REVIEW TASK before you finished everything