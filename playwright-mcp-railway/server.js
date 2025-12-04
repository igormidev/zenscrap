import http from 'http';
import { chromium } from 'playwright';

const PORT = process.env.PORT || 8931;

/**
 * Parse Playwright error to extract detailed information
 * @param {Error} error - The Playwright error
 * @param {string} operation - What operation was being performed
 * @param {object} context - Additional context (selector, url, etc.)
 * @returns {object} Structured error information
 */
function parsePlaywrightError(error, operation, context = {}) {
  const errorInfo = {
    error: error.message || String(error),
    errorType: error.name || 'Error',
    operation,
    timestamp: new Date().toISOString(),
    context,
    possibleCauses: [],
    suggestions: []
  };

  // Add stack trace (truncated)
  if (error.stack) {
    errorInfo.stackTrace = error.stack.split('\n').slice(0, 5).join('\n');
  }

  const message = error.message?.toLowerCase() || '';

  // Categorize based on error type and message
  if (message.includes('timeout') || error.name === 'TimeoutError') {
    errorInfo.errorCategory = 'TIMEOUT';
    errorInfo.possibleCauses = [
      'Page took too long to load',
      'Element did not appear within timeout period',
      'Network request was too slow',
      'ScrapingBee proxy may have timed out'
    ];
    errorInfo.suggestions = [
      'Increase timeout value',
      'Check if selector is correct',
      'Try with a different wait strategy',
      'Verify the page loads correctly'
    ];
  } else if (message.includes('net::') || message.includes('failed to fetch') || message.includes('econnrefused')) {
    errorInfo.errorCategory = 'NETWORK';
    errorInfo.possibleCauses = [
      'Network connection failed',
      'Target site is unreachable',
      'DNS resolution failed',
      'ScrapingBee proxy connection issue'
    ];
    errorInfo.suggestions = [
      'Check if the URL is correct and accessible',
      'Verify network connectivity',
      'Try again after a short delay',
      'Check ScrapingBee proxy configuration'
    ];
  } else if (message.includes('selector') || message.includes('element') || message.includes('locator')) {
    errorInfo.errorCategory = 'SELECTOR';
    errorInfo.possibleCauses = [
      'Element not found on page',
      'Selector syntax is invalid',
      'Element was removed from DOM',
      'Element is hidden or not interactable'
    ];
    errorInfo.suggestions = [
      'Verify the selector exists on the page',
      'Use browser snapshot to inspect current DOM',
      'Wait for element to appear first',
      'Try a different selector strategy'
    ];
  } else if (message.includes('navigation') || message.includes('goto') || message.includes('page')) {
    errorInfo.errorCategory = 'NAVIGATION';
    errorInfo.possibleCauses = [
      'Page navigation failed',
      'URL is invalid or blocked',
      'Page crashed during load',
      'Authentication or access denied'
    ];
    errorInfo.suggestions = [
      'Verify the URL is correct',
      'Check if the site blocks automated browsers',
      'Try with premium_proxy enabled',
      'Increase navigation timeout'
    ];
  } else if (message.includes('browser') || message.includes('context') || message.includes('launch')) {
    errorInfo.errorCategory = 'BROWSER';
    errorInfo.possibleCauses = [
      'Browser failed to launch',
      'Browser context creation failed',
      'Browser crashed',
      'Resource limits exceeded'
    ];
    errorInfo.suggestions = [
      'Restart the server',
      'Check server resource usage',
      'Verify browser is installed',
      'Check proxy configuration'
    ];
  } else if (message.includes('permission') || message.includes('access') || message.includes('blocked')) {
    errorInfo.errorCategory = 'ACCESS';
    errorInfo.possibleCauses = [
      'Access to resource denied',
      'Site is blocking automated browsers',
      'Geographic restriction',
      'Rate limiting'
    ];
    errorInfo.suggestions = [
      'Try with premium_proxy or stealth_proxy',
      'Add delays between requests',
      'Use a different country_code'
    ];
  } else if (message.includes('protocol') || message.includes('target closed')) {
    errorInfo.errorCategory = 'PROTOCOL';
    errorInfo.possibleCauses = [
      'Browser connection was lost',
      'Page was closed unexpectedly',
      'Browser process died'
    ];
    errorInfo.suggestions = [
      'Retry the operation',
      'Restart navigation from the beginning',
      'Check for page crashes'
    ];
  } else {
    errorInfo.errorCategory = 'UNKNOWN';
    errorInfo.possibleCauses = ['An unexpected error occurred'];
    errorInfo.suggestions = [
      'Check the error message for details',
      'Review the stack trace',
      'Try the operation again'
    ];
  }

  return errorInfo;
}

/**
 * Create a detailed error response for MCP tool calls
 */
function createMcpErrorResponse(error, operation, context = {}) {
  const parsedError = parsePlaywrightError(error, operation, context);

  return {
    content: [{
      type: 'text',
      text: JSON.stringify({
        success: false,
        ...parsedError
      }, null, 2)
    }],
    isError: true
  };
}

// ScrapingBee proxy configuration
const SCRAPINGBEE_API_KEY = process.env.SCRAPINGBEE_API_KEY || '37N8150Q1JBVN85NS4RUOUIUYZ2AEUFX69QBM0X74VD13M9TLNRVOFWS7HZMKRG1X4SOH4BKJT5EUN6K';
const SCRAPINGBEE_PROXY_PARAMS = process.env.SCRAPINGBEE_PROXY_PARAMS || 'render_js=true&premium_proxy=true';

const proxyConfig = {
  server: 'http://proxy.scrapingbee.com:8886',
  username: SCRAPINGBEE_API_KEY,
  password: SCRAPINGBEE_PROXY_PARAMS
};

// Browser and page management
let browser = null;
let page = null;

async function getBrowser() {
  if (!browser) {
    console.log('Launching browser with ScrapingBee proxy...');
    browser = await chromium.launch({
      headless: true,
      proxy: proxyConfig,
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu'
      ]
    });
  }
  return browser;
}

async function getPage() {
  if (!page || page.isClosed()) {
    const browserInstance = await getBrowser();
    const context = await browserInstance.newContext({
      viewport: { width: 1280, height: 720 },
      ignoreHTTPSErrors: true  // Required for ScrapingBee proxy
    });
    page = await context.newPage();
  }
  return page;
}

// MCP Protocol version
const PROTOCOL_VERSION = '2024-11-05';

// Server info
const SERVER_INFO = {
  name: 'playwright-scrapingbee',
  version: '1.1.0'
};

// Define MCP tools
const tools = [
  {
    name: 'browser_navigate',
    description: 'Navigate to a URL in the browser',
    inputSchema: {
      type: 'object',
      properties: {
        url: { type: 'string', description: 'The URL to navigate to' }
      },
      required: ['url']
    }
  },
  {
    name: 'browser_snapshot',
    description: 'Get the current page accessibility snapshot (DOM structure)',
    inputSchema: {
      type: 'object',
      properties: {}
    }
  },
  {
    name: 'browser_click',
    description: 'Click on an element by selector',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string', description: 'CSS selector of the element to click' }
      },
      required: ['selector']
    }
  },
  {
    name: 'browser_type',
    description: 'Type text into an input element',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string', description: 'CSS selector of the input element' },
        text: { type: 'string', description: 'Text to type' }
      },
      required: ['selector', 'text']
    }
  },
  {
    name: 'browser_screenshot',
    description: 'Take a screenshot of the current page',
    inputSchema: {
      type: 'object',
      properties: {
        fullPage: { type: 'boolean', description: 'Whether to take a full page screenshot' }
      }
    }
  },
  {
    name: 'browser_evaluate',
    description: 'Execute JavaScript in the browser context',
    inputSchema: {
      type: 'object',
      properties: {
        script: { type: 'string', description: 'JavaScript code to execute' }
      },
      required: ['script']
    }
  },
  {
    name: 'browser_get_html',
    description: 'Get the HTML content of the current page or an element',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string', description: 'Optional CSS selector to get HTML of specific element' }
      }
    }
  },
  {
    name: 'browser_wait_for',
    description: 'Wait for a selector to appear on the page',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string', description: 'CSS selector to wait for' },
        timeout: { type: 'number', description: 'Timeout in milliseconds (default: 30000)' }
      },
      required: ['selector']
    }
  }
];

// Tool handler with detailed error handling
async function handleToolCall(name, args) {
  console.log(`[Playwright] Tool call: ${name}`, JSON.stringify(args || {}).substring(0, 200));

  let currentPage;
  try {
    currentPage = await getPage();
  } catch (error) {
    console.error('[Playwright] Failed to get page:', error.message);
    throw Object.assign(new Error(`Browser initialization failed: ${error.message}`), {
      errorCategory: 'BROWSER',
      operation: name,
      suggestions: ['Check if browser is installed', 'Verify proxy configuration', 'Try restarting the server']
    });
  }

  switch (name) {
    case 'browser_navigate': {
      if (!args.url) {
        throw Object.assign(new Error('Missing required parameter: url'), {
          errorCategory: 'VALIDATION',
          operation: name,
          suggestions: ['Provide a valid URL to navigate to']
        });
      }
      try {
        console.log(`[Playwright] Navigating to: ${args.url}`);
        await currentPage.goto(args.url, { waitUntil: 'domcontentloaded', timeout: 60000 });
        const title = await currentPage.title();
        const currentUrl = currentPage.url();
        return [{
          type: 'text',
          text: JSON.stringify({
            success: true,
            message: `Navigated to ${args.url}`,
            pageTitle: title,
            currentUrl,
            originalUrl: args.url
          }, null, 2)
        }];
      } catch (error) {
        console.error(`[Playwright] Navigation error:`, error.message);
        throw Object.assign(error, { operation: name, context: { url: args.url } });
      }
    }

    case 'browser_snapshot': {
      try {
        const snapshot = await currentPage.accessibility.snapshot();
        const url = currentPage.url();
        if (!snapshot) {
          return [{
            type: 'text',
            text: JSON.stringify({
              success: false,
              warning: 'Snapshot returned null - page may not have accessible content',
              currentUrl: url,
              suggestions: ['Try navigating to a page first', 'Wait for page to fully load']
            }, null, 2)
          }];
        }
        return [{
          type: 'text',
          text: JSON.stringify({
            success: true,
            currentUrl: url,
            snapshot
          }, null, 2)
        }];
      } catch (error) {
        console.error(`[Playwright] Snapshot error:`, error.message);
        throw Object.assign(error, { operation: name, context: { url: currentPage.url() } });
      }
    }

    case 'browser_click': {
      if (!args.selector) {
        throw Object.assign(new Error('Missing required parameter: selector'), {
          errorCategory: 'VALIDATION',
          operation: name,
          suggestions: ['Provide a CSS selector of the element to click']
        });
      }
      try {
        console.log(`[Playwright] Clicking: ${args.selector}`);
        await currentPage.click(args.selector, { timeout: 30000 });
        return [{
          type: 'text',
          text: JSON.stringify({
            success: true,
            message: `Clicked on ${args.selector}`,
            selector: args.selector
          }, null, 2)
        }];
      } catch (error) {
        console.error(`[Playwright] Click error:`, error.message);
        throw Object.assign(error, { operation: name, context: { selector: args.selector } });
      }
    }

    case 'browser_type': {
      if (!args.selector || !args.text) {
        const missing = [];
        if (!args.selector) missing.push('selector');
        if (!args.text) missing.push('text');
        throw Object.assign(new Error(`Missing required parameters: ${missing.join(', ')}`), {
          errorCategory: 'VALIDATION',
          operation: name,
          suggestions: ['Provide selector for input element', 'Provide text to type']
        });
      }
      try {
        console.log(`[Playwright] Typing into: ${args.selector}`);
        await currentPage.fill(args.selector, args.text, { timeout: 30000 });
        return [{
          type: 'text',
          text: JSON.stringify({
            success: true,
            message: `Typed "${args.text}" into ${args.selector}`,
            selector: args.selector,
            textLength: args.text.length
          }, null, 2)
        }];
      } catch (error) {
        console.error(`[Playwright] Type error:`, error.message);
        throw Object.assign(error, { operation: name, context: { selector: args.selector } });
      }
    }

    case 'browser_screenshot': {
      try {
        console.log(`[Playwright] Taking screenshot (fullPage: ${args.fullPage || false})`);
        const buffer = await currentPage.screenshot({ fullPage: args.fullPage || false, timeout: 30000 });
        const base64 = buffer.toString('base64');
        const url = currentPage.url();
        return [
          {
            type: 'text',
            text: JSON.stringify({
              success: true,
              message: 'Screenshot captured',
              currentUrl: url,
              fullPage: args.fullPage || false,
              imageSize: base64.length
            }, null, 2)
          },
          { type: 'image', data: base64, mimeType: 'image/png' }
        ];
      } catch (error) {
        console.error(`[Playwright] Screenshot error:`, error.message);
        throw Object.assign(error, { operation: name, context: { fullPage: args.fullPage } });
      }
    }

    case 'browser_evaluate': {
      if (!args.script) {
        throw Object.assign(new Error('Missing required parameter: script'), {
          errorCategory: 'VALIDATION',
          operation: name,
          suggestions: ['Provide JavaScript code to execute']
        });
      }
      try {
        console.log(`[Playwright] Evaluating script: ${args.script.substring(0, 100)}...`);
        const result = await currentPage.evaluate(args.script);
        return [{
          type: 'text',
          text: JSON.stringify({
            success: true,
            result
          }, null, 2)
        }];
      } catch (error) {
        console.error(`[Playwright] Evaluate error:`, error.message);
        throw Object.assign(error, {
          operation: name,
          context: { scriptPreview: args.script.substring(0, 100) },
          suggestions: ['Check JavaScript syntax', 'Ensure variables/elements exist', 'Wrap in try-catch if needed']
        });
      }
    }

    case 'browser_get_html': {
      try {
        let html;
        if (args.selector) {
          console.log(`[Playwright] Getting HTML for: ${args.selector}`);
          const element = await currentPage.$(args.selector);
          if (!element) {
            return [{
              type: 'text',
              text: JSON.stringify({
                success: false,
                error: `Element not found: ${args.selector}`,
                errorCategory: 'SELECTOR',
                selector: args.selector,
                suggestions: [
                  'Verify the selector exists on the page',
                  'Use browser_snapshot to inspect current DOM',
                  'Try a broader selector'
                ]
              }, null, 2)
            }];
          }
          html = await element.innerHTML();
        } else {
          console.log('[Playwright] Getting full page HTML');
          html = await currentPage.content();
        }

        // Truncate if too large
        const maxLength = 50000;
        const truncated = html.length > maxLength;

        return [{
          type: 'text',
          text: JSON.stringify({
            success: true,
            html: truncated ? html.substring(0, maxLength) + '\n\n... [TRUNCATED]' : html,
            selector: args.selector || 'full page',
            truncated,
            originalLength: html.length
          }, null, 2)
        }];
      } catch (error) {
        console.error(`[Playwright] Get HTML error:`, error.message);
        throw Object.assign(error, { operation: name, context: { selector: args.selector } });
      }
    }

    case 'browser_wait_for': {
      if (!args.selector) {
        throw Object.assign(new Error('Missing required parameter: selector'), {
          errorCategory: 'VALIDATION',
          operation: name,
          suggestions: ['Provide a CSS selector to wait for']
        });
      }
      try {
        const timeout = args.timeout || 30000;
        console.log(`[Playwright] Waiting for: ${args.selector} (timeout: ${timeout}ms)`);
        await currentPage.waitForSelector(args.selector, { timeout });
        return [{
          type: 'text',
          text: JSON.stringify({
            success: true,
            message: `Element ${args.selector} is now visible`,
            selector: args.selector,
            timeout
          }, null, 2)
        }];
      } catch (error) {
        console.error(`[Playwright] Wait error:`, error.message);
        throw Object.assign(error, {
          operation: name,
          context: { selector: args.selector, timeout: args.timeout || 30000 }
        });
      }
    }

    default:
      throw Object.assign(new Error(`Unknown tool: ${name}`), {
        errorCategory: 'INVALID_TOOL',
        availableTools: ['browser_navigate', 'browser_snapshot', 'browser_click', 'browser_type', 'browser_screenshot', 'browser_evaluate', 'browser_get_html', 'browser_wait_for'],
        suggestions: ['Use one of the available tools listed above']
      });
  }
}

// Handle JSON-RPC request
async function handleJsonRpcRequest(request) {
  const { jsonrpc, id, method, params } = request;

  if (jsonrpc !== '2.0') {
    return { jsonrpc: '2.0', id, error: { code: -32600, message: 'Invalid Request' } };
  }

  console.log(`MCP method: ${method}`, params);

  try {
    switch (method) {
      case 'initialize': {
        return {
          jsonrpc: '2.0',
          id,
          result: {
            protocolVersion: PROTOCOL_VERSION,
            capabilities: {
              tools: { listChanged: false }
            },
            serverInfo: SERVER_INFO
          }
        };
      }

      case 'initialized': {
        // Notification - no response needed
        return null;
      }

      case 'tools/list': {
        return {
          jsonrpc: '2.0',
          id,
          result: { tools }
        };
      }

      case 'tools/call': {
        const { name, arguments: args } = params;
        console.log(`[MCP] Tool call: ${name}`, JSON.stringify(args || {}).substring(0, 200));

        try {
          const content = await handleToolCall(name, args || {});
          return {
            jsonrpc: '2.0',
            id,
            result: { content, isError: false }
          };
        } catch (error) {
          // Create detailed error response using our error parser
          const errorResponse = createMcpErrorResponse(error, error.operation || name, {
            tool: name,
            ...(error.context || {}),
            providedArgs: Object.keys(args || {})
          });

          // Enhance with any extra error properties
          const errorContent = JSON.parse(errorResponse.content[0].text);
          if (error.errorCategory) errorContent.errorCategory = error.errorCategory;
          if (error.suggestions) errorContent.suggestions = error.suggestions;
          if (error.availableTools) errorContent.availableTools = error.availableTools;

          console.error(`[MCP] Tool error in ${name}:`, JSON.stringify(errorContent, null, 2));

          return {
            jsonrpc: '2.0',
            id,
            result: {
              content: [{
                type: 'text',
                text: JSON.stringify(errorContent, null, 2)
              }],
              isError: true
            }
          };
        }
      }

      case 'ping': {
        return { jsonrpc: '2.0', id, result: {} };
      }

      default: {
        console.error(`[MCP] Unknown method: ${method}`);
        return {
          jsonrpc: '2.0',
          id,
          error: {
            code: -32601,
            message: `Method not found: ${method}`,
            data: {
              requestedMethod: method,
              availableMethods: ['initialize', 'initialized', 'tools/list', 'tools/call', 'ping'],
              suggestion: 'Use tools/list to see available tools, then tools/call to execute them'
            }
          }
        };
      }
    }
  } catch (error) {
    const parsedError = parsePlaywrightError(error, method, { params });

    console.error(`[MCP] Unexpected error handling ${method}:`, JSON.stringify(parsedError, null, 2));

    return {
      jsonrpc: '2.0',
      id,
      error: {
        code: -32603,
        message: `Internal error: ${error.message}`,
        data: {
          ...parsedError,
          method
        }
      }
    };
  }
}

// HTTP server
const httpServer = http.createServer(async (req, res) => {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Accept, Mcp-Session-Id, Last-Event-ID');

  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  // Health check
  if ((req.url === '/health' || req.url === '/') && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', service: 'playwright-mcp-scrapingbee' }));
    return;
  }

  // MCP endpoint - Streamable HTTP transport
  if (req.url === '/mcp' || req.url === '/sse') {
    if (req.method === 'GET') {
      // SSE stream for server-to-client messages (optional in Streamable HTTP)
      res.writeHead(200, {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive'
      });
      // Keep connection alive
      const keepAlive = setInterval(() => {
        res.write(':keepalive\n\n');
      }, 30000);
      req.on('close', () => {
        clearInterval(keepAlive);
      });
      return;
    }

    if (req.method === 'POST') {
      let body = '';
      req.on('data', chunk => body += chunk);
      req.on('end', async () => {
        try {
          const request = JSON.parse(body);
          console.log('Received JSON-RPC request:', JSON.stringify(request).substring(0, 200));

          const response = await handleJsonRpcRequest(request);

          if (response === null) {
            // Notification - return 202 Accepted
            res.writeHead(202);
            res.end();
          } else {
            // Return JSON response
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(response));
          }
        } catch (error) {
          console.error('Error parsing request:', error);
          res.writeHead(400, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({
            jsonrpc: '2.0',
            error: { code: -32700, message: 'Parse error' }
          }));
        }
      });
      return;
    }
  }

  // 404
  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'Not found' }));
});

httpServer.listen(PORT, '0.0.0.0', () => {
  console.log(`Playwright MCP Server with ScrapingBee proxy listening on port ${PORT}`);
  console.log(`MCP endpoint: http://0.0.0.0:${PORT}/mcp`);
  console.log(`Health check: http://0.0.0.0:${PORT}/health`);
});

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, shutting down...');
  if (browser) {
    await browser.close();
  }
  httpServer.close(() => process.exit(0));
});
