# note 006

Owner: sanitized-owner-036@example.test
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
pagepacket-cli snapshot . product/research/note-006.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-036-000 token-036-001 token-036-002 token-036-003 token-036-004 token-036-005 token-036-006 token-036-007 token-036-008 token-036-009 token-036-010 token-036-011 token-036-012 token-036-013 token-036-014 token-036-015 token-036-016 token-036-017 token-036-018 token-036-019 token-036-020 token-036-021 token-036-022 token-036-023 token-036-024 token-036-025 token-036-026 token-036-027 token-036-028 token-036-029 token-036-030 token-036-031 token-036-032 token-036-033 token-036-034 token-036-035 token-036-036 token-036-037 token-036-038 token-036-039 token-036-040 token-036-041 token-036-042 token-036-043 token-036-044 token-036-045 token-036-046 token-036-047
