# note 028

Owner: sanitized-owner-148@example.test
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
pagepacket-cli snapshot . customer-notes/note-028.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-148-000 token-148-001 token-148-002 token-148-003 token-148-004 token-148-005 token-148-006 token-148-007 token-148-008 token-148-009 token-148-010 token-148-011 token-148-012 token-148-013 token-148-014 token-148-015 token-148-016 token-148-017 token-148-018 token-148-019 token-148-020 token-148-021 token-148-022 token-148-023 token-148-024 token-148-025 token-148-026 token-148-027 token-148-028 token-148-029 token-148-030 token-148-031 token-148-032 token-148-033 token-148-034 token-148-035 token-148-036 token-148-037 token-148-038 token-148-039 token-148-040 token-148-041 token-148-042 token-148-043 token-148-044 token-148-045 token-148-046 token-148-047
