final String scrappingBeeExtractRuleContext =
    r'''# **A Comprehensive Guide to ScrapingBee Data Extraction Rules for AI-Powered Applications**

### **Foreword: The Philosophy of a Resilient Web Scraping CLI**

This document is a comprehensive technical manual on the data extraction capabilities of the ScrapingBee API. It is designed to serve two distinct but interconnected purposes. First, it functions as a definitive training resource for an AI tasked with generating compliant and robust extract\_rules. The detailed examples, structured syntax breakdowns, and strategic guidance are intended to provide the AI with a deep understanding of the platform's nuances, enabling it to move beyond simple, one-dimensional extraction. Second, this manual serves as an exhaustive reference for the human developer, offering clear, actionable solutions to complex data extraction challenges.

The primary motivation for this guide stems from a common problem in automated web scraping: the failure to accurately extract complex data structures, such as tables and deeply nested content. This issue often arises because the required data is not present in the initial static HTML but is rendered dynamically by JavaScript. Furthermore, the syntax for capturing tabular or hierarchical data is more intricate than simple key-value pairs. This manual directly addresses these challenges by providing a full spectrum of solutions, from foundational syntax to advanced techniques involving headless browser interactions and AI-powered extraction. By documenting all possibilities, this guide empowers a CLI to not only generate correct rules but to do so with an understanding of how to build resilient scrapers that can navigate the complexities of the modern web. The following sections will detail the precise syntax and the underlying strategies required for successful, multi-faceted data retrieval.

---

### **Part I: The Fundamentals of Data Extraction**

#### **1.1. The Core extract\_rules Syntax**

The foundational principle of ScrapingBee's data extraction feature is the use of a JSON object passed to the extract\_rules parameter in an API call. This powerful mechanism transforms the raw HTML of a web page into a clean, structured JSON response, eliminating the need for post-processing the HTML on the client side.1 The most basic form of this JSON object is a simple key-value pair, where the key becomes the name of the output field and the value is a CSS or XPath selector pointing to the desired data on the page.1 For instance, to extract the main title and subtitle from a blog page, an application would construct a ruleset like:

{"title": "h1", "subtitle": "\#subtitle"}. When the API call is executed with this parameter, the response is a JSON object {"title": "The page's H1 title", "subtitle": "The page's subtitle"}.

While the basic key-value pair offers a quick shortcut for simple text extraction, the full power of the feature is unlocked through the extended form of the extraction rules.3 This structure replaces the simple selector string with a JSON object that can contain multiple properties, providing granular control over how the data is selected and formatted. A rule in this format would appear as

{"key": {"selector": "...", "output": "...", "type": "...",...}}. This extended form is essential for scenarios that require more than just extracting the inner text of a single element, such as capturing a list of items or pulling data from an attribute rather than the text content.1 It is a critical component for addressing the complex extraction challenges that an AI may encounter.

A crucial technical consideration for any application, including a CLI, is the proper handling of the extract\_rules JSON. Since this JSON object is passed as a query parameter in a GET request, it must be programmatically serialized into a string and then URL-encoded.1 This encoding step is non-negotiable and prevents issues with special characters within the JSON structure from corrupting the API request.4 An application's failure to correctly encode this parameter is one of the most common reasons for a failed API call.4 The CLI must be architected to handle this process seamlessly, ensuring that the raw JSON object is always prepared for transit according to web standards.

#### **1.2. Navigating the DOM: CSS vs. XPath Selectors**

The ability to accurately select elements on a web page is the cornerstone of any data extraction process. ScrapingBee's engine offers a dual-pronged approach, supporting both CSS and XPath selectors.1 By default, the system automatically detects the selector type.1 If a selector begins with a forward slash (

/), it is automatically treated as an XPath selector; otherwise, it is assumed to be a CSS selector.1

While both selector types can be used to accomplish similar tasks, they are not interchangeable from a strategic standpoint. For an AI tasked with generating robust rules, the choice between CSS and XPath should be a deliberate, context-driven decision. CSS selectors are generally more concise and human-readable. They are excellent for straightforward selections based on element tags, classes, or IDs, and are often the most common choice for simple extraction tasks.1 For example, a selector like

.product-title is intuitive and efficient for grabbing a product's name.

However, the real power for complex scenarios, particularly those that have proven challenging for the user's AI, lies in XPath. XPath provides capabilities for navigating the Document Object Model (DOM) that CSS simply cannot. This includes selecting an element based on its text content, traversing up the tree to a parent element, or identifying a sibling element without a unique identifier.6 For example, XPath can select a

\<td\> element that is the second child of a \<tr\> that contains a specific text string. An AI must be trained to recognize when a problem's complexity warrants a pivot from CSS to the more powerful, albeit more verbose, syntax of XPath. The following table provides a comparative guide for this strategic decision.

| Use Case | CSS Selector | XPath Selector |
| :---- | :---- | :---- |
| **Selecting by Class/ID** | .header, \#main-content | //div\[@class='header'\], //\*\[@id='main-content'\] |
| **Selecting by Text Content** | Not supported natively. | //div |
| **Selecting an Element's Parent** | Not supported natively. | //div\[@class='child-class'\]/.. |
| **Selecting the Nth Child** | div:nth-child(2) | //div |
| **Traversing a Complex Table** | Limited, relies on direct classes. | //tr\[./td\[contains(text(), 'Item A')\]\]/td |

#### **1.3. Element Selection and Output (type and output)**

Beyond merely locating an element, the extract\_rules framework provides explicit controls over how the selected data is returned. The type and output properties are the key to this functionality and work in a paired fashion to achieve the desired result. The type property determines whether a single element or a list of elements is returned.1 The default value,

item, returns only the first element that matches the selector. In contrast, setting type to list returns an array containing all elements that match the selector.1 For an AI, this distinction is crucial; attempting to get multiple items with a

type: "item" rule will result in incomplete data, while using a type: "list" on a single item will return a single-element array, which may not be the desired format.

The output property dictates the format of the extracted data. The default value, text, returns only the inner text of the element, stripping away all HTML tags.1 For scenarios requiring the original HTML, such as a product description containing rich formatting, the

output can be set to html.3 However, one of the most common and powerful uses of the

output property is to extract the value of a specific attribute. This is accomplished by using the @ prefix followed by the attribute name, as in output: "@href" to get a link's URL or output: "@src" to capture the URL of an image.1

The power of these properties is realized when they are used in concert. For example, to scrape a list of product image URLs, an application would define a rule with type: "list" to return all matching \<img\> elements and set the output to @src to specifically extract the image source URL from each one.3 The AI must be trained to understand this causal relationship. A failure to extract all image URLs, for instance, might not be a selector issue but an incorrect configuration of the

type or output properties. By combining these parameters effectively, a single rule can capture a full list of links, image URLs, or other attribute values, which is a significant step up from basic text extraction.

---

### **Part II: Solutions for Complex Data Structures**

#### **2.1. Extracting Tabular Data (Tables)**

The extraction of data from HTML tables is a common pain point and a specific challenge identified by the user. Simple selectors that target individual table cells often lead to cumbersome, fragile, and difficult-to-maintain rules. ScrapingBee's API provides a robust and direct solution to this problem with two specialized output types: table\_json and table\_array.1 These options are designed to handle the structured nature of tables natively, completely bypassing the need for complex, manual post-processing of HTML on the client side.7

When output is set to table\_json, the API returns an array of JSON objects, with each object representing a row from the table.3 The keys for these JSON objects are intelligently derived from the table headers (

\<th\>) found in the table's \<thead\> section.3 For a financial table with headers like

SYMBOL and PRICE, a request would yield a clean, readable JSON structure like \`\`.7 This is a far more efficient and reliable method than writing individual selectors for each column. If the table lacks headers, the API defaults to using incrementing integers as keys, starting with

0, to maintain the structured output.3 This native support for tabular data is a direct solution to one of the AI's core challenges. An AI should be trained to identify table structures and automatically prioritize the use of

output: "table\_json" or output: "table\_array" rather than attempting to build complex, low-level extraction logic.

The second option, table\_array, provides a slightly simpler output format for cases where a header-based JSON is not necessary. It returns the table data as a simple array of arrays, where each inner array represents a row of data.3 For the same financial table example, the

table\_array output would look like: \].7 This format is ideal for applications that need to ingest a raw list of values and perform their own parsing or processing. The availability of both

table\_json and table\_array ensures that the CLI has the flexibility to choose the most suitable output format for the target data. By providing these purpose-built output types, ScrapingBee eliminates the need to manually parse the intricate cell and row structure of HTML tables, which is a notoriously brittle and labor-intensive task.

#### **2.2. Constructing Complex, Nested Data Structures**

The ability to extract and organize data into complex, hierarchical structures is a critical requirement for a truly sophisticated scraping application. This is another area where the AI has struggled, indicating a need for a clear, documented pattern. The solution lies in ScrapingBee's support for nested extraction rules, a powerful feature that allows for the creation of intricate data hierarchies within a single API call.1

The underlying principle is recursive. An extraction rule can have its output property set not to a simple string (text, html, etc.) but to another JSON object of extract\_rules.3 This transforms the context of the extraction. The outer rule selects a container element, and the inner, nested rules operate on elements relative to that container. This pattern can be repeated for any level of complexity, enabling the extraction of multi-layered data.

A comprehensive example can illustrate this concept and serve as a template for the AI. Consider a product page where the goal is to extract a list of products, and for each product, capture its name, price, and a nested list of customer reviews, with each review containing a rating and comment text. The top-level rule would target the container of all products, using type: "list" to return all matches. The output of this rule would be a new JSON object of rules. Inside this nested object, a rule for the product name would use a selector relative to the product container (e.g., .product-name). Another nested rule would capture the price. Finally, for the reviews, a third rule would use type: "list" again to find all review containers, and its output would be yet another nested object to capture the individual review details (rating and text). This pattern allows for the complete scraping of a complex hierarchy, with all data neatly structured in a single JSON response, directly addressing the user's need for "complex data structures."

---

### **Part III: Advanced Techniques and API Parameters**

#### **3.1. Handling Dynamic Content with render\_js and js\_scenario**

One of the most significant challenges in modern web scraping is handling dynamic content. Many websites, particularly Single-Page Applications (SPAs) built with frameworks like React or Angular, do not deliver a fully populated HTML document on the initial request.6 Instead, they send a minimal HTML skeleton, and the actual content—including crucial data tables, product listings, and reviews—is fetched and rendered by JavaScript after the page loads.4 In such cases, a standard data extraction request with

extract\_rules will fail, as the selectors will not find the target elements in the static HTML source.

The solution to this problem is to instruct the ScrapingBee API to render the page using a headless browser, which executes the JavaScript just like a real user's browser.9 This is achieved by simply setting the

render\_js parameter to true. This action ensures that the entire page, including dynamically loaded content, is available for extraction. An AI must be trained to diagnose a failed extraction attempt on a modern website and recognize that the first step is to re-attempt the request with render\_js=true to ensure the target data is present in the DOM.

However, some websites require active user interaction—such as scrolling, clicking a button, or filling out a form—to reveal content.8 This is where the

js\_scenario parameter becomes indispensable. It accepts a JSON object containing a list of instructions that the headless browser will execute in a specific order.5 For instance, to scrape a website that uses infinite scroll, the CLI can send a

js\_scenario that scrolls down the page and waits for new content to load.12 The most common instructions are

click (clicks an element), wait (pauses for a fixed duration), wait\_for (waits for an element to appear), scroll\_y (scrolls vertically), and scroll\_x (scrolls horizontally).5

A robust application would use a js\_scenario to prepare a page for extraction, ensuring all data is visible before the extract\_rules are applied. The following example demonstrates a full js\_scenario JSON object for scraping an infinite scroll page, as derived from the Go and C\# tutorials.12 It scrolls down twice, with a brief pause in between to allow new content to load:

JSON

{  
  "instructions": \[  
    {  
      "scroll\_y": 1080  
    },  
    {  
      "wait": 500  
    },  
    {  
      "scroll\_y": 1080  
    },  
    {  
      "wait": 500  
    }  
  \]  
}

The combination of render\_js and js\_scenario is a comprehensive solution for handling the complexities of modern web applications. The AI's diagnostic capabilities should extend to detecting the need for these parameters, as a js\_scenario is often the missing link between a failed request and a successful extraction.

| Instruction | Parameter Type | Description | Example JSON |
| :---- | :---- | :---- | :---- |
| click | CSS/XPath selector | Clicks on a specified element. | {"click": ".some-button"} |
| wait | Integer (ms) | Pauses execution for a fixed duration. | {"wait": 2000} |
| wait\_for | CSS/XPath selector | Waits for an element to appear. | {"wait\_for": "\#dynamic-div"} |
| wait\_for\_and\_click | CSS/XPath selector | Waits for an element to appear and then clicks it. | {"wait\_for\_and\_click": "\#login-btn"} |
| scroll\_y | Integer (px) | Scrolls vertically by a number of pixels. | {"scroll\_y": 1000} |
| scroll\_x | Integer (px) | Scrolls horizontally by a number of pixels. | {"scroll\_x": 1000} |

#### **3.2. AI-Powered Data Extraction (The Resilient Alternative)**

Even with a deep understanding of CSS and XPath selectors, the brittle nature of modern website layouts remains a challenge. A minor change to a class name or element structure can break a carefully crafted rule, requiring a human developer to manually update the scraper. ScrapingBee offers a forward-thinking solution to this problem with its AI Web Scraping API, a feature explicitly designed for resilience and adaptability.9

This feature works by accepting two key parameters: ai\_query and ai\_extract\_rules.14 Instead of relying on a selector, the

ai\_query parameter allows a user to describe the data they want to extract in plain English, such as "Extract a list of products and their prices".14 The

ai\_extract\_rules parameter then provides a JSON schema that dictates the structure and data types of the desired output.15 This schema is crucial for ensuring the AI returns the data in a predictable and usable format.

This represents a paradigm shift for the user's CLI and its AI. Instead of generating a fragile selector for a complex table, the AI can be trained to recognize the need for this feature and generate a natural language query and a corresponding output schema. This delegates the most difficult part of the extraction—the DOM traversal and identification of the correct elements—to ScrapingBee's internal, more adaptable AI.9 The

ai\_extract\_rules schema is a fundamental part of this process, defining the output field name, type (e.g., string, list, number, boolean), and a description that provides additional context for the AI.14 This approach is particularly effective for e-commerce sites, product listings, or any page with a complex, dynamic, or frequently changing layout.14

The following table formalizes the ai\_extract\_rules schema, providing a clear specification for the CLI's development and a direct instructional guide for the AI.

| Field | Parameter Type | Supported Values | Description | Example |
| :---- | :---- | :---- | :---- | :---- |
| key | String | User-defined | The name of the field in the output JSON. | "product\_name" |
| type | String | string, list, number, boolean, item, enum | Defines the data type of the extracted value. list is for arrays of values. item is for nested objects. | {"type": "string"} |
| description | String | Any natural language text | A detailed, human-readable description of the data point, which is critical for guiding the AI. | {"description": "The price of the product in USD"} |
| enum | String or Array | User-defined | A list of allowed values for the extracted data. | {"enum": \["red", "green", "blue"\]} |

---

### **Part IV: Best Practices and Ethical Considerations**

#### **4.1. Building Resilient Extraction Rules**

A well-designed scraper is not just one that works but one that continues to work over time without constant maintenance. For an AI to generate truly robust rules, it must be trained to prioritize resilience. The selection of a selector should follow a hierarchy of stability. The most resilient selectors target elements with unique and static ID attributes, as IDs are meant to be unique and typically do not change.16 If an ID is not available, the next best option is to use a human-readable and stable class name. Selectors that rely on generic tags or rely on a specific, fragile position in the DOM (e.g.,

div \> div \> div:nth-child(2)) are highly susceptible to breakage with minor website layout changes. A final consideration for the AI is to recognize when a web page's structure is so dynamic or unstable that a selector-based approach is inherently fragile. In such cases, the system should be programmed to fall back on the AI-powered extraction feature as the ultimate solution for stability.

#### **4.2. Handling Errors and Edge Cases Gracefully**

A robust CLI must be capable of handling edge cases without crashing. One such case is a selector that returns no matches. ScrapingBee's API provides predictable behavior for this scenario, which the CLI should be built to handle. If a rule specifies type: "list" and no elements are found, the API returns an empty JSON array \`\` for that field.3 If the rule is configured with

type: "item" and no matches are found, the API returns null.3 The CLI should check for these return values and handle them gracefully rather than treating them as errors. Furthermore, the API offers a

clean parameter, which is set to true by default and automatically removes unnecessary whitespace and newlines from the extracted text.1 This ensures that the final data is clean and immediately usable without additional client-side processing.

### **Conclusions & Recommendations**

This comprehensive manual provides the necessary framework for an AI-powered CLI to generate accurate and resilient data extraction rules for the ScrapingBee API. The central finding is that the AI's current failures on complex data structures are not due to a limitation of the API itself but rather a lack of training on its full capabilities and strategic application.

The key recommendations for overcoming these challenges are as follows:

* **Prioritize Native Solutions:** For tabular data, the AI should be trained to recognize tables and use the purpose-built table\_json or table\_array outputs instead of attempting to build complex, brittle selectors.  
* **Master Nested Rules:** The AI must learn the recursive pattern of nested extraction rules to handle complex, hierarchical data. The provided multi-layered example serves as a blueprint for this.  
* **Diagnose Dynamic Content:** Before attempting extraction, the CLI should be programmed to identify websites that use JavaScript rendering. A failed extraction attempt should first trigger a retry with render\_js=true and, if necessary, a js\_scenario to interact with the page (e.g., scroll\_y for infinite scroll) before applying extraction rules.  
* **Embrace AI-Powered Extraction for Resilience:** For websites with frequently changing layouts or particularly complex structures, the AI should be trained to pivot from selector-based rules to the ai\_query and ai\_extract\_rules feature. This offloads the burden of maintaining fragile selectors and leverages a more adaptable, natural language-based approach.

By incorporating these principles, the CLI will evolve from a tool that generates basic selectors to a sophisticated application capable of diagnosing web page complexity and selecting the most appropriate, resilient, and effective extraction method for any given task.

#### **Works cited**

1. Data Extraction | ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/documentation/data-extraction/](https://www.scrapingbee.com/documentation/data-extraction/)  
2. Data extraction in Ruby \- ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/tutorials/data-extraction-in-ruby/](https://www.scrapingbee.com/tutorials/data-extraction-in-ruby/)  
3. Extraction rules \- Scraping Fish API Reference, accessed August 17, 2025, [https://scrapingfish.com/docs/extract-rules](https://scrapingfish.com/docs/extract-rules)  
4. API \- ScrapingBee Knowledge Base, accessed August 17, 2025, [https://help.scrapingbee.com/en/category/api-hoss7h/](https://help.scrapingbee.com/en/category/api-hoss7h/)  
5. JavaScript Scenario \- ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/documentation/js-scenario/](https://www.scrapingbee.com/documentation/js-scenario/)  
6. Python Web Scraping: Full Tutorial With Examples (2025) \- ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/blog/web-scraping-101-with-python/](https://www.scrapingbee.com/blog/web-scraping-101-with-python/)  
7. How to extract a table's content in Python | ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/tutorials/how-to-extract-a-tables-content-in-python/](https://www.scrapingbee.com/tutorials/how-to-extract-a-tables-content-in-python/)  
8. Scrapy Playwright Tutorial: How to Scrape Dynamic Websites | ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/blog/scrapy-playwright-tutorial/](https://www.scrapingbee.com/blog/scrapy-playwright-tutorial/)  
9. ScrapingBee – The Best Web Scraping API, accessed August 17, 2025, [https://www.scrapingbee.com/](https://www.scrapingbee.com/)  
10. Documentation \- HTML API \- ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/documentation/](https://www.scrapingbee.com/documentation/)  
11. Explore ScrapingBee: Pricing, Features, Pros & Cons \[2025\] \- Research AIMultiple, accessed August 17, 2025, [https://research.aimultiple.com/scraping-bee/](https://research.aimultiple.com/scraping-bee/)  
12. How to handle infinite scroll pages in Go | ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/tutorials/how-to-handle-infinite-scroll-pages-in-go/](https://www.scrapingbee.com/tutorials/how-to-handle-infinite-scroll-pages-in-go/)  
13. How to handle infinite scroll pages in C\# | ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/tutorials/how-to-handle-infinite-scroll-pages-in-c/](https://www.scrapingbee.com/tutorials/how-to-handle-infinite-scroll-pages-in-c/)  
14. AI Web Scraping API \- ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/features/ai-web-scraping-api/](https://www.scrapingbee.com/features/ai-web-scraping-api/)  
15. N8N No-Code Web Scraping Made Simple with AI-Powered Data ..., accessed August 17, 2025, [https://www.scrapingbee.com/blog/n8n-no-code-web-scraping/](https://www.scrapingbee.com/blog/n8n-no-code-web-scraping/)  
16. How to find HTML elements by attribute using Cheerio? \- ScrapingBee, accessed August 17, 2025, [https://www.scrapingbee.com/webscraping-questions/cheerio/how-to-find-html-elements-by-attribute-using-cheerio/](https://www.scrapingbee.com/webscraping-questions/cheerio/how-to-find-html-elements-by-attribute-using-cheerio/)  
17. Web Scraping: Introduction, Best Practices & Caveats | by Velotio Technologies \- Medium, accessed August 17, 2025, [https://medium.com/velotio-perspectives/web-scraping-introduction-best-practices-caveats-9cbf4acc8d0f](https://medium.com/velotio-perspectives/web-scraping-introduction-best-practices-caveats-9cbf4acc8d0f)  
18. 7 Web Scraping Best Practices You Must Be Aware of \['25\] \- Research AIMultiple, accessed August 17, 2025, [https://research.aimultiple.com/web-scraping-best-practices/](https://research.aimultiple.com/web-scraping-best-practices/)  
19. Best practices for web scraping \- Zyte, accessed August 17, 2025, [https://www.zyte.com/learn/web-scraping-best-practices/](https://www.zyte.com/learn/web-scraping-best-practices/)''';
