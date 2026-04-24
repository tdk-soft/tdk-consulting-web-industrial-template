# 🏗️ Foundation v1.0.0-foundation

## Frozen Components
- Node.js 20.18-alpine
- Next.js standalone output
- Kustomize v1beta1 API
- ArgoCD monitoring pattern

## Modification Policy
- Foundation tags are **read-only**
- Changes require SRE approval
- Use `foundation/v1` branch for emergency patches

## Rollback Procedure
```bash
git checkout v1.0.0-foundation
docker build -t app:stable-foundation .
kubectl rollout undo deployment/nextjs-app

# 1. Tag the foundation
git tag -a v1.0.0-foundation -m "Foundation release - immutable base architecture"

# 2. Push the tag
git push origin v1.0.0-foundation

# 3. Protect the tag (GitHub CLI)
# Note: It is recommended to use Repository Rulesets in the GitHub UI instead.
gh api repos/:owner/:repo/git/refs/tags/v1.0.0-foundation --method PATCH \
  -f force=false

# 4. Create a GitHub Release
gh release create v1.0.0-foundation \
  --title "Foundation v1.0.0" \
  --notes "🏗️ **Immutable foundation** - Do not modify without SRE approval"