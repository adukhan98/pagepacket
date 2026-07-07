# note 025

Owner: sanitized-owner-145@example.test
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
pagepacket-cli snapshot . customer-notes/note-025.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-145-000 token-145-001 token-145-002 token-145-003 token-145-004 token-145-005 token-145-006 token-145-007 token-145-008 token-145-009 token-145-010 token-145-011 token-145-012 token-145-013 token-145-014 token-145-015 token-145-016 token-145-017 token-145-018 token-145-019 token-145-020 token-145-021 token-145-022 token-145-023 token-145-024 token-145-025 token-145-026 token-145-027 token-145-028 token-145-029 token-145-030 token-145-031 token-145-032 token-145-033 token-145-034 token-145-035 token-145-036 token-145-037 token-145-038 token-145-039 token-145-040 token-145-041 token-145-042 token-145-043 token-145-044 token-145-045 token-145-046 token-145-047
