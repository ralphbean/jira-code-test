# jira-code-test

A test repository for validating Jira-driven coding capabilities in
[Fullsend](https://github.com/fullsend-ai/fullsend).

## Purpose

This repo exercises the end-to-end workflow where Fullsend polls a Jira
project for issues, triages them, and implements code changes
automatically. It serves as a living integration test for:

- **Jira polling** — a scheduled GitHub Actions workflow polls the
  `FSENDAI` Jira project every 30 minutes for bugs labeled `fullsend`
  and dispatches them to Fullsend harnesses.
- **Triage** — an AI agent triages incoming work items, performing root
  cause analysis and labeling issues as ready for implementation.
- **Code implementation** — an AI agent picks up triaged issues, plans
  and implements fixes, runs verification, and opens pull requests.

## How it works

1. The `fullsend-poll-jira.yaml` workflow runs on a schedule (or
   manually) and calls `fullsend poll` with the Jira driver.
2. Matching issues are dispatched through the `reusable-dispatch`
   workflow from the main Fullsend repo.
3. Harness definitions in `.fullsend/harness/` configure the triage and
   code agents, including their trigger conditions (e.g., the
   `ready-to-code` label or `/fs-code` command).
4. The `fullsend.yaml` workflow handles GitHub-native issue and comment
   events.

## Repository structure

```
.fullsend/
  config.yaml              # Fullsend per-repo configuration
  harness/
    triage.yaml            # Triage agent harness definition
    code.yaml              # Code agent harness definition
.github/workflows/
  fullsend.yaml            # GitHub event-driven Fullsend dispatch
  fullsend-poll-jira.yaml  # Scheduled Jira polling workflow
update-harness-refs.sh     # Helper to update harness base URLs
```
