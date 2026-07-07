# note 012

Owner: sanitized-owner-072@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-012.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-072-000 token-072-001 token-072-002 token-072-003 token-072-004 token-072-005 token-072-006 token-072-007 token-072-008 token-072-009 token-072-010 token-072-011 token-072-012 token-072-013 token-072-014 token-072-015 token-072-016 token-072-017 token-072-018 token-072-019 token-072-020 token-072-021 token-072-022 token-072-023 token-072-024 token-072-025 token-072-026 token-072-027 token-072-028 token-072-029 token-072-030 token-072-031 token-072-032 token-072-033 token-072-034 token-072-035 token-072-036 token-072-037 token-072-038 token-072-039 token-072-040 token-072-041 token-072-042 token-072-043 token-072-044 token-072-045 token-072-046 token-072-047
