# note 025

Owner: sanitized-owner-115@example.test
Status: draft

This generated document is safe local test data for Pagepacket. It avoids customer, account, and production content.

## Summary

The file exercises Markdown editing, preview rendering, snapshot history, external-agent edits, and CLI traversal under a production-scale folder tree.

## Checklist

- [ ] Verify edit mode
- [x] Keep Markdown plain
- [ ] Review agent changes before accepting

## Table

| Area | State | Risk |
| --- | --- | --- |
| app | active | medium |
| cli | active | low |
| landing | preview | medium |

## Quote

> Human review remains the boundary before agent edits become canonical.

## Code

```sh
pagepacket-cli snapshot . engineering/runbooks/note-025.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-115-000 token-115-001 token-115-002 token-115-003 token-115-004 token-115-005 token-115-006 token-115-007 token-115-008 token-115-009 token-115-010 token-115-011 token-115-012 token-115-013 token-115-014 token-115-015 token-115-016 token-115-017 token-115-018 token-115-019 token-115-020 token-115-021 token-115-022 token-115-023 token-115-024 token-115-025 token-115-026 token-115-027 token-115-028 token-115-029 token-115-030 token-115-031 token-115-032 token-115-033 token-115-034 token-115-035 token-115-036 token-115-037 token-115-038 token-115-039 token-115-040 token-115-041 token-115-042 token-115-043 token-115-044 token-115-045 token-115-046 token-115-047
