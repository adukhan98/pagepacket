# note 030

Owner: sanitized-owner-150@example.test
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
pagepacket-cli snapshot . customer-notes/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-150-000 token-150-001 token-150-002 token-150-003 token-150-004 token-150-005 token-150-006 token-150-007 token-150-008 token-150-009 token-150-010 token-150-011 token-150-012 token-150-013 token-150-014 token-150-015 token-150-016 token-150-017 token-150-018 token-150-019 token-150-020 token-150-021 token-150-022 token-150-023 token-150-024 token-150-025 token-150-026 token-150-027 token-150-028 token-150-029 token-150-030 token-150-031 token-150-032 token-150-033 token-150-034 token-150-035 token-150-036 token-150-037 token-150-038 token-150-039 token-150-040 token-150-041 token-150-042 token-150-043 token-150-044 token-150-045 token-150-046 token-150-047
