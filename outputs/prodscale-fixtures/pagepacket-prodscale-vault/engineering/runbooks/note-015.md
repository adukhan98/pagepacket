# note 015

Owner: sanitized-owner-105@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-015.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-105-000 token-105-001 token-105-002 token-105-003 token-105-004 token-105-005 token-105-006 token-105-007 token-105-008 token-105-009 token-105-010 token-105-011 token-105-012 token-105-013 token-105-014 token-105-015 token-105-016 token-105-017 token-105-018 token-105-019 token-105-020 token-105-021 token-105-022 token-105-023 token-105-024 token-105-025 token-105-026 token-105-027 token-105-028 token-105-029 token-105-030 token-105-031 token-105-032 token-105-033 token-105-034 token-105-035 token-105-036 token-105-037 token-105-038 token-105-039 token-105-040 token-105-041 token-105-042 token-105-043 token-105-044 token-105-045 token-105-046 token-105-047
