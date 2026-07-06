# note 004

Owner: sanitized-owner-064@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-004.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-064-000 token-064-001 token-064-002 token-064-003 token-064-004 token-064-005 token-064-006 token-064-007 token-064-008 token-064-009 token-064-010 token-064-011 token-064-012 token-064-013 token-064-014 token-064-015 token-064-016 token-064-017 token-064-018 token-064-019 token-064-020 token-064-021 token-064-022 token-064-023 token-064-024 token-064-025 token-064-026 token-064-027 token-064-028 token-064-029 token-064-030 token-064-031 token-064-032 token-064-033 token-064-034 token-064-035 token-064-036 token-064-037 token-064-038 token-064-039 token-064-040 token-064-041 token-064-042 token-064-043 token-064-044 token-064-045 token-064-046 token-064-047
