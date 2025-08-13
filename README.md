Example of how could work state

abstract: ZenScrapRedraftState
sealed: true

class: EditedReferenceData
extends: ZenScrapRedraftState
fields:
    currentReferenceTestData: ReferenceTestData


### Prompt
class: PromptAiErrorResponse
extends: ZenScrapRedraftState
fields:
    aiGeneratedErrorMessage: String

class: PromptAiOnlyTextResponse
extends: ZenScrapRedraftState
fields:
    aiGeneratedTextMessage: String

class: PromptAiTextAndNewExtractRulesResponse
extends: ZenScrapRedraftState
fields:
    aiGeneratedTextMessage: String
    newExtractRules: String

class: PromptZenScrapSystemResponse
extends: ZenScrapRedraftState
fields:
    automaticSystemTextMessage: String

### Extra
class: ReferenceTestData
fields:
    referenceHtmlPage: String
    referenceLink: String
    referenceQueryParametersJson: String
    extractedRulesUsed: String