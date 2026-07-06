# note 002

Owner: sanitized-owner-002@example.test
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
pagepacket-cli snapshot . product/specs/note-002.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-002-000 token-002-001 token-002-002 token-002-003 token-002-004 token-002-005 token-002-006 token-002-007 token-002-008 token-002-009 token-002-010 token-002-011 token-002-012 token-002-013 token-002-014 token-002-015 token-002-016 token-002-017 token-002-018 token-002-019 token-002-020 token-002-021 token-002-022 token-002-023 token-002-024 token-002-025 token-002-026 token-002-027 token-002-028 token-002-029 token-002-030 token-002-031 token-002-032 token-002-033 token-002-034 token-002-035 token-002-036 token-002-037 token-002-038 token-002-039 token-002-040 token-002-041 token-002-042 token-002-043 token-002-044 token-002-045 token-002-046 token-002-047
