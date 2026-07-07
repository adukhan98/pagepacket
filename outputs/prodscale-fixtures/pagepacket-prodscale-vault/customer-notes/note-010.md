# note 010

Owner: sanitized-owner-130@example.test
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
pagepacket-cli snapshot . customer-notes/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-130-000 token-130-001 token-130-002 token-130-003 token-130-004 token-130-005 token-130-006 token-130-007 token-130-008 token-130-009 token-130-010 token-130-011 token-130-012 token-130-013 token-130-014 token-130-015 token-130-016 token-130-017 token-130-018 token-130-019 token-130-020 token-130-021 token-130-022 token-130-023 token-130-024 token-130-025 token-130-026 token-130-027 token-130-028 token-130-029 token-130-030 token-130-031 token-130-032 token-130-033 token-130-034 token-130-035 token-130-036 token-130-037 token-130-038 token-130-039 token-130-040 token-130-041 token-130-042 token-130-043 token-130-044 token-130-045 token-130-046 token-130-047
