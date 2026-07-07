# note 010

Owner: sanitized-owner-220@example.test
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
pagepacket-cli snapshot . knowledge/base/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-220-000 token-220-001 token-220-002 token-220-003 token-220-004 token-220-005 token-220-006 token-220-007 token-220-008 token-220-009 token-220-010 token-220-011 token-220-012 token-220-013 token-220-014 token-220-015 token-220-016 token-220-017 token-220-018 token-220-019 token-220-020 token-220-021 token-220-022 token-220-023 token-220-024 token-220-025 token-220-026 token-220-027 token-220-028 token-220-029 token-220-030 token-220-031 token-220-032 token-220-033 token-220-034 token-220-035 token-220-036 token-220-037 token-220-038 token-220-039 token-220-040 token-220-041 token-220-042 token-220-043 token-220-044 token-220-045 token-220-046 token-220-047
