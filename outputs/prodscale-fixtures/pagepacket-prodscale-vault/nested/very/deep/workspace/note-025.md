# note 025

Owner: sanitized-owner-325@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-025.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-325-000 token-325-001 token-325-002 token-325-003 token-325-004 token-325-005 token-325-006 token-325-007 token-325-008 token-325-009 token-325-010 token-325-011 token-325-012 token-325-013 token-325-014 token-325-015 token-325-016 token-325-017 token-325-018 token-325-019 token-325-020 token-325-021 token-325-022 token-325-023 token-325-024 token-325-025 token-325-026 token-325-027 token-325-028 token-325-029 token-325-030 token-325-031 token-325-032 token-325-033 token-325-034 token-325-035 token-325-036 token-325-037 token-325-038 token-325-039 token-325-040 token-325-041 token-325-042 token-325-043 token-325-044 token-325-045 token-325-046 token-325-047
