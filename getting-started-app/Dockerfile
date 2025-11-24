# syntax=docker/dockerfile:1

FROM node:lts-alpine
WORKDIR /app

# Copy package files first
COPY package*.json yarn.lock ./
RUN yarn install --production

# Copy only source code
COPY src/ ./src/

EXPOSE 3000
CMD ["node", "src/index.js"]