# note 003

Owner: sanitized-owner-123@example.test
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
pagepacket-cli snapshot . customer-notes/note-003.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-123-000 token-123-001 token-123-002 token-123-003 token-123-004 token-123-005 token-123-006 token-123-007 token-123-008 token-123-009 token-123-010 token-123-011 token-123-012 token-123-013 token-123-014 token-123-015 token-123-016 token-123-017 token-123-018 token-123-019 token-123-020 token-123-021 token-123-022 token-123-023 token-123-024 token-123-025 token-123-026 token-123-027 token-123-028 token-123-029 token-123-030 token-123-031 token-123-032 token-123-033 token-123-034 token-123-035 token-123-036 token-123-037 token-123-038 token-123-039 token-123-040 token-123-041 token-123-042 token-123-043 token-123-044 token-123-045 token-123-046 token-123-047
