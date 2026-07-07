# note 026

Owner: sanitized-owner-086@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-026.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-086-000 token-086-001 token-086-002 token-086-003 token-086-004 token-086-005 token-086-006 token-086-007 token-086-008 token-086-009 token-086-010 token-086-011 token-086-012 token-086-013 token-086-014 token-086-015 token-086-016 token-086-017 token-086-018 token-086-019 token-086-020 token-086-021 token-086-022 token-086-023 token-086-024 token-086-025 token-086-026 token-086-027 token-086-028 token-086-029 token-086-030 token-086-031 token-086-032 token-086-033 token-086-034 token-086-035 token-086-036 token-086-037 token-086-038 token-086-039 token-086-040 token-086-041 token-086-042 token-086-043 token-086-044 token-086-045 token-086-046 token-086-047
