# note 008

Owner: sanitized-owner-308@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-008.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-308-000 token-308-001 token-308-002 token-308-003 token-308-004 token-308-005 token-308-006 token-308-007 token-308-008 token-308-009 token-308-010 token-308-011 token-308-012 token-308-013 token-308-014 token-308-015 token-308-016 token-308-017 token-308-018 token-308-019 token-308-020 token-308-021 token-308-022 token-308-023 token-308-024 token-308-025 token-308-026 token-308-027 token-308-028 token-308-029 token-308-030 token-308-031 token-308-032 token-308-033 token-308-034 token-308-035 token-308-036 token-308-037 token-308-038 token-308-039 token-308-040 token-308-041 token-308-042 token-308-043 token-308-044 token-308-045 token-308-046 token-308-047
