# note 013

Owner: sanitized-owner-103@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-013.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-103-000 token-103-001 token-103-002 token-103-003 token-103-004 token-103-005 token-103-006 token-103-007 token-103-008 token-103-009 token-103-010 token-103-011 token-103-012 token-103-013 token-103-014 token-103-015 token-103-016 token-103-017 token-103-018 token-103-019 token-103-020 token-103-021 token-103-022 token-103-023 token-103-024 token-103-025 token-103-026 token-103-027 token-103-028 token-103-029 token-103-030 token-103-031 token-103-032 token-103-033 token-103-034 token-103-035 token-103-036 token-103-037 token-103-038 token-103-039 token-103-040 token-103-041 token-103-042 token-103-043 token-103-044 token-103-045 token-103-046 token-103-047
