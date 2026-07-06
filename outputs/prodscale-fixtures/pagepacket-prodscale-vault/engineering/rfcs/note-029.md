# note 029

Owner: sanitized-owner-089@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-029.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-089-000 token-089-001 token-089-002 token-089-003 token-089-004 token-089-005 token-089-006 token-089-007 token-089-008 token-089-009 token-089-010 token-089-011 token-089-012 token-089-013 token-089-014 token-089-015 token-089-016 token-089-017 token-089-018 token-089-019 token-089-020 token-089-021 token-089-022 token-089-023 token-089-024 token-089-025 token-089-026 token-089-027 token-089-028 token-089-029 token-089-030 token-089-031 token-089-032 token-089-033 token-089-034 token-089-035 token-089-036 token-089-037 token-089-038 token-089-039 token-089-040 token-089-041 token-089-042 token-089-043 token-089-044 token-089-045 token-089-046 token-089-047
