# note 009

Owner: sanitized-owner-129@example.test
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
pagepacket-cli snapshot . customer-notes/note-009.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-129-000 token-129-001 token-129-002 token-129-003 token-129-004 token-129-005 token-129-006 token-129-007 token-129-008 token-129-009 token-129-010 token-129-011 token-129-012 token-129-013 token-129-014 token-129-015 token-129-016 token-129-017 token-129-018 token-129-019 token-129-020 token-129-021 token-129-022 token-129-023 token-129-024 token-129-025 token-129-026 token-129-027 token-129-028 token-129-029 token-129-030 token-129-031 token-129-032 token-129-033 token-129-034 token-129-035 token-129-036 token-129-037 token-129-038 token-129-039 token-129-040 token-129-041 token-129-042 token-129-043 token-129-044 token-129-045 token-129-046 token-129-047
