# note 016

Owner: sanitized-owner-106@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-016.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-106-000 token-106-001 token-106-002 token-106-003 token-106-004 token-106-005 token-106-006 token-106-007 token-106-008 token-106-009 token-106-010 token-106-011 token-106-012 token-106-013 token-106-014 token-106-015 token-106-016 token-106-017 token-106-018 token-106-019 token-106-020 token-106-021 token-106-022 token-106-023 token-106-024 token-106-025 token-106-026 token-106-027 token-106-028 token-106-029 token-106-030 token-106-031 token-106-032 token-106-033 token-106-034 token-106-035 token-106-036 token-106-037 token-106-038 token-106-039 token-106-040 token-106-041 token-106-042 token-106-043 token-106-044 token-106-045 token-106-046 token-106-047
