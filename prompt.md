Build the ApiUsageView. Ultra think in this task.
This is a page that the user will be able to view information about the his api usage, mainly data of model @zenscrap_server/lib/src/entities/account/api_usage/account_api_usage.spy.yaml 

The user will be able to see both subscriptionCredits and purchasedCredits, such as his account nano id (let's call it accounnt id). There should be a listage of credit history "make a endpoint that will get the last 20 items" with a laod more button in the end of the listage.

Thereπ will also be a listage of his api keys in the page and a button to create more api keys that when pressed will open a dialog with a form so the user can type the name of the key.
Remember that api keys "apiKey" field are a composed string of nanoId + "::" + random uuid v7. Use as reference the creation of a "apiKey" in @zenscrap_server/lib/src/endpoints/private/private_account_endpoint.dart. Also, in that new endpoint there should be a option to delete a api key as well but either front end and back end should only allow this if there is more then 1 api key since that is the minimal. But in fact there will not be any real delection, you should create a new field in AccountApiKey called "isActive" and if the key is not active any more it will not apear for the user any more and in any history listage it will apear with a indicator that it is a old, not used key (remember to also verificate if a api key is valid in @zenscrap_server/lib/src/core/api_helper/api_helper_mixin.dart with a "where api key is active" filter ). This listage can be in a card.

IMPORANT:
If you need to generate serverpod files, use the command "serverpod generate --experimental-features=all". It need to have that flag because I am using some experimental-features... At the end of the task, double-check if there are any static analysis error...

Please follow the ui patterns of the other views - a material 3 like style - a Good ui is important. 

This is a complex ui since there will be 3 listages. Ultra think and build a great ui both for mobile screens and for desktop screen (maybe in mobile there could be tab navigation bar in the bottom and the items will be separated in tabs like general infos tab, api keys tab, transaction history tab, used count by api key, etc...)

Ultra think here, this is a complex task that will touch in backend and frontend.