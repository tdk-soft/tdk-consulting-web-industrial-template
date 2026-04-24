#!/bin/bash

# Project Initialization Script
# Created for tdksoftconsulting

PROJECT_NAME=${1:-"my-tdk-app"}

echo "🚀 Industrializing $PROJECT_NAME..."

# 1. Create Structure
mkdir -p $PROJECT_NAME/{.github/workflows,.husky,docker,k8s/{base,overlays/{development,staging,production}},scripts,src/{app,components/{ui,layouts,features},core/{api,hooks,store},lib,types,utils},tests/{unit,integration,e2e},public/assets}

# 2. Generate Dockerfile (Multi-stage Standalone)
cat <<EOF > $PROJECT_NAME/docker/Dockerfile
# --- STAGE 1: Dependencies ---
FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# --- STAGE 2: Builder ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NEXT_TELEMETRY_DISABLED 1
RUN npm run build

# --- STAGE 3: Runner ---
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV production
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT 3000
CMD ["node", "server.js"]
EOF

# 2. Generate Dockerfile (Multi-stage Standalone)
cat <<EOF > $PROJECT_NAME/docker/.dockerignore
# Dependency directories
node_modules/
jspm_packages/

# Next.js build output
.next/
out/

# Environment files (CRITICAL for security)
.env
.env.local
.env.production.local
.env.development.local

# Debug and logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# Git and IDE
.git
.vscode
.idea
.DS_Store

# Documentation and Tests
README.md
CONTRIBUTING.md
tests/
docker/
EOF


# 3. Generate CI Workflow
cat <<EOF > $PROJECT_NAME/.github/workflows/ci.yml
name: CI - Quality & Build

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run test:unit

  build-and-push:
    needs: quality
    if: github.event_name == 'push'
    runs-on: ubuntu-latest
    steps:
      - name: Build Docker Image
        run: echo "Docker build & push logic goes here"
EOF

# 4. Generate Release Workflow (ArgoCD Automation)
cat <<EOF > $PROJECT_NAME/.github/workflows/release.yml
name: Release - ArgoCD Sync

on:
  workflow_run:
    workflows: ["CI - Quality & Build"]
    types: [completed]
    branches: [main]

jobs:
  update-gitops:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          token: \${{ secrets.GITOPS_PAT }}
      - name: Update Kustomize Image Tag
        run: |
          cd k8s/overlays/production
          # Logic to update image tag for ArgoCD to pull
          echo "Updating image tag to \${{ github.sha }}"
EOF

# 5. Generate Docker Compose (Dev)
cat <<EOF > $PROJECT_NAME/docker-compose.yaml
version: '3.8'
services:
  web:
    build:
      context: .
      dockerfile: docker/Dockerfile
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - ./src:/app/src
EOF


# 6. Legal & Standardization
cat <<EOF > $PROJECT_NAME/LICENSE
Copyright 2026 tdksoftconsulting

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitationsations under the License.
EOF

cat <<EOF > $PROJECT_NAME/CONTRIBUTING.md
# Contributing to TDK Projects

Thank you for contributing to a tdksoftconsulting project!

## Branching Strategy
- `main`: Production-ready code.
- `develop`: Integration branch for features.
- `feature/*`: New features.

## Commit Message Convention
We follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` for new features.
- `fix:` for bug fixes.
- `chore:` for maintenance.

## Pull Request Process
1. Ensure `npm run test` passes.
2. Update the documentation if necessary.
3. Every PR requires at least one approval.
EOF

cat <<EOF > $PROJECT_NAME/.editorconfig
root = true

[*]
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
end_of_line = lf

[*.md]
trim_trailing_whitespace = false
EOF

mkdir -p $PROJECT_NAME/.github
cat <<EOF > $PROJECT_NAME/.github/CODEOWNERS
* @tdksoftconsulting
EOF

# 7. Git-related (Standard Ignore)
cat <<EOF > $PROJECT_NAME/.gitignore
# Dependencies
node_modules/
/.pnp
.pnp.js

# Testing
/coverage
/test-results

# Next.js
/.next/
/out/

# Production Build
/build

# Environment Variables
.env
.env.local
.env.production.local
.env.development.local
.env.test.local

# Secrets and Keys
*.pem
*.key
.secret

# Debug Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS & IDE
.DS_Store
.vscode/
.idea/
*.swp
EOF

# 8. Other Ignore files setup
cat <<EOF > $PROJECT_NAME/.prettierignore
node_modules
.next
public
EOF

cat <<EOF > $PROJECT_NAME/.gitattributes
* text eol=lf
*.sh text eol=lf
EOF

echo "✨ All professional governance files have been generated."

echo "✅ Project $PROJECT_NAME is ready!"