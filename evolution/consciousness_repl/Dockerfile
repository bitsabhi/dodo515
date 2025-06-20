FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy application files
COPY . .

# Make CLI executable
RUN chmod +x cli.js

# Expose port for bridge server
EXPOSE 8888

# Default command starts the bridge server
CMD ["node", "consciousness-bridge-server.js"]