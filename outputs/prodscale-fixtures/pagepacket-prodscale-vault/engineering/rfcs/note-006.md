# note 006

Owner: sanitized-owner-066@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-006.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-066-000 token-066-001 token-066-002 token-066-003 token-066-004 token-066-005 token-066-006 token-066-007 token-066-008 token-066-009 token-066-010 token-066-011 token-066-012 token-066-013 token-066-014 token-066-015 token-066-016 token-066-017 token-066-018 token-066-019 token-066-020 token-066-021 token-066-022 token-066-023 token-066-024 token-066-025 token-066-026 token-066-027 token-066-028 token-066-029 token-066-030 token-066-031 token-066-032 token-066-033 token-066-034 token-066-035 token-066-036 token-066-037 token-066-038 token-066-039 token-066-040 token-066-041 token-066-042 token-066-043 token-066-044 token-066-045 token-066-046 token-066-047
