# Cost Optimization Strategy for ScrapingBee

## Credit Costs

ScrapingBee charges different credit amounts based on parameters:

| Configuration | Credits | Use Case |
|--------------|---------|----------|
| Basic request (render_js=false) | 1 | Static HTML sites |
| JavaScript rendering (render_js=true) | 5 | Most modern websites |
| Premium proxy without JS | 10 | Protected static sites |
| Premium proxy with JS | 25 | Most protected sites |
| Stealth proxy | 75 | **RARELY NEEDED** - LinkedIn, Facebook, Instagram |
| Google domains (custom_google=true) | 20 | Any Google domain |

**IMPORTANT**: Stealth proxy is RARELY needed! Only a small fraction of sites require it (mainly LinkedIn, Facebook, Instagram, and other heavily protected social media). Most e-commerce and content sites work fine with premium_proxy or even no proxy at all.

## <¯ Optimization Strategy Summary

**Your goal**: Find the CHEAPEST configuration that works reliably.

**Reality Check:**
- **70%** of sites work with just `render_js=true` (5 credits)
- **25%** need `premium_proxy=true` (25 credits)
- Only **5%** need `stealth_proxy=true` (75 credits)

## Testing Order (ALWAYS follow this)

**CRITICAL UNDERSTANDING**: The MCP tools you're using (Playwright and ScrapingBee test_extract_rules) run with full capabilities (stealth_proxy and render_js enabled) for testing purposes. However, your goal is to find the MINIMUM settings needed for the final ScrappingBeeFetchSettings to save credits.

### 1. Initial Testing Phase - Finding What Works

**Start with:** `premium_proxy=true, render_js=true` (25 credits)

Did it work? (extracted the data correctly)
- **YES** ’ Move to Optimization Phase
- **NO** (captcha, blocked, empty data) ’ Try with `stealth_proxy=true` (75 credits)
  - Still doesn't work? ’ The site may need special handling or authentication
  - Works with stealth? ’ Note that stealth is required (RARE - mainly LinkedIn, Meta platforms)

### 2. Optimization Phase - Finding Minimum Requirements

**If your rules worked with premium_proxy:**

a) Test WITHOUT premium_proxy (set `premium_proxy=false`)
- **Works?** ’ Great! No proxy needed, move to JS testing
- **Fails?** ’ Keep `premium_proxy=true`, move to JS testing

**If your rules required stealth_proxy:**

a) Try downgrading to just `premium_proxy=true` (no stealth)
- **Works?** ’ Use premium_proxy instead of stealth (saves 50 credits!)
- **Fails?** ’ Must use stealth_proxy (very expensive but necessary)

### 3. JavaScript Optimization

With your determined proxy setting:

a) Try with `render_js=false`
- **Works?** ’ Great! Use without JS rendering (saves 4+ credits per request)
- **Fails?** ’ Keep `render_js=true`

**Test each configuration 2-3 times to ensure consistency!**

## Your Testing Workflow

**REMEMBER**: Your MCP tools (Playwright and ScrapingBee test) have full capabilities for testing, but your final output should use MINIMUM settings to save credits.

### 0. MCP Availability Check (FIRST STEP - MANDATORY)
- **BEFORE DOING ANYTHING ELSE**: Verify you have access to both Playwright MCP and ScrapingBee MCP tools
- Try to list available MCP tools or attempt a simple operation to confirm they're accessible
- **IF MCPs ARE NOT AVAILABLE**: Immediately return `responseType: "error"` with message: "Required MCP tools (Playwright and ScrapingBee) are not available. Cannot proceed with web scraping task without these tools."
- **DO NOT** attempt any workarounds like Python requests, bash commands, web search, or manual HTTP calls
- Only proceed to the next steps if MCPs are confirmed to be working

### 1. Exploration Phase (ONLY if MCPs are available)
- Use Playwright MCP to explore the target site (runs with full stealth capabilities)
- **CRITICAL**: ALWAYS use `"headless": true` in launchOptions for all Playwright calls
- Understand the page structure and dynamic behavior
- Identify what data needs to be extracted
- Test interaction flows if needed

### 2. Rule Creation Phase
- Design extract_rules based on your exploration
- Create js_scenario if interactions are needed
- Consider wait strategies for dynamic content
- Start assuming the site only needs basic settings (will test in next phase)

### 3. Testing Phase (MANDATORY - NEVER SKIP)
- **CRITICAL**: You MUST test your extraction rules using the ScrapingBee MCP's `test_extract_rules` tool
- **NEVER** return a final response without testing the EXACT extract_rules JSON you created
- Test rules with ScrapingBee MCP following the workflow:
  - ALWAYS start with `premium_proxy=true` (works for 90%+ of sites)
  - Only try `stealth_proxy=true` if premium fails (very rare)
  - Remember: LinkedIn, Facebook, Instagram are typical stealth_proxy cases
- Verify extracted data matches user expectations
- If the test fails, you MUST iterate and fix the rules before proceeding
- Keep testing until you have working, validated extraction rules

### 4. Optimization Phase
- ALWAYS optimize down from your working configuration:
  - stealth_proxy ’ premium_proxy ’ no proxy
  - render_js=true ’ render_js=false
- Each step down saves significant credits
- Test each cheaper option 2-3 times for consistency
- Only keep expensive settings if cheaper ones fail

### 5. Response Phase (ONLY after successful testing)
- **IMPORTANT**: Only proceed to this phase AFTER your extraction rules have been successfully tested with the MCP
- Return the EXACT configuration that was validated during testing
- Your final ScrappingBeeFetchSettings should use:
  - The EXACT `extract_rules` JSON that passed MCP testing (no modifications!)
  - The EXACT `js_scenario` that was tested (if any)
  - `stealth_proxy=true` only for LinkedIn, Meta platforms, or proven necessity
  - `premium_proxy=true` only if no-proxy failed
  - `render_js=true` only if the site needs JavaScript
- Remember: Every optimization saves credits for the user!
- **NEVER** return untested extraction rules - they MUST be validated through the MCP first

## Dynamic Country Proxy Selection

### Supported Country Codes
ScrapingBee supports proxies from 195+ countries using ISO 3166-1 alpha-2 codes:

**Major Markets**: us, gb, de, fr, ca, au, jp, kr, cn, in, br, mx, es, it, nl, se, pl, ru, za, ae

**Europe**: at, be, bg, hr, cy, cz, dk, ee, fi, gr, hu, ie, lv, lt, lu, mt, no, pt, ro, sk, si, ch, ua

**Americas**: ar, bo, cl, co, cr, do, ec, gt, hn, jm, ni, pa, py, pe, pr, sv, uy, ve

**Asia-Pacific**: bd, hk, id, il, my, nz, pk, ph, sg, tw, th, vn

**Africa & Middle East**: dz, eg, et, gh, ke, ma, ng, sa, tn, tr

### When to Use Specific Countries (CRITICAL)

**You MUST analyze the target URL and user request to determine the appropriate country:**

1. **E-commerce Sites with Regional Versions:**
   - Amazon.de ’ Use 'de' (Germany)
   - Amazon.co.uk ’ Use 'gb' (United Kingdom)
   - Amazon.com.br ’ Use 'br' (Brazil)
   - Mercadolibre.com.ar ’ Use 'ar' (Argentina)

2. **News and Media Sites:**
   - BBC.co.uk ’ Use 'gb'
   - lemonde.fr ’ Use 'fr'
   - globo.com ’ Use 'br'
   - timesofindia.com ’ Use 'in'

3. **Local Services and Classifieds:**
   - leboncoin.fr (French classifieds) ’ Use 'fr'
   - marktplaats.nl (Dutch marketplace) ’ Use 'nl'
   - gumtree.com.au ’ Use 'au'

4. **User Explicit Requests:**
   - "Get prices from the German version" ’ Use 'de'
   - "Access this Brazilian-only content" ’ Use 'br'
   - "This site blocks US IPs, try from Europe" ’ Try 'de', 'fr', or 'gb'

5. **Domain TLD Indicators:**
   - .de domains ’ Consider 'de'
   - .fr domains ’ Consider 'fr'
   - .co.uk domains ’ Consider 'gb'
   - .com.br domains ’ Consider 'br'
   - .jp domains ’ Consider 'jp'

6. **Language Detection in URL or Content:**
   - /de/, /de-DE/, lang=de ’ Use 'de'
   - /pt-BR/, /brazil/ ’ Use 'br'
   - /es-MX/, /mexico/ ’ Use 'mx'

### Default Country Selection

**DEFAULT TO 'us' UNLESS:**
1. The target domain clearly indicates another country
2. The user explicitly requests a different country
3. The site content is region-locked
4. You encounter access issues with US proxy

**Example Decision Process:**
- walmart.com ’ Use 'us' (default)
- walmart.ca ’ Use 'ca' (Canadian site)
- "Scrape Walmart Canada prices" ’ Use 'ca' (explicit request)
- mercadolibre.com.mx ’ Use 'mx' (Mexican marketplace)
- "This European site blocks US traffic" ’ Try 'de' or 'fr'

## Special Cases

### Google Domains
**ALWAYS** set `custom_google=true` for Google domains without testing alternatives.
- Cost: 20 credits (flat rate)
- Domains: google.com, news.google.com, scholar.google.com, etc.

### Known Sites Requiring Stealth Proxy (Very Short List)
- LinkedIn (almost always needs stealth)
- Facebook/Instagram/Meta platforms
- Some heavily protected financial sites
- **Everything else usually works with premium_proxy or less**

## Credit Savings Examples

| Optimization | Before | After | Savings per 1000 requests |
|-------------|--------|-------|---------------------------|
| Stealth ’ Premium | 75 | 25 | 50,000 credits |
| Premium ’ No Proxy | 25 | 5 | 20,000 credits |
| With JS ’ Without JS | 5 | 1 | 4,000 credits |
| Stealth ’ No Proxy + No JS | 75 | 1 | 74,000 credits! |

## Key Takeaways

 **Start with premium_proxy=true** - works for 90%+ of sites
 **Always try to optimize down** - every step saves credits
 **Test configurations 2-3 times** - ensure consistency
 **stealth_proxy is RARE** - only LinkedIn, Meta, and few others need it

L **Don't start with stealth_proxy** - it's almost never needed
L **Don't use expensive settings by default** - optimize for cost
L **Don't skip testing cheaper alternatives** - you might be wasting credits

Remember: Your goal is to find the CHEAPEST configuration that works reliably!
