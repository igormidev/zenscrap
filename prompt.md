@zenscrap_server/lib/src/endpoints/private/private_subscription_endpoint.dart @zenscrap_server/lib/src/webhooks/stripe_webhook.dart @zenscrap_flutter/lib/src/ui/dashboard/pages/pricing_page.dart @zenscrap_server/lib/src/entities/account/plan_tier.spy.yaml @zenscrap_server/lib/src/core/extension/plan_tier_extension.dart 

I what to create a subscription system for my app.
I have a stripe account and I need your help to configure it and make the implementation in the serverpod side.

So, I have this enum PlanTier that is attached to my user at AccoutInfo.
Note that AccountInfo also has the userInfo that is a model from serverpod where I can get the email. My plan is to make email a pre-fullfiled. So, in ZenScrapPricingPage in the flutter app the user will click a button that will call the PrivateSubscriptionEndpoint that will have a logic built by you to create a link for a purchase will a fullfiled email that cannot be changed and when the he subscribes to a plan I wan't the stripe to call the StripeWebhookRoute that will write the user with the correct role and will put him back if the subscription is canceled... Since the email will be fullfiled and not changable, we will be able to compare it with the email of the account in "userInfo: module:auth:UserInfo?, relation" of AccountInfo so we can identify who did the purchase.

Ps: I don't know what is the best way of identify the user, I suggested email but if you think there is a better way like AccountInfo id or something like that fell free to make that improvement. By the way, fell free to create new models in the account info related to stripe if you think is necessaary (maybe stripe id or something like that, I really don't now what is the best implementation so you should decide if it will be good to attach something stripe-related to the user model to use it later... I will offer the user to make purchases of credit tokens in the future, so maybe something related so stripe will need to be saved... not sure)

Bty, if you need to generate serverpod files, use the command "serverpod generate --experimental-features=all". It need to have that flag because I am using some experimental-features...

Guidelines: You should not use any type of package. Also, you SHOULD CHECK THE DOCUMENTATION of stripe with webresearch, mainly the part that talks about webhooks (https://docs.stripe.com/webhooks?utm_source=chatgpt.com). Do not forget to do that research before starting to build anything.

Ultra think in a good way to do that and take you time to get this correctly done...