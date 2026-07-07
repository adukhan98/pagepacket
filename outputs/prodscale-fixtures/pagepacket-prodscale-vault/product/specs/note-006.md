# note 006

Owner: sanitized-owner-006@example.test
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
pagepacket-cli snapshot . product/specs/note-006.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-006-000 token-006-001 token-006-002 token-006-003 token-006-004 token-006-005 token-006-006 token-006-007 token-006-008 token-006-009 token-006-010 token-006-011 token-006-012 token-006-013 token-006-014 token-006-015 token-006-016 token-006-017 token-006-018 token-006-019 token-006-020 token-006-021 token-006-022 token-006-023 token-006-024 token-006-025 token-006-026 token-006-027 token-006-028 token-006-029 token-006-030 token-006-031 token-006-032 token-006-033 token-006-034 token-006-035 token-006-036 token-006-037 token-006-038 token-006-039 token-006-040 token-006-041 token-006-042 token-006-043 token-006-044 token-006-045 token-006-046 token-006-047
