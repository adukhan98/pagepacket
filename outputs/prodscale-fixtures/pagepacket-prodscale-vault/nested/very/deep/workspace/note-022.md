# note 022

Owner: sanitized-owner-322@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-022.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-322-000 token-322-001 token-322-002 token-322-003 token-322-004 token-322-005 token-322-006 token-322-007 token-322-008 token-322-009 token-322-010 token-322-011 token-322-012 token-322-013 token-322-014 token-322-015 token-322-016 token-322-017 token-322-018 token-322-019 token-322-020 token-322-021 token-322-022 token-322-023 token-322-024 token-322-025 token-322-026 token-322-027 token-322-028 token-322-029 token-322-030 token-322-031 token-322-032 token-322-033 token-322-034 token-322-035 token-322-036 token-322-037 token-322-038 token-322-039 token-322-040 token-322-041 token-322-042 token-322-043 token-322-044 token-322-045 token-322-046 token-322-047
