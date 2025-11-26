import http from 'http';
import { chromium } from 'playwright';
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { SSEServerTransport } from '@modelcontextprotocol/sdk/server/sse.js';
import {
  ListToolsRequestSchema,
  CallToolRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

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
      viewport: { width: 1280, height: 720 }
    });
    page = await context.newPage();
  }
  return page;
}

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
  const currentPage = await getPage();

  switch (name) {
    case 'browser_navigate': {
      await currentPage.goto(args.url, { waitUntil: 'domcontentloaded', timeout: 60000 });
      const title = await currentPage.title();
      return { content: [{ type: 'text', text: `Navigated to ${args.url}. Page title: ${title}` }] };
    }

    case 'browser_snapshot': {
      const snapshot = await currentPage.accessibility.snapshot();
      return { content: [{ type: 'text', text: JSON.stringify(snapshot, null, 2) }] };
    }

    case 'browser_click': {
      await currentPage.click(args.selector);
      return { content: [{ type: 'text', text: `Clicked on ${args.selector}` }] };
    }

    case 'browser_type': {
      await currentPage.fill(args.selector, args.text);
      return { content: [{ type: 'text', text: `Typed "${args.text}" into ${args.selector}` }] };
    }

    case 'browser_screenshot': {
      const buffer = await currentPage.screenshot({ fullPage: args.fullPage || false });
      const base64 = buffer.toString('base64');
      return {
        content: [
          { type: 'text', text: 'Screenshot captured' },
          { type: 'image', data: base64, mimeType: 'image/png' }
        ]
      };
    }

    case 'browser_evaluate': {
      const result = await currentPage.evaluate(args.script);
      return { content: [{ type: 'text', text: JSON.stringify(result, null, 2) }] };
    }

    case 'browser_get_html': {
      let html;
      if (args.selector) {
        const element = await currentPage.$(args.selector);
        html = element ? await element.innerHTML() : 'Element not found';
      } else {
        html = await currentPage.content();
      }
      return { content: [{ type: 'text', text: html }] };
    }

    case 'browser_wait_for': {
      await currentPage.waitForSelector(args.selector, { timeout: args.timeout || 30000 });
      return { content: [{ type: 'text', text: `Element ${args.selector} is now visible` }] };
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}

// Create MCP server
function createMcpServer() {
  const server = new Server(
    { name: 'playwright-scrapingbee', version: '1.0.0' },
    { capabilities: { tools: {} } }
  );

  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return { tools };
  });

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;
    try {
      return await handleToolCall(name, args || {});
    } catch (error) {
      return {
        content: [{ type: 'text', text: `Error: ${error.message}` }],
        isError: true
      };
    }
  });

  return server;
}

// HTTP server for SSE transport
const transports = new Map();

const httpServer = http.createServer(async (req, res) => {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  // Health check
  if (req.url === '/health' || req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', service: 'playwright-mcp-scrapingbee' }));
    return;
  }

  // SSE endpoint
  if (req.url === '/sse' && req.method === 'GET') {
    console.log('New SSE connection');

    const server = createMcpServer();
    const transport = new SSEServerTransport('/messages', res);
    const sessionId = Date.now().toString();

    transports.set(sessionId, { server, transport });

    req.on('close', () => {
      console.log(`SSE connection closed: ${sessionId}`);
      transports.delete(sessionId);
    });

    await server.connect(transport);
    return;
  }

  // Messages endpoint for SSE transport
  if (req.url === '/messages' && req.method === 'POST') {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', async () => {
      // SSEServerTransport handles this internally
      res.writeHead(200);
      res.end();
    });
    return;
  }

  // 404
  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'Not found' }));
});

httpServer.listen(PORT, '0.0.0.0', () => {
  console.log(`Playwright MCP Server with ScrapingBee proxy listening on port ${PORT}`);
  console.log(`SSE endpoint: http://0.0.0.0:${PORT}/sse`);
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
