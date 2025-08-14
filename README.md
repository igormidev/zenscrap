Example of how could work state

abstract: ChatResponse
sealed: true

class: EditedReferenceData
extends: ChatResponse
fields:
    currentReferenceTestData: ReferenceTestData


### Prompt
class: PromptAiErrorResponse
extends: ChatResponse
fields:
    aiGeneratedErrorMessage: String

class: PromptAiOnlyTextResponse
extends: ChatResponse
fields:
    aiGeneratedTextMessage: String

class: PromptAiTextAndNewExtractRulesResponse
extends: ChatResponse
fields:
    aiGeneratedTextMessage: String
    newExtractRules: String

class: PromptZenScrapSystemResponse
extends: ChatResponse
fields:
    automaticSystemTextMessage: String

### Extra
class: ReferenceTestData
fields:
    referenceHtmlPage: String
    referenceLink: String
    referenceQueryParametersJson: String
    extractedRulesUsed: String