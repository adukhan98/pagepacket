# note 008

Owner: sanitized-owner-128@example.test
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
pagepacket-cli snapshot . customer-notes/note-008.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-128-000 token-128-001 token-128-002 token-128-003 token-128-004 token-128-005 token-128-006 token-128-007 token-128-008 token-128-009 token-128-010 token-128-011 token-128-012 token-128-013 token-128-014 token-128-015 token-128-016 token-128-017 token-128-018 token-128-019 token-128-020 token-128-021 token-128-022 token-128-023 token-128-024 token-128-025 token-128-026 token-128-027 token-128-028 token-128-029 token-128-030 token-128-031 token-128-032 token-128-033 token-128-034 token-128-035 token-128-036 token-128-037 token-128-038 token-128-039 token-128-040 token-128-041 token-128-042 token-128-043 token-128-044 token-128-045 token-128-046 token-128-047
