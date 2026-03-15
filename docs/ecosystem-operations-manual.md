# Packages Operations Manual

This document describes package-repo automation and verification boundaries for the stabilized Astra ecosystem.

## Scope

Repository: `packages`

Allowed responsibilities:

- Recipe structure and metadata consistency
- CI package build + lifecycle smoke checks
- Standardized artifact output
- Automated synchronization PR to `altair-repo`

Not in scope:

- Modifying package manager runtime logic in `Astra`
- Manual artifact edits in `altair-repo`

## Recipe Structure Contract

Each package directory must include:

- `astra.pkg`
- `Astrafile.yaml`
- `build.sh`
- `files/` payload tree

## Package Build Workflow

Workflow: `.github/workflows/package-build.yml`

Key guarantees:

1. **Auto-discovery**
   - Builds matrix from all recipe directories containing `astra.pkg`.

2. **Sequential execution**
   - `max-parallel: 1` and workflow concurrency group for repeatable, race-free output.

3. **Lifecycle smoke test**
   - For each built package:
     - local install
     - local remove
     - upgrade command

4. **Artifact standardization**
   - Consolidates package artifacts into `dist/standard-output/*.astpkg`.

5. **Downstream sync**
   - Optionally opens a PR in `altair-repo` to publish built artifacts and refresh `unstable/index.json`.

6. **Cross-repo orchestration**
   - Optionally triggers `Astra` ecosystem automation via `repository_dispatch` event.

7. **Failure notifications**
   - Sends Discord webhook on workflow failure (when configured).

## Required Secrets

- `ALTAIR_REPO_TOKEN` for opening PRs in `altair-repo`
- `ASTRA_REPO_TOKEN` for dispatching Astra automation workflow
- `DISCORD_WEBHOOK_URL` for failure notifications

## Local Verification Commands

From workspace root:

```powershell
./Astra/scripts/ops/lifecycle-e2e.ps1 -WorkspaceRoot "C:/Users/Aaryadev/Desktop/Atlar/workspace" -RunId "packages-local"
./Astra/scripts/ops/dashboard.ps1 -LifecycleReportPath "C:/Users/Aaryadev/Desktop/Atlar/workspace/.ops-runtime/packages-local/lifecycle-report.json"
```

## Branch Protection Safe Merge Flow

Use automation script:

```powershell
./Astra/scripts/ops/pr-merge-safe.ps1 `
  -Repository "Altair-Linux/packages" `
  -RepositoryPath "C:/Users/Aaryadev/Desktop/Atlar/workspace/packages" `
  -Branch "finalize-ecosystem" `
  -CommitMessage "chore: packages checkpoint" `
  -PrTitle "Finalize ecosystem" `
  -PrBody "Automated packages update" `
  -MergeMethod squash `
  -UseAdmin `
  -ToggleRuleset
```

## Post-merge Audit Checks

- `gh pr list -R Altair-Linux/packages --state open` returns none
- `gh api repos/Altair-Linux/packages/commits/main` shows `verified: true`
- `gh workflow list -R Altair-Linux/packages` shows active workflows
- Final closure validation passes:

```powershell
./Astra/scripts/ops/final-verify.ps1 -WorkspaceRoot "C:/Users/Aaryadev/Desktop/Atlar/workspace"
```
