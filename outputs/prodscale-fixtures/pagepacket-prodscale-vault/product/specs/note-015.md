# note 015

Owner: sanitized-owner-015@example.test
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
pagepacket-cli snapshot . product/specs/note-015.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-015-000 token-015-001 token-015-002 token-015-003 token-015-004 token-015-005 token-015-006 token-015-007 token-015-008 token-015-009 token-015-010 token-015-011 token-015-012 token-015-013 token-015-014 token-015-015 token-015-016 token-015-017 token-015-018 token-015-019 token-015-020 token-015-021 token-015-022 token-015-023 token-015-024 token-015-025 token-015-026 token-015-027 token-015-028 token-015-029 token-015-030 token-015-031 token-015-032 token-015-033 token-015-034 token-015-035 token-015-036 token-015-037 token-015-038 token-015-039 token-015-040 token-015-041 token-015-042 token-015-043 token-015-044 token-015-045 token-015-046 token-015-047
