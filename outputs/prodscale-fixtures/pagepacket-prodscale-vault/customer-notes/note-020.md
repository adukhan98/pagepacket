# note 020

Owner: sanitized-owner-140@example.test
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
pagepacket-cli snapshot . customer-notes/note-020.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-140-000 token-140-001 token-140-002 token-140-003 token-140-004 token-140-005 token-140-006 token-140-007 token-140-008 token-140-009 token-140-010 token-140-011 token-140-012 token-140-013 token-140-014 token-140-015 token-140-016 token-140-017 token-140-018 token-140-019 token-140-020 token-140-021 token-140-022 token-140-023 token-140-024 token-140-025 token-140-026 token-140-027 token-140-028 token-140-029 token-140-030 token-140-031 token-140-032 token-140-033 token-140-034 token-140-035 token-140-036 token-140-037 token-140-038 token-140-039 token-140-040 token-140-041 token-140-042 token-140-043 token-140-044 token-140-045 token-140-046 token-140-047
