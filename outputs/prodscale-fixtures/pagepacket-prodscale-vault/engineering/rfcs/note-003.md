# note 003

Owner: sanitized-owner-063@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-003.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-063-000 token-063-001 token-063-002 token-063-003 token-063-004 token-063-005 token-063-006 token-063-007 token-063-008 token-063-009 token-063-010 token-063-011 token-063-012 token-063-013 token-063-014 token-063-015 token-063-016 token-063-017 token-063-018 token-063-019 token-063-020 token-063-021 token-063-022 token-063-023 token-063-024 token-063-025 token-063-026 token-063-027 token-063-028 token-063-029 token-063-030 token-063-031 token-063-032 token-063-033 token-063-034 token-063-035 token-063-036 token-063-037 token-063-038 token-063-039 token-063-040 token-063-041 token-063-042 token-063-043 token-063-044 token-063-045 token-063-046 token-063-047
