# note 013

Owner: sanitized-owner-073@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-013.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-073-000 token-073-001 token-073-002 token-073-003 token-073-004 token-073-005 token-073-006 token-073-007 token-073-008 token-073-009 token-073-010 token-073-011 token-073-012 token-073-013 token-073-014 token-073-015 token-073-016 token-073-017 token-073-018 token-073-019 token-073-020 token-073-021 token-073-022 token-073-023 token-073-024 token-073-025 token-073-026 token-073-027 token-073-028 token-073-029 token-073-030 token-073-031 token-073-032 token-073-033 token-073-034 token-073-035 token-073-036 token-073-037 token-073-038 token-073-039 token-073-040 token-073-041 token-073-042 token-073-043 token-073-044 token-073-045 token-073-046 token-073-047
