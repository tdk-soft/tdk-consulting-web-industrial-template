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

## 🚀 Scaffolding (TDK Generator)

To maintain architectural consistency and speed up development, use the built-in generator. It automatically creates the component, its unit test, and its Storybook story.

```bash
# Usage
npm run gen <type> <name>
```

# Examples

npm run gen ui button # Creates a basic UI component
npm run gen features login # Creates a domain-specific feature module
npm run gen sections hero # Creates a landing page section

###### Target directory: src/components/{type}/{name}/


## 🛠 Development Workflow

1. Installation
   ```bash
       npm install
   ```
2. Local Development
   ```bash
   npm run dev
   ```

3. Production Readiness Test (Docker)
   We use Docker Compose to verify the production standalone build locally.

```bash
docker compose up --build
Access: http://localhost:3000
```

4. Healthcheck: Automatic container health monitoring enabled.

## 🚢 CI/CD & GitOps Flow

1. CI (GitHub Actions): Lints code, runs Vitest, and builds the Docker image.

2. Registry: Pushes the lightweight (~73MB) image to the container registry.

3. CD (ArgoCD): Automatically detects the new image tag and synchronizes the Kubernetes cluster using Kustomize overlays located in /k8s/overlays/production.

## 📁 Repository Structure

- src/core/: Framework-agnostic logic (API, hooks, store).

- src/components/: Atomic design system (ui, sections, features).

- k8s/: Environment-specific Kubernetes manifests.

- scripts/: Automation and scaffolding tools.


---
© 2026 tdksoftconsulting. All rights reserved.
