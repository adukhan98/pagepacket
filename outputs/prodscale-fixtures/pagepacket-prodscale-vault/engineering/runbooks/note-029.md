# note 029

Owner: sanitized-owner-119@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-029.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-119-000 token-119-001 token-119-002 token-119-003 token-119-004 token-119-005 token-119-006 token-119-007 token-119-008 token-119-009 token-119-010 token-119-011 token-119-012 token-119-013 token-119-014 token-119-015 token-119-016 token-119-017 token-119-018 token-119-019 token-119-020 token-119-021 token-119-022 token-119-023 token-119-024 token-119-025 token-119-026 token-119-027 token-119-028 token-119-029 token-119-030 token-119-031 token-119-032 token-119-033 token-119-034 token-119-035 token-119-036 token-119-037 token-119-038 token-119-039 token-119-040 token-119-041 token-119-042 token-119-043 token-119-044 token-119-045 token-119-046 token-119-047
