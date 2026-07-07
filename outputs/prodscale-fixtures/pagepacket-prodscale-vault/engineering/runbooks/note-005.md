# note 005

Owner: sanitized-owner-095@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-005.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-095-000 token-095-001 token-095-002 token-095-003 token-095-004 token-095-005 token-095-006 token-095-007 token-095-008 token-095-009 token-095-010 token-095-011 token-095-012 token-095-013 token-095-014 token-095-015 token-095-016 token-095-017 token-095-018 token-095-019 token-095-020 token-095-021 token-095-022 token-095-023 token-095-024 token-095-025 token-095-026 token-095-027 token-095-028 token-095-029 token-095-030 token-095-031 token-095-032 token-095-033 token-095-034 token-095-035 token-095-036 token-095-037 token-095-038 token-095-039 token-095-040 token-095-041 token-095-042 token-095-043 token-095-044 token-095-045 token-095-046 token-095-047
