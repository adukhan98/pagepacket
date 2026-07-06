# note 005

Owner: sanitized-owner-305@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-005.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-305-000 token-305-001 token-305-002 token-305-003 token-305-004 token-305-005 token-305-006 token-305-007 token-305-008 token-305-009 token-305-010 token-305-011 token-305-012 token-305-013 token-305-014 token-305-015 token-305-016 token-305-017 token-305-018 token-305-019 token-305-020 token-305-021 token-305-022 token-305-023 token-305-024 token-305-025 token-305-026 token-305-027 token-305-028 token-305-029 token-305-030 token-305-031 token-305-032 token-305-033 token-305-034 token-305-035 token-305-036 token-305-037 token-305-038 token-305-039 token-305-040 token-305-041 token-305-042 token-305-043 token-305-044 token-305-045 token-305-046 token-305-047
