# note 014

Owner: sanitized-owner-104@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-014.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-104-000 token-104-001 token-104-002 token-104-003 token-104-004 token-104-005 token-104-006 token-104-007 token-104-008 token-104-009 token-104-010 token-104-011 token-104-012 token-104-013 token-104-014 token-104-015 token-104-016 token-104-017 token-104-018 token-104-019 token-104-020 token-104-021 token-104-022 token-104-023 token-104-024 token-104-025 token-104-026 token-104-027 token-104-028 token-104-029 token-104-030 token-104-031 token-104-032 token-104-033 token-104-034 token-104-035 token-104-036 token-104-037 token-104-038 token-104-039 token-104-040 token-104-041 token-104-042 token-104-043 token-104-044 token-104-045 token-104-046 token-104-047
