# note 011

Owner: sanitized-owner-071@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-011.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-071-000 token-071-001 token-071-002 token-071-003 token-071-004 token-071-005 token-071-006 token-071-007 token-071-008 token-071-009 token-071-010 token-071-011 token-071-012 token-071-013 token-071-014 token-071-015 token-071-016 token-071-017 token-071-018 token-071-019 token-071-020 token-071-021 token-071-022 token-071-023 token-071-024 token-071-025 token-071-026 token-071-027 token-071-028 token-071-029 token-071-030 token-071-031 token-071-032 token-071-033 token-071-034 token-071-035 token-071-036 token-071-037 token-071-038 token-071-039 token-071-040 token-071-041 token-071-042 token-071-043 token-071-044 token-071-045 token-071-046 token-071-047
