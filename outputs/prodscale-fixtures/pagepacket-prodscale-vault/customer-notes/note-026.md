# note 026

Owner: sanitized-owner-146@example.test
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
pagepacket-cli snapshot . customer-notes/note-026.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-146-000 token-146-001 token-146-002 token-146-003 token-146-004 token-146-005 token-146-006 token-146-007 token-146-008 token-146-009 token-146-010 token-146-011 token-146-012 token-146-013 token-146-014 token-146-015 token-146-016 token-146-017 token-146-018 token-146-019 token-146-020 token-146-021 token-146-022 token-146-023 token-146-024 token-146-025 token-146-026 token-146-027 token-146-028 token-146-029 token-146-030 token-146-031 token-146-032 token-146-033 token-146-034 token-146-035 token-146-036 token-146-037 token-146-038 token-146-039 token-146-040 token-146-041 token-146-042 token-146-043 token-146-044 token-146-045 token-146-046 token-146-047
