# note 004

Owner: sanitized-owner-124@example.test
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
pagepacket-cli snapshot . customer-notes/note-004.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-124-000 token-124-001 token-124-002 token-124-003 token-124-004 token-124-005 token-124-006 token-124-007 token-124-008 token-124-009 token-124-010 token-124-011 token-124-012 token-124-013 token-124-014 token-124-015 token-124-016 token-124-017 token-124-018 token-124-019 token-124-020 token-124-021 token-124-022 token-124-023 token-124-024 token-124-025 token-124-026 token-124-027 token-124-028 token-124-029 token-124-030 token-124-031 token-124-032 token-124-033 token-124-034 token-124-035 token-124-036 token-124-037 token-124-038 token-124-039 token-124-040 token-124-041 token-124-042 token-124-043 token-124-044 token-124-045 token-124-046 token-124-047
