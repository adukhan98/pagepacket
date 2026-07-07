# note 013

Owner: sanitized-owner-013@example.test
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
pagepacket-cli snapshot . product/specs/note-013.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-013-000 token-013-001 token-013-002 token-013-003 token-013-004 token-013-005 token-013-006 token-013-007 token-013-008 token-013-009 token-013-010 token-013-011 token-013-012 token-013-013 token-013-014 token-013-015 token-013-016 token-013-017 token-013-018 token-013-019 token-013-020 token-013-021 token-013-022 token-013-023 token-013-024 token-013-025 token-013-026 token-013-027 token-013-028 token-013-029 token-013-030 token-013-031 token-013-032 token-013-033 token-013-034 token-013-035 token-013-036 token-013-037 token-013-038 token-013-039 token-013-040 token-013-041 token-013-042 token-013-043 token-013-044 token-013-045 token-013-046 token-013-047
