# note 028

Owner: sanitized-owner-088@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-028.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-088-000 token-088-001 token-088-002 token-088-003 token-088-004 token-088-005 token-088-006 token-088-007 token-088-008 token-088-009 token-088-010 token-088-011 token-088-012 token-088-013 token-088-014 token-088-015 token-088-016 token-088-017 token-088-018 token-088-019 token-088-020 token-088-021 token-088-022 token-088-023 token-088-024 token-088-025 token-088-026 token-088-027 token-088-028 token-088-029 token-088-030 token-088-031 token-088-032 token-088-033 token-088-034 token-088-035 token-088-036 token-088-037 token-088-038 token-088-039 token-088-040 token-088-041 token-088-042 token-088-043 token-088-044 token-088-045 token-088-046 token-088-047
