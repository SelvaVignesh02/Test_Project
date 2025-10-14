# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy source code
COPY . .

# Expose port (if your app runs on 3000)
EXPOSE 4200

# Start the app
CMD ["node", "index.js"]

