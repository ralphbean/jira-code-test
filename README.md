# jira-code-test

End-to-end test repository for the fullsend Jira integration pipeline.

## Purpose

This repository validates that the fullsend triage and code agents
work correctly when triggered from Jira issues via the
`fullsend-poll-jira` workflow.

## How it works

1. A Jira issue is created in the FSENDAI project with the `fullsend`
   label.
2. The `fullsend-poll-jira` workflow polls for new issues and
   dispatches them to the appropriate agent.
3. The triage agent analyzes the issue (triggered by `/fs-triage`).
4. The code agent implements a change (triggered by `/fs-code` or the
   `ready-to-code` label).

## Configuration

- `.fullsend/config.yaml` — per-repo fullsend configuration
- `.fullsend/harness/triage.yaml` — triage agent harness definition
- `.fullsend/harness/code.yaml` — code agent harness definition
- `update-harness-refs.sh` — updates harness base URLs to the latest
  agents commit
