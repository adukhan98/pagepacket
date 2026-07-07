# note 017

Owner: sanitized-owner-107@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-017.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-107-000 token-107-001 token-107-002 token-107-003 token-107-004 token-107-005 token-107-006 token-107-007 token-107-008 token-107-009 token-107-010 token-107-011 token-107-012 token-107-013 token-107-014 token-107-015 token-107-016 token-107-017 token-107-018 token-107-019 token-107-020 token-107-021 token-107-022 token-107-023 token-107-024 token-107-025 token-107-026 token-107-027 token-107-028 token-107-029 token-107-030 token-107-031 token-107-032 token-107-033 token-107-034 token-107-035 token-107-036 token-107-037 token-107-038 token-107-039 token-107-040 token-107-041 token-107-042 token-107-043 token-107-044 token-107-045 token-107-046 token-107-047
