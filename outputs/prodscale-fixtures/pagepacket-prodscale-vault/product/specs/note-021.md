# note 021

Owner: sanitized-owner-021@example.test
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
pagepacket-cli snapshot . product/specs/note-021.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-021-000 token-021-001 token-021-002 token-021-003 token-021-004 token-021-005 token-021-006 token-021-007 token-021-008 token-021-009 token-021-010 token-021-011 token-021-012 token-021-013 token-021-014 token-021-015 token-021-016 token-021-017 token-021-018 token-021-019 token-021-020 token-021-021 token-021-022 token-021-023 token-021-024 token-021-025 token-021-026 token-021-027 token-021-028 token-021-029 token-021-030 token-021-031 token-021-032 token-021-033 token-021-034 token-021-035 token-021-036 token-021-037 token-021-038 token-021-039 token-021-040 token-021-041 token-021-042 token-021-043 token-021-044 token-021-045 token-021-046 token-021-047
