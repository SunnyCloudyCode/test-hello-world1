# Use the official lightweight Node.js 12 image.
# https://hub.docker.com/_/node
FROM node:18-slim as base

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

# Test application
FROM base as test
RUN apt-get update && apt-get -y install procps
RUN npm ci
COPY . ./
# CMD ["node", "index.js"]
RUN npm run ci

# Build final application
FROM base as prod
# Install dependencies.
# If you add a package-lock.json speed your build by switching to 'npm ci'.
RUN npm ci --only=production

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.
CMD ["node", "index.js"]

