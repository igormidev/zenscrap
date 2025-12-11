I want to add better SEO for this my saas. I will ask claude code to do this, could you please write a prompt for me inside a readme file that tells how claude code should do this task? Please mention files (use "@" in the front of files names that is the way claude code recognizes file mentioning) and also mention file names. You should ultrathink to be the master of prompt engeniring so the task is really well defined - you can suggest things as well. I am asking this to you instead of me writing the prompt myself because I think you will do a better prompt engeniring job.

In your prompt you should ask claude code to spawn new instances of claude code to do 3 tasks - this is because I want the main claude instance to be only the conductor since each one of the tasks in very heavly to do and will require a lot of web reseach. So one task alone would already end the context of that claude instance and it will start to compact and then start to deliver worse responses - so a better approach for this kind of task that will require multiple tasks that are context-heavly it is better to create a brand new instance with a clean context and with a focused prompt for only one task - so it will do that task with excelence since it is focused only on it... ask ai to "ultrathink" in the good rich prompts for each sub ai he will create and ask it to give reference of files and functions as well in those prompts...

That was the hole arquiteture of the prompt - low lets go to the task itself that I want you to create a prompt for me to run with claude code: I want to enhance the SEO so my site is more easly finded by robots (search engines and AI)

In your prompt ask for the ai to ultrathink and ask it to add in each prompt of instances it will spawn there instances to ultrathink as well (use opus 4.5 in each one of those instances).

GUIDELINE: In your prompt guide the ai to run only one instance per time and in all prompts tell ai to ensure there is no static analysis errors by the end and commit changes before going to next task.

# Some instances to spawn (ask in the prompt for claude code to spawn a claude code instance for each one bellow and and it to use opus 4.5 in each one of those instances):

# I want to spawn one instance that will be just to web research internet for tips about how to write outstanding "robots.txt" and a great "sitemap.xml" and implement those files/tips here in the flutter app.
Currently the sitemap will maybe only have 1 page that is the landing page maybe since the other pages the user needs to log in... maybe the login page as well can appear but besides that every other page required login...

## I want to spawn one instance for adding and configuring the "seo: ^0.0.10" package.
And implement it mainly in the landing page and maybe in the auth page as well... Tell the ai to heavly use web research to seek for how to use this package and example of people using and maybe even tips on the internet (in short, seek usefull resources) before writing any line of code

# Now, let's go to to web perfomance optimization
Google ranks better sites that load faster, so this is aligned with our goal of improving SEO

## I want to spawn one instance for minimizing dependencies
Should run the command:
```terminal
flutter pub deps --no-dev
```
And check if there is any dependency that is not used in any part

# I want to spawn one instance for adding deferred localization loading
Deferring the loading of the localization strings is a great use of this feature. For example, after implementing deferred loading of localization strings in Flutter Gallery, the app's initial JavaScript bundle size was cut in half.
```
# In your l10n.yaml
use-deferred-loading: true
```

# I want to spawn one instance for creating a HTML Splash Screen 
Flutter empowers you to build fully interactive landing pages for your app using plain HTML/CSS. While users engage with your landing page, flutter.js preloads your Flutter app — ensuring instant launches when the user navigates to the Flutter app. So ask this instance to ultrathink and use its web research tool capability to see the most beutiful uis that other people builded for initial page loading IN FLUTTER - see tips and tricks and ask in your prompt for this instance for it to not be lazy and see examples of outstanding ui's so we will greacefully make the loading experience less stressfull and only after that the ai should start changing the `web/index.html` (if possible try to stay in material 3 design-like). Also, ask ai to run flutter web to ensure the site continues to run after its changes and nothing is breaked.

I will talk later in this prompt that I want you to make a deploy with WASM and it said asked chat gpt if this html splash screen will work with wasm build and it said:
```chat_gpt_response
The HTML splash screen is just pure HTML/CSS that displays while Flutter initializes. It works identically whether your app compiles to JavaScript or WASM because:

It's rendered by the browser before Flutter even loads
The flutter-first-frame event fires regardless of the compilation target
Flutter's loader API works the same way for both JS and WASM
```

So it will work! So in your tests, run with the `wasm` flag to ensure everything worked

# I want to spawn one instance for adding Asset Preloading
We can achieve this by adding the files we want to preload inside the index.html in our project's web folder. As you can see, we managed to load those files in parallel at the beginning of the site loading and after main.dart.js was finished they were ready immediately. 

I will talk later in this prompt that I want you to make a deploy with WASM and it said asked chat gpt if this asset pre-loading strategy work with wasm build and it said:
```chat_gpt_response
Asset preloading is a browser-level feature (<link rel="preload">) that's completely independent of how Flutter compiles your Dart code. The browser just fetches files early — it doesn't care if your app runs via JavaScript or WASM.
However, the file names change with WASM builds, so adjust your preloads:
    ```html
    html<head>
      <!-- For WASM builds, preload the wasm files -->
      <link rel="preload" href="main.dart.wasm" as="fetch" crossorigin>
    
      <!-- skwasm renderer (used with --wasm flag) -->
      <link rel="preload" href="skwasm.wasm" as="fetch" crossorigin>
    
      <!-- Fonts and images work the same way -->
      <link rel="preload" href="./assets/fonts/Roboto-Regular.ttf" as="font" crossorigin>
    </head>
    ```

Tip: After building with flutter build web --wasm, check your build/web/ folder to see the exact file names generated, then update your preloads accordingly.
```

So it will work! So in your tests, run with the `wasm` flag to ensure everything worked

# I want to spawn one instance for deploying this site
I want to deploy my site. Currently, I am hosting my serverpod in scloud.
Guide in the prompt the claude code to pass to the instance the deploy documentation link of scloud at link "https://docs.serverpod.cloud/guides/deployment/deploying-your-application" but basicly you just need to run "scloud deploy" since everything is already configured and the cli is already logged in. Then, put a timer of 5 minutes and run "scloud deployment list" to see if the deployment had apear as finished (if not, should sleep more 5 minutes and try again... try this 4 times until its done). When deployed, open the site and see if there is any error in the console log and if there is any error ask that instance to spawn a other instance to fix that error...

## DEPLOY GUIDELINE: Use wasm
Use wasm to enhance perfomance. I already checked and the "seo" package works with web assembly sites.

## DEPLOY GUIDELINE: Use Tree Shaking + Icon Font Subsetting
```
flutter build web --release --tree-shake-icons
```

Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 7588 bytes (99.5% reduction). github
Impact: MaterialIcons alone goes from 1.6MB → ~7KB (99.5% reduction!)
Gotcha: If you use dynamic icons (like Icon(IconData(codePoint))), tree-shaking fails. Use const icons only:
```dart
dart// ✅ Good - can be tree-shaken
const Icon(Icons.home)

// ❌ Bad - prevents tree-shaking
Icon(IconData(someVariable))
```