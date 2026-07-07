# note 028

Owner: sanitized-owner-328@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-028.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-328-000 token-328-001 token-328-002 token-328-003 token-328-004 token-328-005 token-328-006 token-328-007 token-328-008 token-328-009 token-328-010 token-328-011 token-328-012 token-328-013 token-328-014 token-328-015 token-328-016 token-328-017 token-328-018 token-328-019 token-328-020 token-328-021 token-328-022 token-328-023 token-328-024 token-328-025 token-328-026 token-328-027 token-328-028 token-328-029 token-328-030 token-328-031 token-328-032 token-328-033 token-328-034 token-328-035 token-328-036 token-328-037 token-328-038 token-328-039 token-328-040 token-328-041 token-328-042 token-328-043 token-328-044 token-328-045 token-328-046 token-328-047
