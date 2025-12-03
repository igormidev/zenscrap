import http from 'http';
import { chromium } from 'playwright';

const PORT = process.env.PORT || 8931;

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
  version: '1.0.0'
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

// Tool handler
async function handleToolCall(name, args) {
  console.log(`Tool call: ${name}`, args);
  const currentPage = await getPage();

  switch (name) {
    case 'browser_navigate': {
      await currentPage.goto(args.url, { waitUntil: 'domcontentloaded', timeout: 60000 });
      const title = await currentPage.title();
      return [{ type: 'text', text: `Navigated to ${args.url}. Page title: ${title}` }];
    }

    case 'browser_snapshot': {
      const snapshot = await currentPage.accessibility.snapshot();
      return [{ type: 'text', text: JSON.stringify(snapshot, null, 2) }];
    }

    case 'browser_click': {
      await currentPage.click(args.selector);
      return [{ type: 'text', text: `Clicked on ${args.selector}` }];
    }

    case 'browser_type': {
      await currentPage.fill(args.selector, args.text);
      return [{ type: 'text', text: `Typed "${args.text}" into ${args.selector}` }];
    }

    case 'browser_screenshot': {
      const buffer = await currentPage.screenshot({ fullPage: args.fullPage || false });
      const base64 = buffer.toString('base64');
      return [
        { type: 'text', text: 'Screenshot captured' },
        { type: 'image', data: base64, mimeType: 'image/png' }
      ];
    }

    case 'browser_evaluate': {
      const result = await currentPage.evaluate(args.script);
      return [{ type: 'text', text: JSON.stringify(result, null, 2) }];
    }

    case 'browser_get_html': {
      let html;
      if (args.selector) {
        const element = await currentPage.$(args.selector);
        html = element ? await element.innerHTML() : 'Element not found';
      } else {
        html = await currentPage.content();
      }
      return [{ type: 'text', text: html }];
    }

    case 'browser_wait_for': {
      await currentPage.waitForSelector(args.selector, { timeout: args.timeout || 30000 });
      return [{ type: 'text', text: `Element ${args.selector} is now visible` }];
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
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
        try {
          const content = await handleToolCall(name, args || {});
          return {
            jsonrpc: '2.0',
            id,
            result: { content, isError: false }
          };
        } catch (error) {
          return {
            jsonrpc: '2.0',
            id,
            result: {
              content: [{ type: 'text', text: `Error: ${error.message}` }],
              isError: true
            }
          };
        }
      }

      case 'ping': {
        return { jsonrpc: '2.0', id, result: {} };
      }

      default: {
        return {
          jsonrpc: '2.0',
          id,
          error: { code: -32601, message: `Method not found: ${method}` }
        };
      }
    }
  } catch (error) {
    console.error(`Error handling ${method}:`, error);
    return {
      jsonrpc: '2.0',
      id,
      error: { code: -32603, message: error.message }
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
