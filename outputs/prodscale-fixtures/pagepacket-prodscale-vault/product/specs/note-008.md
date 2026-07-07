# note 008

Owner: sanitized-owner-008@example.test
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
pagepacket-cli snapshot . product/specs/note-008.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-008-000 token-008-001 token-008-002 token-008-003 token-008-004 token-008-005 token-008-006 token-008-007 token-008-008 token-008-009 token-008-010 token-008-011 token-008-012 token-008-013 token-008-014 token-008-015 token-008-016 token-008-017 token-008-018 token-008-019 token-008-020 token-008-021 token-008-022 token-008-023 token-008-024 token-008-025 token-008-026 token-008-027 token-008-028 token-008-029 token-008-030 token-008-031 token-008-032 token-008-033 token-008-034 token-008-035 token-008-036 token-008-037 token-008-038 token-008-039 token-008-040 token-008-041 token-008-042 token-008-043 token-008-044 token-008-045 token-008-046 token-008-047
