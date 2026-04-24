# TDK Next.js Industrial Template

Professional GitOps-ready boilerplate for high-scalability web applications. Designed by **tdksoftconsulting**.

## 🏗 Architecture & Features
- **Framework:** Next.js 15+ (App Router)
- **Deployment:** GitOps ready with ArgoCD & Kustomize
- **CI/CD:** Optimized GitHub Actions for automated testing and image tagging
- **Containerization:** Multi-stage production-grade Dockerfile (Standalone mode)
- **Quality:** ESLint, Prettier, Vitest, and Playwright integrated

## 📁 Structure Highlights
- `/src/core`: Framework-agnostic business logic (API clients, hooks, state)
- `/src/components/features`: Domain-driven UI modules
- `/k8s`: Kustomize base and overlays for environment-specific configs
- `/.github/workflows`: Automated pipelines for CI and CD (GitOps sync)

## 🚀 Getting Started
1. **Clone the repository**
2. **Install dependencies:** `npm install`
3. **Start Development:** `npm run dev`
4. **Build Production Image:** `docker compose build`

## 🤖 CI/CD Flow
1. **CI:** On push, GitHub Actions runs linting and unit tests.
2. **Push:** On success, the Docker image is pushed to the Registry.
3. **CD (ArgoCD):** The `release.yml` updates the Kustomize manifests. ArgoCD detects the change and synchronizes the cluster automatically.

---
© 2026 tdksoftconsulting. All rights reserved.