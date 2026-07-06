# note 022

Owner: sanitized-owner-082@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-022.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-082-000 token-082-001 token-082-002 token-082-003 token-082-004 token-082-005 token-082-006 token-082-007 token-082-008 token-082-009 token-082-010 token-082-011 token-082-012 token-082-013 token-082-014 token-082-015 token-082-016 token-082-017 token-082-018 token-082-019 token-082-020 token-082-021 token-082-022 token-082-023 token-082-024 token-082-025 token-082-026 token-082-027 token-082-028 token-082-029 token-082-030 token-082-031 token-082-032 token-082-033 token-082-034 token-082-035 token-082-036 token-082-037 token-082-038 token-082-039 token-082-040 token-082-041 token-082-042 token-082-043 token-082-044 token-082-045 token-082-046 token-082-047
