# note 002

Owner: sanitized-owner-062@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-002.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-062-000 token-062-001 token-062-002 token-062-003 token-062-004 token-062-005 token-062-006 token-062-007 token-062-008 token-062-009 token-062-010 token-062-011 token-062-012 token-062-013 token-062-014 token-062-015 token-062-016 token-062-017 token-062-018 token-062-019 token-062-020 token-062-021 token-062-022 token-062-023 token-062-024 token-062-025 token-062-026 token-062-027 token-062-028 token-062-029 token-062-030 token-062-031 token-062-032 token-062-033 token-062-034 token-062-035 token-062-036 token-062-037 token-062-038 token-062-039 token-062-040 token-062-041 token-062-042 token-062-043 token-062-044 token-062-045 token-062-046 token-062-047
