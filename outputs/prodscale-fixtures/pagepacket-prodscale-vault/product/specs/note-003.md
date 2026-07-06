# note 003

Owner: sanitized-owner-003@example.test
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
pagepacket-cli snapshot . product/specs/note-003.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-003-000 token-003-001 token-003-002 token-003-003 token-003-004 token-003-005 token-003-006 token-003-007 token-003-008 token-003-009 token-003-010 token-003-011 token-003-012 token-003-013 token-003-014 token-003-015 token-003-016 token-003-017 token-003-018 token-003-019 token-003-020 token-003-021 token-003-022 token-003-023 token-003-024 token-003-025 token-003-026 token-003-027 token-003-028 token-003-029 token-003-030 token-003-031 token-003-032 token-003-033 token-003-034 token-003-035 token-003-036 token-003-037 token-003-038 token-003-039 token-003-040 token-003-041 token-003-042 token-003-043 token-003-044 token-003-045 token-003-046 token-003-047
