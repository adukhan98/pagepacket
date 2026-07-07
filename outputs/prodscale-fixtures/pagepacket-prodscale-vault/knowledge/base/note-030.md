# note 030

Owner: sanitized-owner-240@example.test
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
pagepacket-cli snapshot . knowledge/base/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-240-000 token-240-001 token-240-002 token-240-003 token-240-004 token-240-005 token-240-006 token-240-007 token-240-008 token-240-009 token-240-010 token-240-011 token-240-012 token-240-013 token-240-014 token-240-015 token-240-016 token-240-017 token-240-018 token-240-019 token-240-020 token-240-021 token-240-022 token-240-023 token-240-024 token-240-025 token-240-026 token-240-027 token-240-028 token-240-029 token-240-030 token-240-031 token-240-032 token-240-033 token-240-034 token-240-035 token-240-036 token-240-037 token-240-038 token-240-039 token-240-040 token-240-041 token-240-042 token-240-043 token-240-044 token-240-045 token-240-046 token-240-047
