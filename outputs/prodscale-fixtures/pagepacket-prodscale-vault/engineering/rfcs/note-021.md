# note 021

Owner: sanitized-owner-081@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-021.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-081-000 token-081-001 token-081-002 token-081-003 token-081-004 token-081-005 token-081-006 token-081-007 token-081-008 token-081-009 token-081-010 token-081-011 token-081-012 token-081-013 token-081-014 token-081-015 token-081-016 token-081-017 token-081-018 token-081-019 token-081-020 token-081-021 token-081-022 token-081-023 token-081-024 token-081-025 token-081-026 token-081-027 token-081-028 token-081-029 token-081-030 token-081-031 token-081-032 token-081-033 token-081-034 token-081-035 token-081-036 token-081-037 token-081-038 token-081-039 token-081-040 token-081-041 token-081-042 token-081-043 token-081-044 token-081-045 token-081-046 token-081-047
