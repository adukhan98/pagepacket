# note 028

Owner: sanitized-owner-118@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-028.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-118-000 token-118-001 token-118-002 token-118-003 token-118-004 token-118-005 token-118-006 token-118-007 token-118-008 token-118-009 token-118-010 token-118-011 token-118-012 token-118-013 token-118-014 token-118-015 token-118-016 token-118-017 token-118-018 token-118-019 token-118-020 token-118-021 token-118-022 token-118-023 token-118-024 token-118-025 token-118-026 token-118-027 token-118-028 token-118-029 token-118-030 token-118-031 token-118-032 token-118-033 token-118-034 token-118-035 token-118-036 token-118-037 token-118-038 token-118-039 token-118-040 token-118-041 token-118-042 token-118-043 token-118-044 token-118-045 token-118-046 token-118-047
