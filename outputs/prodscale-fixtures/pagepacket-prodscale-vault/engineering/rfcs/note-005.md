# note 005

Owner: sanitized-owner-065@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-005.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-065-000 token-065-001 token-065-002 token-065-003 token-065-004 token-065-005 token-065-006 token-065-007 token-065-008 token-065-009 token-065-010 token-065-011 token-065-012 token-065-013 token-065-014 token-065-015 token-065-016 token-065-017 token-065-018 token-065-019 token-065-020 token-065-021 token-065-022 token-065-023 token-065-024 token-065-025 token-065-026 token-065-027 token-065-028 token-065-029 token-065-030 token-065-031 token-065-032 token-065-033 token-065-034 token-065-035 token-065-036 token-065-037 token-065-038 token-065-039 token-065-040 token-065-041 token-065-042 token-065-043 token-065-044 token-065-045 token-065-046 token-065-047
