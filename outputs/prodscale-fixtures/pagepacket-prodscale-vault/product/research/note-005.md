# note 005

Owner: sanitized-owner-035@example.test
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
pagepacket-cli snapshot . product/research/note-005.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-035-000 token-035-001 token-035-002 token-035-003 token-035-004 token-035-005 token-035-006 token-035-007 token-035-008 token-035-009 token-035-010 token-035-011 token-035-012 token-035-013 token-035-014 token-035-015 token-035-016 token-035-017 token-035-018 token-035-019 token-035-020 token-035-021 token-035-022 token-035-023 token-035-024 token-035-025 token-035-026 token-035-027 token-035-028 token-035-029 token-035-030 token-035-031 token-035-032 token-035-033 token-035-034 token-035-035 token-035-036 token-035-037 token-035-038 token-035-039 token-035-040 token-035-041 token-035-042 token-035-043 token-035-044 token-035-045 token-035-046 token-035-047
