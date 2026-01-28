# Zenscrap Server

Serverpod backend server for Zenscrap - the AI-powered web scraping rules generator. Users interact with an AI assistant through a chat interface to create, test, and refine ScrapingBee extraction configurations. The AI uses two MCP (Model Context Protocol) servers to browse pages and validate extraction rules.

## 🚀 Overview

The Zenscrap Server is built with Serverpod and provides:
- **AI Chat System**: OpenAI-powered chat for scraping rule generation
- **MCP Integration**: Two MCP servers for browser automation and rule testing
- **Real-time Streaming**: WebSocket streams for AI thinking process and chat responses
- **User authentication and session management**
- **Database persistence for scraping configurations**
- **Subscription and API credit management with Stripe**

## 📦 Shared Core Package

Logic that needs to be consistent between the server and Flutter client is placed in the **`zenscrap_core`** package (located at `../zenscrap_core`).

When adding new functionality that must work identically on both client and server (e.g., validation rules, constants, utilities), add it to `zenscrap_core` instead of duplicating code.

See [`zenscrap_core/README.md`](../zenscrap_core/README.md) for more details.

## 🏗️ Architecture

```
zenscrap_server/
├── lib/
│   ├── src/
│   │   ├── endpoints/
│   │   │   ├── public/
│   │   │   │   ├── chat_controller/         # AI Chat System
│   │   │   │   │   ├── chat_controller_openai_sdk_impl.dart  # OpenAI integration
│   │   │   │   │   ├── chat_controller_handler_mixin.dart    # Response handling
│   │   │   │   │   ├── openai_prompt_builder.dart            # Prompt construction
│   │   │   │   │   ├── web_scraper_ai_models.dart            # Data models
│   │   │   │   │   └── i_chat_controller.dart                # Interface
│   │   │   │   ├── scrappable_chat_session.dart  # Session management
│   │   │   │   ├── create_scrappable.dart        # Scrappable creation
│   │   │   │   └── ...
│   │   │   └── private/                      # Authenticated endpoints
│   │   ├── core/
│   │   │   ├── scraping_bee.dart             # ScrapingBee API client
│   │   │   ├── stripe/                       # Stripe integration
│   │   │   └── ...
│   │   ├── webhooks/                         # Stripe webhooks
│   │   └── generated/                        # Serverpod generated code
│   └── server.dart                           # Server configuration
├── bin/main.dart                             # Server entry point
├── config/                                   # Configuration files
├── migrations/                               # Database migrations
└── docker-compose.yaml                       # Docker services
```

## 🤖 MCP Servers

The AI uses two external MCP servers (hosted on Railway):

### Playwright MCP
- **URL**: `https://playwright-mcp-scrapingbee-production.up.railway.app/mcp`
- **Purpose**: Browser automation with ScrapingBee proxy for anti-bot bypass
- **Tools**: `browser_navigate`, `browser_snapshot`, `browser_click`, `browser_type`, `browser_screenshot`, `browser_evaluate`, `browser_get_html`, `browser_wait_for`

### ScrapingBee MCP
- **URL**: `https://scraping-bee-mcp-production.up.railway.app/mcp`
- **Purpose**: Testing extraction rules directly against ScrapingBee API
- **Tools**: `test_extract_rules`, `get_page_html`, `get_screenshot`

## 🚀 Quick Start

### Prerequisites

- Dart SDK 3.0+
- Docker & Docker Compose
- Serverpod CLI
- PostgreSQL 14+ (via Docker)
- Redis (via Docker)

### Installation

1. **Clone and navigate to server directory**
```bash
cd zenscrap_server
```

2. **Install dependencies**
```bash
dart pub get
```

3. **Generate Serverpod code**
```bash
serverpod generate --experimental-features=all
```

4. **Start Docker services**
```bash
docker compose up --build --detach
```

5. **Run database migrations**
```bash
serverpod create-migration --experimental-features=all
serverpod migrate --experimental-features=all
```

6. **Start the server**
```bash
dart bin/main.dart
```

The server will start on `http://localhost:8080` by default.

## 🔧 Configuration

### Environment Configuration

Configuration files are located in the `config/` directory:

#### development.yaml
```yaml
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http

database:
  host: localhost
  port: 8090
  name: zenscrap
  user: postgres

redis:
  enabled: true
  host: localhost
  port: 8091

scrapingBee:
  apiKey: your_dev_api_key_here
```

#### production.yaml
```yaml
apiServer:
  port: 8080
  publicHost: api.zenscrap.com
  publicPort: 443
  publicScheme: https

database:
  host: db.zenscrap.com
  port: 5432
  name: zenscrap_prod
  user: postgres

redis:
  enabled: true
  host: redis.zenscrap.com
  port: 6379

scrapingBee:
  apiKey: ${SCRAPINGBEE_API_KEY}  # From environment variable
```

### Environment Variables

Set these in your deployment environment:
```bash
export SCRAPINGBEE_API_KEY=your_api_key
export DATABASE_PASSWORD=your_db_password
export REDIS_PASSWORD=your_redis_password
export JWT_SECRET=your_jwt_secret
```

## 📍 API Endpoints

### Scraper Endpoints

#### Generate New Rules
```dart
POST /scraper/generate
Body: {
  "targetUrl": "https://example.com",
  "requirements": "Extract product names and prices"
}
Response: {
  "fetchSettings": {...},
  "request": {...}
}
```

#### Edit Existing Rules
```dart
POST /scraper/edit
Body: {
  "currentSettings": {...},
  "modifications": "Add image extraction"
}
Response: {
  "fetchSettings": {...},
  "request": {...}
}
```

#### Test Rules
```dart
POST /scraper/test
Body: {
  "fetchSettings": {...}
}
Response: {
  "success": true,
  "data": {...}
}
```

### Authentication Endpoints

#### Sign Up
```dart
POST /auth/signup
Body: {
  "email": "user@example.com",
  "password": "securePassword123"
}
```

#### Sign In
```dart
POST /auth/signin
Body: {
  "email": "user@example.com",
  "password": "securePassword123"
}
Response: {
  "token": "jwt_token_here",
  "user": {...}
}
```

### History Endpoints

#### Get User History
```dart
GET /history
Headers: {
  "Authorization": "Bearer jwt_token"
}
Response: [{
  "id": 1,
  "url": "https://example.com",
  "settings": {...},
  "createdAt": "2024-01-01T00:00:00Z"
}]
```

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Scraping Configurations Table
```sql
CREATE TABLE scraping_configurations (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  url TEXT NOT NULL,
  fetch_settings JSONB NOT NULL,
  request_config JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Sessions Table
```sql
CREATE TABLE sessions (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  token VARCHAR(255) UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## 🔌 Service Integration

### Web Scrapper Generator Integration

```dart
// In scraper_service.dart

class ScraperService {
  final _generator = GeminiWebScrapperGenerator(
    geminiSDK: geminiSDK,
    scrapingBeeApiKey: config.scrapingBeeApiKey,
  );

  Future<ScrappingBeeFetchSettings> generateRules(
    String url,
    String requirements,
  ) async {
    await _generator.initChat(
      InitialPayloadDataCreatingFromZero(
        targetExampleUrl: url,
        webScrapperRequest: _createRequest(url),
      ),
    );

    final response = await _generator.sendMessage(requirements);

    return _handleResponse(response);
  }
}
```

## 🔒 Security

### Authentication
- JWT-based authentication
- Bcrypt password hashing
- Session management with expiry
- Rate limiting on auth endpoints

### API Security
- CORS configuration for allowed origins
- Request validation and sanitization
- SQL injection protection via Serverpod ORM
- Environment-based secrets management

## 🚢 Deployment

### Docker Deployment

1. **Build Docker image**
```bash
docker build -t zenscrap-server .
```

2. **Run with Docker Compose**
```yaml
# docker-compose.prod.yaml
version: '3.8'
services:
  server:
    image: zenscrap-server
    ports:
      - "8080:8080"
    environment:
      - SERVERPOD_ENV=production
      - SCRAPINGBEE_API_KEY=${SCRAPINGBEE_API_KEY}
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:14
    environment:
      - POSTGRES_DB=zenscrap_prod
      - POSTGRES_PASSWORD=${DATABASE_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7
    command: redis-server --requirepass ${REDIS_PASSWORD}

volumes:
  postgres_data:
```

### Cloud Deployment (AWS/GCP/Azure)

1. **Set up managed database** (RDS/Cloud SQL)
2. **Set up managed Redis** (ElastiCache/Cloud Memorystore)
3. **Deploy server** (ECS/Cloud Run/Container Instances)
4. **Configure load balancer** and SSL certificates

## 🧪 Testing

### Run Tests
```bash
# Unit tests
dart test

# Integration tests
dart test integration_test/

# Load tests
dart test performance/
```

### Test Structure
```dart
// test/endpoints/scraper_endpoint_test.dart
void main() {
  late TestServer server;

  setUp(() async {
    server = await TestServer.start();
  });

  tearDown(() async {
    await server.shutdown();
  });

  test('generates scraping rules', () async {
    final result = await server.scraper.generateRules(
      'https://example.com',
      'Extract prices',
    );

    expect(result.fetchSettings, isNotNull);
  });
}
```

## 📊 Monitoring

### Health Check Endpoint
```dart
GET /health
Response: {
  "status": "healthy",
  "database": "connected",
  "redis": "connected",
  "uptime": 3600
}
```

### Metrics
- Request latency tracking
- Error rate monitoring
- Database query performance
- Redis cache hit rates

## 🔍 Debugging

### Enable Debug Logging
```dart
// In config/development.yaml
logging:
  level: debug
  prettyPrint: true
```

### Database Queries
```dart
// Enable query logging
Serverpod.configure(
  logQueries: true,
  logSlowQueries: Duration(milliseconds: 100),
);
```

## ⚠️ Important Notes

1. **Always use experimental features**: `serverpod generate --experimental-features=all`
2. **Database migrations**: Run migrations before deploying
3. **Environment secrets**: Never commit API keys
4. **Redis required**: Ensure Redis is running for caching
5. **Rate limiting**: Implement rate limiting for production

## 🤝 Contributing

1. Create feature branch
2. Add tests for new endpoints
3. Update API documentation
4. Run static analysis: `dart analyze`
5. Create pull request

## 📄 License

This package is part of the Zenscrap project. See main project license.

## 🐛 Troubleshooting

### Database Connection Issues
```bash
# Check PostgreSQL is running
docker ps | grep postgres

# Check connection
psql -h localhost -p 8090 -U postgres -d zenscrap
```

### Redis Connection Issues
```bash
# Check Redis is running
docker ps | grep redis

# Test connection
redis-cli -h localhost -p 8091 ping
```

### Serverpod Generation Errors
```bash
# Always use experimental features
serverpod generate --experimental-features=all

# Clean and regenerate
rm -rf lib/src/generated
serverpod generate --experimental-features=all
```

## 📚 Resources

- [Serverpod Documentation](https://docs.serverpod.dev)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)
- [Docker Documentation](https://docs.docker.com)
