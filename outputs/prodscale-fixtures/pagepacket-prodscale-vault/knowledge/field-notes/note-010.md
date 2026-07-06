# note 010

Owner: sanitized-owner-250@example.test
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
pagepacket-cli snapshot . knowledge/field-notes/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-250-000 token-250-001 token-250-002 token-250-003 token-250-004 token-250-005 token-250-006 token-250-007 token-250-008 token-250-009 token-250-010 token-250-011 token-250-012 token-250-013 token-250-014 token-250-015 token-250-016 token-250-017 token-250-018 token-250-019 token-250-020 token-250-021 token-250-022 token-250-023 token-250-024 token-250-025 token-250-026 token-250-027 token-250-028 token-250-029 token-250-030 token-250-031 token-250-032 token-250-033 token-250-034 token-250-035 token-250-036 token-250-037 token-250-038 token-250-039 token-250-040 token-250-041 token-250-042 token-250-043 token-250-044 token-250-045 token-250-046 token-250-047
