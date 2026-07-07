# note 012

Owner: sanitized-owner-102@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-012.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-102-000 token-102-001 token-102-002 token-102-003 token-102-004 token-102-005 token-102-006 token-102-007 token-102-008 token-102-009 token-102-010 token-102-011 token-102-012 token-102-013 token-102-014 token-102-015 token-102-016 token-102-017 token-102-018 token-102-019 token-102-020 token-102-021 token-102-022 token-102-023 token-102-024 token-102-025 token-102-026 token-102-027 token-102-028 token-102-029 token-102-030 token-102-031 token-102-032 token-102-033 token-102-034 token-102-035 token-102-036 token-102-037 token-102-038 token-102-039 token-102-040 token-102-041 token-102-042 token-102-043 token-102-044 token-102-045 token-102-046 token-102-047
