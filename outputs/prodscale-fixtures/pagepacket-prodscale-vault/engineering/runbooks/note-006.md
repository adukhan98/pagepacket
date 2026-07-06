# note 006

Owner: sanitized-owner-096@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-006.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-096-000 token-096-001 token-096-002 token-096-003 token-096-004 token-096-005 token-096-006 token-096-007 token-096-008 token-096-009 token-096-010 token-096-011 token-096-012 token-096-013 token-096-014 token-096-015 token-096-016 token-096-017 token-096-018 token-096-019 token-096-020 token-096-021 token-096-022 token-096-023 token-096-024 token-096-025 token-096-026 token-096-027 token-096-028 token-096-029 token-096-030 token-096-031 token-096-032 token-096-033 token-096-034 token-096-035 token-096-036 token-096-037 token-096-038 token-096-039 token-096-040 token-096-041 token-096-042 token-096-043 token-096-044 token-096-045 token-096-046 token-096-047
