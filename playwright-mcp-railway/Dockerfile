# Use the official Playwright image which has all browser dependencies
FROM mcr.microsoft.com/playwright:v1.50.0-noble

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy server code
COPY server.js ./

# Set environment variables
ENV PORT=8931

# Expose port
EXPOSE 8931

# Start server
CMD ["node", "server.js"]
