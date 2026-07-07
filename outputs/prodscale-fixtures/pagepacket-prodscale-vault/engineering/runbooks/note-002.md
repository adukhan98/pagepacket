# note 002

Owner: sanitized-owner-092@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-002.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-092-000 token-092-001 token-092-002 token-092-003 token-092-004 token-092-005 token-092-006 token-092-007 token-092-008 token-092-009 token-092-010 token-092-011 token-092-012 token-092-013 token-092-014 token-092-015 token-092-016 token-092-017 token-092-018 token-092-019 token-092-020 token-092-021 token-092-022 token-092-023 token-092-024 token-092-025 token-092-026 token-092-027 token-092-028 token-092-029 token-092-030 token-092-031 token-092-032 token-092-033 token-092-034 token-092-035 token-092-036 token-092-037 token-092-038 token-092-039 token-092-040 token-092-041 token-092-042 token-092-043 token-092-044 token-092-045 token-092-046 token-092-047
