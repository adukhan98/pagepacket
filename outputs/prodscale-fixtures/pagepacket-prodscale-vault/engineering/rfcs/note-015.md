# note 015

Owner: sanitized-owner-075@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-015.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-075-000 token-075-001 token-075-002 token-075-003 token-075-004 token-075-005 token-075-006 token-075-007 token-075-008 token-075-009 token-075-010 token-075-011 token-075-012 token-075-013 token-075-014 token-075-015 token-075-016 token-075-017 token-075-018 token-075-019 token-075-020 token-075-021 token-075-022 token-075-023 token-075-024 token-075-025 token-075-026 token-075-027 token-075-028 token-075-029 token-075-030 token-075-031 token-075-032 token-075-033 token-075-034 token-075-035 token-075-036 token-075-037 token-075-038 token-075-039 token-075-040 token-075-041 token-075-042 token-075-043 token-075-044 token-075-045 token-075-046 token-075-047
