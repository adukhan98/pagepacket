# note 026

Owner: sanitized-owner-116@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-026.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-116-000 token-116-001 token-116-002 token-116-003 token-116-004 token-116-005 token-116-006 token-116-007 token-116-008 token-116-009 token-116-010 token-116-011 token-116-012 token-116-013 token-116-014 token-116-015 token-116-016 token-116-017 token-116-018 token-116-019 token-116-020 token-116-021 token-116-022 token-116-023 token-116-024 token-116-025 token-116-026 token-116-027 token-116-028 token-116-029 token-116-030 token-116-031 token-116-032 token-116-033 token-116-034 token-116-035 token-116-036 token-116-037 token-116-038 token-116-039 token-116-040 token-116-041 token-116-042 token-116-043 token-116-044 token-116-045 token-116-046 token-116-047
