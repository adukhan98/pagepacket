# note 020

Owner: sanitized-owner-110@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-020.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-110-000 token-110-001 token-110-002 token-110-003 token-110-004 token-110-005 token-110-006 token-110-007 token-110-008 token-110-009 token-110-010 token-110-011 token-110-012 token-110-013 token-110-014 token-110-015 token-110-016 token-110-017 token-110-018 token-110-019 token-110-020 token-110-021 token-110-022 token-110-023 token-110-024 token-110-025 token-110-026 token-110-027 token-110-028 token-110-029 token-110-030 token-110-031 token-110-032 token-110-033 token-110-034 token-110-035 token-110-036 token-110-037 token-110-038 token-110-039 token-110-040 token-110-041 token-110-042 token-110-043 token-110-044 token-110-045 token-110-046 token-110-047
