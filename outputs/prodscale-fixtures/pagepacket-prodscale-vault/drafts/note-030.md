# note 030

Owner: sanitized-owner-360@example.test
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
pagepacket-cli snapshot . drafts/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-360-000 token-360-001 token-360-002 token-360-003 token-360-004 token-360-005 token-360-006 token-360-007 token-360-008 token-360-009 token-360-010 token-360-011 token-360-012 token-360-013 token-360-014 token-360-015 token-360-016 token-360-017 token-360-018 token-360-019 token-360-020 token-360-021 token-360-022 token-360-023 token-360-024 token-360-025 token-360-026 token-360-027 token-360-028 token-360-029 token-360-030 token-360-031 token-360-032 token-360-033 token-360-034 token-360-035 token-360-036 token-360-037 token-360-038 token-360-039 token-360-040 token-360-041 token-360-042 token-360-043 token-360-044 token-360-045 token-360-046 token-360-047
