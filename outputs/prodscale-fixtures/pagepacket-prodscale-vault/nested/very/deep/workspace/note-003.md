# note 003

Owner: sanitized-owner-303@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-003.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-303-000 token-303-001 token-303-002 token-303-003 token-303-004 token-303-005 token-303-006 token-303-007 token-303-008 token-303-009 token-303-010 token-303-011 token-303-012 token-303-013 token-303-014 token-303-015 token-303-016 token-303-017 token-303-018 token-303-019 token-303-020 token-303-021 token-303-022 token-303-023 token-303-024 token-303-025 token-303-026 token-303-027 token-303-028 token-303-029 token-303-030 token-303-031 token-303-032 token-303-033 token-303-034 token-303-035 token-303-036 token-303-037 token-303-038 token-303-039 token-303-040 token-303-041 token-303-042 token-303-043 token-303-044 token-303-045 token-303-046 token-303-047
