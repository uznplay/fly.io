# Use Node.js 20 Alpine (lightweight)
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy all source code
COPY . .

# Generate CA certificates (ignore errors)
RUN node setup-certificates.js || echo "Certificate generation failed, will generate at runtime"

# Expose port
EXPOSE 8080

# Start the proxy
CMD ["node", "index.js"]
